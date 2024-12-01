#include "VUnitClauseEvaluator.h"
#include <stdio.h>
#include <verilated.h>

int main(int argc, char **argv) {
  // Initialize Verilator
  Verilated::commandArgs(argc, argv);

  // Create instance of our module
  VUnitClauseEvaluator *dut = new VUnitClauseEvaluator;

  // Test case counter for reporting
  int test_count = 0;
  int error_count = 0;

  // Helper function to check and report results
  auto check_result = [&](bool expected_unit, int expected_var,
                          bool expected_assignment, const char *test_name) {
    test_count++;
    bool has_error = false;

    if (dut->unit_clause != expected_unit) {
      printf("ERROR: Test %d (%s) unit_clause check failed!\n", test_count,
             test_name);
      printf("  Expected: %d, Got: %d\n", expected_unit, dut->unit_clause);
      has_error = true;
    }

    if (dut->unit_clause && (dut->implied_variable != expected_var)) {
      printf("ERROR: Test %d (%s) implied_variable check failed!\n", test_count,
             test_name);
      printf("  Expected: %d, Got: %d\n", expected_var, dut->implied_variable);
      has_error = true;
    }

    if (dut->unit_clause && (dut->new_assignment != expected_assignment)) {
      printf("ERROR: Test %d (%s) new_assignment check failed!\n", test_count,
             test_name);
      printf("  Expected: %d, Got: %d\n", expected_assignment,
             dut->new_assignment);
      has_error = true;
    }

    if (has_error) {
      printf(
          "  Inputs: clause_mask=0b%05b, unassign=0b%05b, clause_pole=0b%05b\n",
          dut->clause_mask, dut->unassign, dut->clause_pole);
      error_count++;
    } else {
      printf("Test %d (%s) passed\n", test_count, test_name);
    }
  };

  printf("\nStarting Unit Clause Evaluator Tests\n\n");

  // Test 1: No valid variables
  dut->clause_mask = 0b00000;
  dut->unassign = 0b11111;
  dut->clause_pole = 0b00000;
  dut->eval();
  check_result(0, 0, 0, "No valid variables");

  // Test 2: All unassigned but only one valid
  dut->clause_mask = 0b00100; // Only var2 is valid
  dut->unassign = 0b11111;    // All unassigned
  dut->clause_pole = 0b00000; // No negations
  dut->eval();
  check_result(1, 2, 1, "Single valid unassigned var");

  // Test 3: Multiple unassigned variables
  dut->clause_mask = 0b11111; // All valid
  dut->unassign = 0b11111;    // All unassigned
  dut->clause_pole = 0b00000; // No negations
  dut->eval();
  check_result(0, 0, 0, "Multiple unassigned vars");

  // Test 4: Single unassigned variable with negation
  dut->clause_mask = 0b11111; // All valid
  dut->unassign = 0b00100;    // Only var2 unassigned
  dut->clause_pole = 0b00100; // var2 negated
  dut->eval();
  check_result(1, 2, 0, "Single unassigned with negation");

  // Test 5: Single unassigned but not valid
  dut->clause_mask = 0b11011; // All valid except var2
  dut->unassign = 0b00100;    // Only var2 unassigned
  dut->clause_pole = 0b00000; // No negations
  dut->eval();
  check_result(0, 0, 0, "Single unassigned but not valid");

  // Test 6: Rightmost variable is unassigned unit
  dut->clause_mask = 0b00001; // Only var0 valid
  dut->unassign = 0b00001;    // Only var0 unassigned
  dut->clause_pole = 0b00001; // var0 negated
  dut->eval();
  check_result(1, 0, 0, "Rightmost unassigned unit");

  // Test 7: Leftmost variable is unassigned unit
  dut->clause_mask = 0b10000; // Only var4 valid
  dut->unassign = 0b10000;    // Only var4 unassigned
  dut->clause_pole = 0b10000; // var4 negated
  dut->eval();
  check_result(1, 4, 0, "Leftmost unassigned unit");

  // Report results
  printf("\nTest Summary:\n");
  printf("  Total Tests: %d\n", test_count);
  printf("  Errors: %d\n", error_count);
  printf("\nSimulation %s\n\n", error_count == 0 ? "PASSED" : "FAILED");

  // Cleanup
  delete dut;
  return error_count ? 1 : 0;
}
