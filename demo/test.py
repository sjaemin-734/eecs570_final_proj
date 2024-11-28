from z3 import *

def create_problem2():
    x = Real("x")
    y = Real("y")

    # Create boolean abstractions for theory constraints
    p1 = Bool("p1")  
    p2 = Bool("p2")  
    p3 = Bool("p3")  
    p4 = Bool("p4")  
    p5 = Bool("p5")  
    p6 = Bool("p6")  

    # More complex SAT formula that forces exploration
    sat_formula = And(
        Or(p1, p2),  # Either x>2 or y>1
        Or(p3, p4),  # Either sum<5 or diff<2
        Or(p5, p6)  # x>2 or diff<2 or sum>3
    )

    # Theory mappings
    theory_mappings = [
        (p1, x > 5),
        (p2, y > 5),
        (p3, x - y < 2),
        (p4, x + y < 10),
        (p5, y < 5),
        (p6, x < 5),
    ]

    return sat_formula, theory_mappings

def theory_check(model, theory_mappings):
    """Check if the boolean assignment is theory-satisfiable"""
    theory_solver = Solver()
    
    # Create tracked assertions for unsat core
    tracked_assertions = []
    for bool_var, theory_constraint in theory_mappings:
        if is_true(model[bool_var]):
            # Create a fresh boolean variable to track this assertion
            track = Bool(f"track_{bool_var}")
            tracked_assertions.append((track, bool_var))
            theory_solver.assert_and_track(theory_constraint, track)
        elif is_false(model[bool_var]):
            # Create a fresh boolean variable to track this assertion
            track = Bool(f"track_not_{bool_var}")
            tracked_assertions.append((track, Not(bool_var)))
            theory_solver.assert_and_track(Not(theory_constraint), track)

    if theory_solver.check() == sat:
        return True, None
    else:
        # Get the unsat core
        core = theory_solver.unsat_core()
        
        # Map the tracked assertions back to the original boolean variables
        learned_vars = []
        for track, bool_expr in tracked_assertions:
            if track in core:
                learned_vars.append(bool_expr)
                
        if learned_vars:
            return False, Not(And(learned_vars))
        else:
            # Fallback: if we somehow still get an empty core, 
            # return the negation of the current assignment
            current_assignment = []
            for bool_var, _ in theory_mappings:
                if is_true(model[bool_var]):
                    current_assignment.append(bool_var)
                else:
                    current_assignment.append(Not(bool_var))
            return False, Not(And(current_assignment))

def solve_with_theory_learning():
    sat_formula, theory_mappings = create_problem2()

    # Create SAT solver
    solver = Solver()
    solver.add(sat_formula)

    iteration = 0
    while True:
        print(f"\nIteration {iteration}")
        result = solver.check()

        if result == sat:
            model = solver.model()
            print(f"SAT solver found model: {model}")

            # Theory check
            is_theory_sat, learned_clause = theory_check(model, theory_mappings)

            if is_theory_sat:
                print("Theory check passed! Problem is satisfiable")
                return model
            else:
                print(f"Theory check failed. Learned clause: {learned_clause}")
                # Add learned clause and continue
                solver.add(learned_clause)

        elif result == unsat:
            print("Problem is unsatisfiable")
            return None

        iteration += 1

if __name__ == "__main__":
    final_model = solve_with_theory_learning()
    if final_model:
        print("\nFinal satisfying model:", final_model)
    else:
        print("\nProblem proven unsatisfiable")
