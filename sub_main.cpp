#include <verilated.h>
#include "VSubClauseEvaluator.h"
#include <stdio.h>

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    // Create instance of our module
    VSubClauseEvaluator* dut = new VSubClauseEvaluator;
    
    // Test case counter for reporting
    int test_count = 0;
    int error_count = 0;

    // Helper function to check and report results
    auto check_result = [&](bool expected_unit, int expected_var, bool expected_assignment, const char* test_name) {
        test_count++;
        bool has_error = false;
        
        if (dut->unit_clause != expected_unit) {
            printf("ERROR: Test %d (%s) unit_clause check failed!\n", test_count, test_name);
            printf("  Expected: %d, Got: %d\n", expected_unit, dut->unit_clause);
            has_error = true;
        }
        
        if (expected_unit && (dut->implied_variable != expected_var)) {
            printf("ERROR: Test %d (%s) implied_variable check failed!\n", test_count, test_name);
            printf("  Expected: %d, Got: %d\n", expected_var, dut->implied_variable);
            has_error = true;
        }
        
        if (expected_unit && (dut->new_assignment != expected_assignment)) {
            printf("ERROR: Test %d (%s) new_assignment check failed!\n", test_count, test_name);
            printf("  Expected: %d, Got: %d\n", expected_assignment, dut->new_assignment);
            has_error = true;
        }

        if (has_error) {
            printf("  Inputs: clause_mask=0b%05b, unassign=0b%05b, assignment=0b%05b, clause_pole=0b%05b\n",
                   dut->clause_mask, dut->unassign, dut->assignment, dut->clause_pole);
            printf("  Variables: var1=%d, var2=%d, var3=%d, var4=%d, var5=%d\n",
                   dut->var1, dut->var2, dut->var3, dut->var4, dut->var5);
            error_count++;
        } else {
            printf("Test %d (%s) passed\n", test_count, test_name);
        }
    };

    printf("\nStarting Sub Clause Evaluator Tests\n\n");

    // Set variable indices for all tests
    dut->var1 = 100;  // Using distinct 9-bit values
    dut->var2 = 200;
    dut->var3 = 300;
    dut->var4 = 400;
    dut->var5 = 500;

    // Test 1: No valid variables
    dut->clause_mask = 0b00000;
    dut->unassign = 0b11111;
    dut->assignment = 0b00000;
    dut->clause_pole = 0b00000;
    dut->eval();
    check_result(0, 0, 0, "No valid variables");

    // Test 2: Single valid unassigned variable (should be unit clause)
    dut->clause_mask = 0b00100;   // Only var3 is valid
    dut->unassign = 0b11111;      // All unassigned
    dut->assignment = 0b00000;    // No assignments
    dut->clause_pole = 0b00000;   // No negations
    dut->eval();
    check_result(1, 300, 1, "Single valid unassigned var");

    // Test 3: Multiple unassigned variables
    dut->clause_mask = 0b11111;  // All valid
    dut->unassign = 0b11111;     // All unassigned
    dut->assignment = 0b00000;   // No assignments
    dut->clause_pole = 0b00000;  // No negations
    dut->eval();
    check_result(0, 0, 0, "Multiple unassigned vars");

    // Test 4: Partially satisfied clause
    dut->clause_mask = 0b11111;  // All valid
    dut->unassign = 0b11110;     // One var assigned
    dut->assignment = 0b00001;   // Last var is 1
    dut->clause_pole = 0b00000;  // No negations
    dut->eval();
    check_result(0, 0, 0, "Partially satisfied clause");

    // Test 5: Single unassigned with partially satisfied
    dut->clause_mask = 0b11111;  // All valid
    dut->unassign = 0b00100;     // Only var3 unassigned
    dut->assignment = 0b00001;   // Last var is 1
    dut->clause_pole = 0b00000;  // No negations
    dut->eval();
    check_result(0, 0, 0, "Single unassigned with partial SAT");

    // Test 6: Single unassigned with negation
    dut->clause_mask = 0b11111;  // All valid
    dut->unassign = 0b00100;     // Only var3 unassigned
    dut->assignment = 0b00000;   // All 0
    dut->clause_pole = 0b00100;  // var3 negated
    dut->eval();
    check_result(1, 300, 0, "Single unassigned with negation");

    // Test 7: Rightmost variable is unit clause
    dut->clause_mask = 0b00001;  // Only var1 valid
    dut->unassign = 0b00001;     // Only var1 unassigned
    dut->assignment = 0b00000;   // All 0
    dut->clause_pole = 0b00001;  // var1 negated
    dut->eval();
    check_result(1, 100, 0, "Rightmost unit var");

    // Test 8: Leftmost variable is unit clause
    dut->clause_mask = 0b10000;  // Only var5 valid
    dut->unassign = 0b10000;     // Only var5 unassigned
    dut->assignment = 0b00000;   // All 0
    dut->clause_pole = 0b10000;  // var5 negated
    dut->eval();
    check_result(1, 500, 0, "Leftmost unit var");

    // Report results
    printf("\nTest Summary:\n");
    printf("  Total Tests: %d\n", test_count);
    printf("  Errors: %d\n", error_count);
    printf("\nSimulation %s\n\n", error_count == 0 ? "PASSED" : "FAILED");

    // Cleanup
    delete dut;
    return error_count ? 1 : 0;
}
