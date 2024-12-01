import os
import sys

# Included these as variables so that they can be changed if needed
N_SAT = 5
BITS = 9

# Debug mode prints the vars in decimal and the masks in binary (in string form)
DEBUG = False

if len(sys.argv) < 1:
    print("Error: no file specified!")
    exit(1)

filename = str(sys.argv[1])
print(filename)
file = open(filename, 'r')
num_vars, num_clauses = None, None

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
        clause_db[clause_num-1].append(2**N_SAT - 1) # start with all negated and XOR away variables that are

        i = 0
        temp = []
        for var in vars:
            if var != '0':
                var = int(var)

                # Clearing pole bit if var is not negated
                if var > 0:
                    clause_db[clause_num-1][1] ^= (1 << i)
                
                # Clauses need to be stored as absolute numbers
                var = abs(var)
                clause_db[clause_num-1].append(var)

                i += 1

        # Clearing mask bits for clauses that are not BITS-SAT
        for j in range(N_SAT-1, N_SAT-i, -1):
            clause_db[clause_num-1][0] ^= (1 << j)

        if DEBUG:
            # Changing mask and poles into binary representation (for checking)
            clause_db[clause_num-1][0] = bin(clause_db[clause_num-1][0])[2:].zfill(N_SAT)
            clause_db[clause_num-1][1] = bin(clause_db[clause_num-1][1])[2:].zfill(N_SAT)
            
        clause_num += 1

if DEBUG:
    for i in range(len(clause_db)):
        print(f"{i+1}: {clause_db[i]}")

else:
    for i in range(len(clause_db)):
        binary_list = [f"{bits:0{N_SAT}b}" for bits in clause_db[i][:2]]
        binary_list += [f"{var:0{BITS}b}" for var in clause_db[i][2:]]
        binary_string = ''.join(binary_list)
        print(binary_string)