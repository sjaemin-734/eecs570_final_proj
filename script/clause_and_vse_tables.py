""" 
Converts DIMACS CNF file format used to describe SAT problems
into binary inputs for the clause table module.

This also generates the inputs for the var state table
because it needs to use the same dictionary.

Processes one test file at a time.
p cnf 100 160 means 100 vars, 160 clauses
each row is a clause, each element is a variable
"-" in front of a variable is negation

Format (of each row)
clause_table: [clause idx]
var_start_end_table: [start_idx][end_idx]
"""

import math
import os
import sys

# Check that there are the required number of input args
# if len(sys.argv) != 2:
#     print("Error: Invalid number of arguments passed into script", file=sys.stderr)
#     exit(1)

# Create directory for processed files if it doesn't exist yet
os.makedirs("preprocessed", exist_ok=True)

# Set these based on SAT solver definitions
MAX_VARS = 512
MAX_CLAUSES = 1024
MAX_SAT = 5     # We support 5-SAT problems at most
MAX_CLAUSE_TABLE = MAX_SAT * MAX_CLAUSES
MAX_VARS_BITS = math.ceil(math.log2(MAX_VARS))
MAX_CLAUSES_BITS = math.ceil(math.log2(MAX_CLAUSES))
MAX_CLAUSE_TABLE_BITS = math.ceil(math.log2(MAX_CLAUSE_TABLE))

# Read DIMACS CNF file
read_file = str(sys.argv[1])
read_handler = open(read_file, "r")
# Set up output files
basefile = os.path.basename(sys.argv[1])    # Remove path
basefile = basefile.split(".")[0]  # Remove file extension from input file
write_clause_table = open(f"preprocessed/{basefile}_clause_table.txt", "w+")
write_var_start_end_table = open(f"preprocessed/{basefile}_var_start_end_table.txt", "w+")

num_vars = 0
num_clauses = 0
clause_idx = 1

# dict: {var: clause list}
var_dict = {}

# Read file line by line
for line in read_handler:
    line_elements = line.split()
    
    # Ignore comments
    if line_elements[0] == 'c':
        continue
    if line_elements[0] == 'p':
        num_vars = int(line_elements[2])
        num_clauses = int(line_elements[3])
        continue
    
    # Process clauses
    for var in line_elements:
        # Check if this is the last element in line (sentinel)
        if var == '0':
            break
        # Process variables
        else:
            # Add clause to var dictionary
            new_var = abs(int(var))
            var_dict.setdefault(new_var, []).append(clause_idx)
    
    # Increment clause index
    clause_idx += 1

# Sort the dict
var_dict = dict(sorted(var_dict.items()))
# print(var_dict) # debug

pad_clause_table = "0" * MAX_CLAUSES_BITS + "\n"
pad_var_start_end_table = "0" * MAX_CLAUSE_TABLE_BITS * 2 + "\n"

# Pad first row of var_start_end_table (since var 0 is unused)
write_var_start_end_table.write(pad_var_start_end_table)

# Convert each key/val pair in dict to binary output
var_idx_counter = 0    # Keeps track of idx in clause table
for var, clause_list in var_dict.items():
    for clause in clause_list:
        # Populate the clause table
        # Converts integer to bits
        clause_table_row = f"{clause:0{MAX_CLAUSES_BITS}b}\n"
        # Write binary to output file
        write_clause_table.write(clause_table_row)

    # Populate the var start end table
    start_idx_binary = f"{var_idx_counter:0{MAX_CLAUSE_TABLE_BITS}b}"
    write_var_start_end_table.write(start_idx_binary)
    var_idx_counter += len(clause_list)
    end_idx_binary = f"{var_idx_counter:0{MAX_CLAUSE_TABLE_BITS}b}\n"
    write_var_start_end_table.write(end_idx_binary)

# Pad the remaining area in memory with 0's
# -1 to var_idx_counter because it's an exclusive boundary
padding_clause_table_bottom = MAX_CLAUSE_TABLE - (var_idx_counter - 1)
for i in range(padding_clause_table_bottom):
    write_clause_table.write(pad_clause_table)
    
# -1 is from padding row 0 earlier
padding_var_start_end_table_bottom = MAX_VARS - num_vars - 1
for i in range(padding_var_start_end_table_bottom):
    write_var_start_end_table.write(pad_var_start_end_table)

# Close files
read_handler.close()
write_clause_table.close()
write_var_start_end_table.close()