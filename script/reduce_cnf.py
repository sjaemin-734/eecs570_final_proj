import sys

# Debug mode prints the original cnf and reduced cnf
# as Python lists
DEBUG = False

def reduce_to_5sat(cnf):
    """
    Reduces a CNF formula to 5-SAT by breaking down large clauses into multiple
    clauses of size 5 or less.
    
    Args:
        cnf (list[list[int]]): A CNF formula represented as a list of clauses,
            where each clause is a list of literals (integers).
            Positive integers represent positive literals,
            negative integers represent negated literals.
    
    Returns:
        list[list[int]]: The reduced 5-SAT CNF formula
    """
    result = []
    next_var = max(abs(lit) for clause in cnf for lit in clause) + 1
    
    for clause in cnf:
        if len(clause) <= 5:
            # If clause is already small enough, add it directly
            result.append(clause)
        else:
            # Break down large clause using auxiliary variables
            current_clause = clause.copy()
            while len(current_clause) > 5:
                # Take first 4 literals of current clause
                new_clause = current_clause[:4]
                # Add new auxiliary variable
                new_clause.append(next_var)
                result.append(new_clause)
                
                # Continue with remaining literals and negation of auxiliary variable
                current_clause = [-next_var] + current_clause[4:]
                next_var += 1
            
            # Add final clause (will have size ≤ 5)
            result.append(current_clause)
    
    return result

def cnf_to_dimacs(cnf):
    """
    Converts CNF to DIMACS format string.
    
    Args:
        cnf (list[list[int]]): CNF formula
    
    Returns:
        str: DIMACS format string
    """
    num_vars = max(abs(lit) for clause in cnf for lit in clause)
    num_clauses = len(cnf)
    
    lines = [f"p cnf {num_vars} {num_clauses}"]
    for clause in cnf:
        lines.append(" ".join(map(str, clause + [0])))
    
    return "\n".join(lines)

# Example usage:
if __name__ == "__main__":
    
    filename = str(sys.argv[1])
    # filename = 'hole6.cnf'
    file = open(filename, 'r')
    # Finding header
    while True:
        line = file.readline()
        if line and line[0] == 'p':
            words = line.split()
            num_vars, num_clauses = int(words[2]), int(words[3])
            break

    clause_num = 1
    cnf = []

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
            cnf.append([])
            for var in vars:
                if var != '0':
                    cnf[clause_num-1].append(int(var))
            clause_num += 1
    
    reduced_cnf = reduce_to_5sat(cnf)
    reduced_cnf_dimacs = cnf_to_dimacs(reduced_cnf)
    
    if DEBUG:
        print("Original CNF:")
        for clause in cnf:
            print(clause)
        
        print("\nReduced 5-SAT CNF:")
        for clause in reduced_cnf:
            print(clause)

        print("\nDIMACS format:")
        print(reduced_cnf_dimacs)


    file.close()
    # Saving the reduced cnf file to a reduced/{filename}.cnf
    filename = filename.rsplit('/', 1)[1]
    file = open(f"reduced/{filename}", 'w')
    file.write(reduced_cnf_dimacs)
    file.close()

