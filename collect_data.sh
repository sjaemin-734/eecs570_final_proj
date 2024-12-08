#!/bin/bash

# Variables
cpp_file="solver.cpp"
input_folder="test"
input_file="control_uf50n03_test.sv"
output_file="combined_output.txt"

create_mifs="script/convert_problems.py"
create_verilog="script/create_test.py"

# Create output folder if it doesn't exist
# mkdir -p "$output_folder"


# Clear the output file if it exists
> "$output_file"

echo "Output for data" >> "$output_file"

# Iterate over each file in the input folder
for i in {1..150}; do
  # Get the base name of the input file (without path)
  
#   python3 "$create_mifs"
#   python3 "$create_verilog"
  
  # Clean and compile verilog file
  make clean
  make simv

  # Run the compiled program with the input file and redirect output
  ./simv >> "$output_file"
  # Add a newline between outputs for readability
  echo -e "\n" >> "$output_file"

done

echo "All files processed."