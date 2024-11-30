import os
import sys

if len(sys.argv) < 1:
    print("Error: no file specified!")
    exit(1)

filename = str(sys.argv[1])
print(filename)
file = open(filename, 'r')
num_vars, num_clauses = None, None
clause_db = {}

# Finding header
while True:
    line = file.readline()
    if line and line[0] == 'p':
        words = line.split()
        print(words)
        num_vars, num_clauses = int(words[2]), int(words[3])
        break

clause_num = 1
while True:
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
        for var in vars:
            if var != '0':
                # Ignoring negations
                var = abs(int(var))
                if var not in clause_db:
                    clause_db[var] = [clause_num]
                else:
                    clause_db[var].append(clause_num)
        clause_num += 1
            
clause_db = dict(sorted(clause_db.items()))
print(clause_db)