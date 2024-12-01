# Master script that calls other scripts to convert CNF SAT problem to
# inputs for memory modules in hardware SAT solver

import os
import sys

# Check that there are the required number of input args
if len(sys.argv) != 2:
    print("Error: Invalid number of arguments passed into script", file=sys.stderr)
    print("Usage: python3 scripts/convert_problem.py [sat_problem.cnf]")
    exit(1)

# Create directory for processed files if it doesn't exist yet
os.makedirs("preprocessed", exist_ok=True)

# Call the other scripts
os.system(f"python3 script/clause_database.py {sys.argv[1]}")
os.system(f"python3 script/clause_and_vse_tables.py {sys.argv[1]}")
os.system(f"python3 script/decider.py {sys.argv[1]}")