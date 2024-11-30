# Converts DIMACS CNF file format used to describe SAT problems
# into binary inputs for the clause table module

# Processes one test file at a time

# p cnf 100 160 means 100 vars, 160 clauses
# each row is a clause, each element is a variable
# "-" in front of a variable is negation
import sys
import math

# Check that there are the required number of input args
if len(sys.argv) < 3:
    print("Error: Not enough arguments passed into script", file=sys.stderr)
    exit(1)

# Set these based on SAT solver definitions
MAX_VARS = 512
MAX_CLAUSES = 1024
MAX_VARS_BITS = int(math.log2(MAX_VARS))
MAX_CLAUSES_BITS = int(math.log2(MAX_CLAUSES))

# Read DIMACS CNF file
read_file = str(sys.argv[1])
read_handler = open(read_file, "r")

# Set up output file
write_file = str(sys.argv[2])
write_handler = open(write_file, "w+")
num_vars = 0
num_clauses = 0
clause_idx = 0

# dict: {var: clause list}
var_dict = {}

# Read file line by line
for line in read_handler:
    # Ignore comments
    if line[0] == 'c' or line[0] == 'p':
        continue
    
    # Process clauses
    for i in line.split():
        # Check if this is the last element in line (sentinel)
        if i == '0':
            break
        # Process variables
        else:
            # Add clause to var dictionary
            new_i = abs(int(i))
            var_dict.setdefault(new_i, []).append(clause_idx)
    
    # Increment clause index
    clause_idx += 1

# Convert each key/val pair in dict to binary output
for clause_list in var_dict.values():
    for clause in clause_list:
        clause_table_row = f"{clause:0{MAX_CLAUSES_BITS}b}\n"
        
        # Write binary to output file
        write_handler.write(clause_table_row)

# Close files
read_handler.close()
write_handler.close()