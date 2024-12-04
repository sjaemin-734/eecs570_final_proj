# Master script that calls other scripts to convert .cnf SAT
# problems to .mif inputs for memory modules in hardware SAT solver
# Usage (from parent directory): python3 script/convert_problems.py

import os

# Create directory for reduced files if it doesn't exist yet
os.makedirs("reduced", exist_ok=True)

# Create directory for processed files if it doesn't exist yet
os.makedirs("preprocessed", exist_ok=True)

# Call the other scripts

print("Running scripts to convert .cnf to binary inputs...")
directory = os.fsencode("sat_problems")
for file in os.listdir(directory):
    name = f"sat_problems/{file.decode('utf-8')}"
    os.system(f"python3 script/reduce_cnf.py {name}")
    name = f"reduced/{file.decode('utf-8')}"
    os.system(f"python3 script/clause_database.py {name}")
    os.system(f"python3 script/clause_and_vse_tables.py {name}")
    os.system(f"python3 script/decider.py {name}")
    # Removing reduced file
    
# Convert raw binary outputs from the scripts into .mif
# .mif = Memory Initialization File

print("Converting binary inputs to .mif files...")
directory = os.fsencode("preprocessed")
for file in os.listdir(directory):
    # Name of file in directory
    name = file.decode("utf-8")
    split_name = name.split(".")
    
    if split_name[1] == "txt":
        # Read .text file
        f_handle = open(f"preprocessed/{name}", 'r')
        # Create .mif file
        mif_handle = open(f"preprocessed/{split_name[0]}.mif", 'w+')
        
        # Obtain length of file and width and write to .mif
        file_lines = f_handle.readlines()
        file_length = len(file_lines)
        file_width = len(file_lines[0].strip())
        mif_handle.write(f"DEPTH = {file_length};\n")
        mif_handle.write(f"WIDTH = {file_width};\n")
        
        # Set radix of address and data
        mif_handle.write("ADDRESS_RADIX = DEC;\n")
        mif_handle.write("DATA_RADIX = BIN;\n")
        
        # Begin writing content
        mif_handle.write("\n")
        mif_handle.write("CONTENT\n")
        mif_handle.write("BEGIN\n")
        
        line_counter = 0
        for file_line in file_lines:
            line_content = file_line.strip()
            mif_handle.write(f"{line_counter}\t\t:\t{line_content};\n")
            line_counter += 1
        mif_handle.write("END;")
        
        # Close .txt and .mif files
        f_handle.close()
        mif_handle.close()

# Delete the .txt files generated by the sub scripts
print("Deleting binary input files...")
for file in os.listdir(directory):
    name = file.decode("utf-8")
    if name.endswith(".txt"):
        os.remove(os.path.join(directory, file))

print(".mif file generation complete")