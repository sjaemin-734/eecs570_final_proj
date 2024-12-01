// main.cpp
#include <verilated.h>
#include "VPartialSATEvaluator.h"
#include <stdio.h>

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    // Create instance of our module
    VPartialSATEvaluator* dut = new VPartialSATEvaluator;
    
    // Test case counter for reporting
    int test_count = 0;
    int error_count = 0;

    // Helper function to check and report results
    auto check_result = [&](bool expected, const char* test_name) {
        test_count++;
        if (dut->partial_sat != expected) {
            printf("ERROR: Test %d (%s) failed!\n", test_count, test_name);
            printf("  Inputs: clause_mask=0b%05b, unassign=0b%05b, assignment=0b%05b, clause_pole=0b%05b\n",
                   dut->clause_mask, dut->unassign, dut->assignment, dut->clause_pole);
            printf("  Expected: %d, Got: %d\n", expected, dut->partial_sat);
            error_count++;
        } else {
            printf("Test %d (%s) passed\n", test_count, test_name);
        }
    };

    printf("\nStarting Partial SAT Evaluator Tests\n\n");

    // Test 1: No valid variables
    dut->clause_mask = 0b00000;
    dut->unassign = 0b11111;
    dut->assignment = 0b00000;
    dut->clause_pole = 0b00000;
    dut->eval();
    check_result(0, "No valid variables");

    // Test 2: All unassigned variables
    dut->clause_mask = 0b11111;
    dut->unassign = 0b11111;
    dut->assignment = 0b00000;
    dut->clause_pole = 0b00000;
    dut->eval();
    check_result(0, "All unassigned");

    // Test 3: Single satisfied variable
    dut->clause_mask = 0b11111;
    dut->unassign = 0b00000;
    dut->assignment = 0b10000;
    dut->clause_pole = 0b00000;
    dut->eval();
    check_result(1, "Single satisfied var");

    // Test 4: Single satisfied variable with negation
    dut->clause_mask = 0b11111;
    dut->unassign = 0b00000;
    dut->assignment = 0b00000;
    dut->clause_pole = 0b10000;
    dut->eval();
    check_result(1, "Single satisfied var with negation");

    // Test 5: Mixed case
    dut->clause_mask = 0b11111;
    dut->unassign = 0b00110;
    dut->assignment = 0b10001;
    dut->clause_pole = 0b00001;
    dut->eval();
    check_result(1, "Mixed case");

    // Test 6: Valid but unsatisfied
    dut->clause_mask = 0b11111;
    dut->unassign = 0b00000;
    dut->assignment = 0b00000;
    dut->clause_pole = 0b00000;
    dut->eval();
    check_result(0, "Valid but unsatisfied");

    // Test 7: Masked out satisfied variable
    // Testing with rightmost bit masked out (bit 0) but showing satisfaction there
    dut->clause_mask = 0b11110;   // Valid variables in positions 1-4, position 0 masked
    dut->unassign = 0b00000;      // All assigned
    dut->assignment = 0b00001;    // Satisfied only in position 0 (masked out)
    dut->clause_pole = 0b00000;   // No negations
    dut->eval();
    check_result(0, "Masked out satisfied var");

    // Report results
    printf("\nTest Summary:\n");
    printf("  Total Tests: %d\n", test_count);
    printf("  Errors: %d\n", error_count);
    printf("\nSimulation %s\n\n", error_count == 0 ? "PASSED" : "FAILED");

    // Cleanup
    delete dut;
    return error_count ? 1 : 0;
}
