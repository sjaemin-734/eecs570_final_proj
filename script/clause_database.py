import os
import sys

# Included these as variables so that they can be changed if needed
N_SAT = 5
BITS = 9
MAX_CLAUSES = 1024

# IN_ORDER = true: mask and poles are in ascending order (1,2,3,4,5)
# IN_ORDER = false: mask and poles are in descending order (1,2,3,4,5)
IN_ORDER = True

# Debug mode prints the vars in decimal and the masks in binary (in string form)
DEBUG = False

if len(sys.argv) < 1:
    print("Error: no file specified!")
    exit(1)

# Create directory for processed files if it doesn't exist yet
os.makedirs("preprocessed", exist_ok=True)

filename = str(sys.argv[1])
# print(filename)
file = open(filename, 'r')
num_vars, num_clauses = None, None

# Set up output files
basefile = os.path.basename(filename)    # Remove path
basefile = basefile.split(".")[0]  # Remove file extension from input file
write_clause_database = open(f"preprocessed/{basefile}_clause_database.txt", "w+")

# clause_db format:
# Mask[5], Pole[5], Var[5:1][9]
clause_db = []

# Finding header
while True:
    line = file.readline()
    if line and line[0] == 'p':
        words = line.split()
        num_vars, num_clauses = int(words[2]), int(words[3])
        break

clause_num = 1

while True:
    # To stop it running forever
    if clause_num > num_clauses:
        break
    line = file.readline()
    
    # Finish at EOF
    if not line:
        break
    
    # Skip comments
    if line[0] == 'c':
        continue
    else:
        vars = line.split()
        clause_db.append([2**N_SAT - 1]) # mask is initially all ones
        clause_db[clause_num-1].append(2**N_SAT - 1) # start with all negated and XOR away variables that are not

        i = 0
        temp = []
        for var in vars:
            if var != '0':
                var = int(var)

                # Clearing pole bit if var is not negated
                if var > 0:
                    shift = N_SAT - 1 - i if IN_ORDER else i
                    clause_db[clause_num-1][1] ^= (1 << shift)
                
                # Clauses need to be stored as absolute numbers
                var = abs(var)
                clause_db[clause_num-1].append(var)

                i += 1

        # Clearing mask bits for clauses that are not BITS-SAT
        if IN_ORDER:
            for j in range(N_SAT-i):
                clause_db[clause_num-1][0] ^= (1 << j)
        else:
            for j in range(N_SAT-1, N_SAT-i, -1):
                clause_db[clause_num-1][0] ^= (1 << j)

        # Adding additional bits to ensure that final width is correct
        # and consistent with N-SAT
        for j in range(i, N_SAT):
            clause_db[clause_num-1].append(0)

        if DEBUG:
            # Changing mask and poles into binary representation (for checking)
            clause_db[clause_num-1][0] = bin(clause_db[clause_num-1][0])[2:].zfill(N_SAT)
            clause_db[clause_num-1][1] = bin(clause_db[clause_num-1][1])[2:].zfill(N_SAT)
            
        clause_num += 1

# Pad first row of clause db (clause 0 is unused)
pad_clause_database = "0" * 55 + "\n" # I am so sorry for hard coding this
write_clause_database.write(pad_clause_database)

if DEBUG:
    for i in range(len(clause_db)):
        print(f"{i+1}: {clause_db[i]}")

else:
    for i in range(len(clause_db)):
        binary_list = [f"{bits:0{N_SAT}b}" for bits in clause_db[i][:2]]
        binary_list += [f"{var:0{BITS}b}" for var in clause_db[i][2:]]
        binary_string = ''.join(binary_list)
        # print(binary_string) # Debug
        write_clause_database.write(f"{binary_string}\n")
        
# Pad the remaining area in memory with 0's
padding_clause_database_bottom = MAX_CLAUSES - len(clause_db) - 1
for i in range(padding_clause_database_bottom):
    write_clause_database.write(pad_clause_database)

# Close files
file.close()
write_clause_database.close()