def parse_assignments(text):
    """
    Parse variable assignments from the text into a dictionary.
    """
    assignments = {}
    lines = text.strip().split("\n")
    for line in lines:
        if "=" in line:
            parts = line.split("=")
            var = parts[0].strip().split()[0]
            value = int(parts[1].strip().split(",")[0])
            assignments[var] = value
    return assignments


def parse_cnf(cnf_text):
    """
    Parse the CNF problem into a list of clauses.
    Each clause is represented as a list of integers.
    """
    clauses = []
    lines = cnf_text.strip().split("\n")
    for line in lines:
        clause = [int(lit) for lit in line.split() if lit != "0"]
        clauses.append(clause)
    return clauses


def evaluate_clause(clause, assignments):
    """
    Evaluate a single clause given the assignments.
    A clause is satisfied if at least one literal is true.
    """
    for literal in clause:
        var = f"var{abs(literal)}"
        value = assignments.get(var, 0)  # Default to 0 if variable not found
        if (literal > 0 and value == 1) or (literal < 0 and value == 0):
            return True
    return False


def check_satisfaction(assignments, cnf_clauses):
    """
    Check if the assignments satisfy the CNF clauses.
    """
    for clause in cnf_clauses:
        if not evaluate_clause(clause, assignments):
            return False  # If any clause is unsatisfied, the CNF is unsatisfied
    return True
