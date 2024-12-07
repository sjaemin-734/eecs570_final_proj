# Format of input to decider: [var_idx][random_decision]

import math
import os
import random
import sys

# Check that there are the required number of input args
if len(sys.argv) != 2:
    print("Error: Invalid number of arguments passed into script", file=sys.stderr)
    exit(1)

# Create directory for processed files if it doesn't exist yet
os.makedirs("preprocessed", exist_ok=True)

# Set these based on SAT solver definitions
MAX_VARS = 512
MAX_CLAUSES = 1024
MAX_VARS_BITS = math.ceil(math.log2(MAX_VARS))
MAX_CLAUSES_BITS = math.ceil(math.log2(MAX_CLAUSES))

# Read DIMACS CNF file
read_file = str(sys.argv[1])
read_handler = open(read_file, "r")
# Set up output files
basefile = os.path.basename(sys.argv[1])    # Remove path
basefile = basefile.split(".")[0]  # Remove file extension from input file
write_decider = open(f"preprocessed/{basefile}_decider.txt", "w+")

num_vars = None

# Find number of variables in SAT problem
for line in read_handler:
    # Split up each element in line
    line_elements = line.split()
    
    # Ignore comments
    if line_elements[0] == 'c':
        continue
    elif line_elements[0] == 'p':
        num_vars = int(line_elements[2])
        break

# Generate random decisions for each variable
# The order of the variable decisions are randomized too
# Ex:   [var35 decision]
#       [var1 decision]
for var in range(1, num_vars+1):
    random_decision = random.randint(0, 1)
    # print(f"var {var}, decision {random_decision}") # Debug

    # Convert var and random_decision to binary
    var_idx_binary = f"{var:0{MAX_VARS_BITS}b}"
    write_decider.write(f"{var_idx_binary}{random_decision}\n")

# Pad the remaining area in memory with 0's
pad_decider = "0" * (MAX_VARS_BITS + 1) + "\n"
padding_decider_bottom = MAX_VARS - num_vars
for i in range(padding_decider_bottom):
    write_decider.write(pad_decider)

# Close files
read_handler.close()
write_decider.close()