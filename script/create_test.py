import sys
import os

FILENAME = "hole6" # do not include extension or path

PREPROCESSED_DIR = './preprocessed/'
START_END_SUFFIX = 'var_start_end_table'
CLAUSE_TABLE_SUFFIX = 'clause_table'
CLAUSE_DB_SUFFIX = 'clause_database'
DECIDER_SUFFIX = 'decider'

BLANK_VERILOG_FILEPATH = './test/control_blank_test.sv'
VERILOG_FILEPATH = './test/'
SENTINEL_STRING = '// PYTHON : ADD INITIALIZATION STUFF HERE & CHANGE VARIABLE COUNT BELOW ;'

SPACES = " " * 8

def convert_mif(sat_problem_name):

    files = os.listdir(PREPROCESSED_DIR)
    files.sort()
    
    # Order: start/end table, clause db, clause table

    # List all mif files associated with the sat problem
    mif_files = [_ for _ in files if sat_problem_name in _]
    
    # List original file names
    prefixes = [_.split('_', 1)[0] for _ in mif_files]
    # Quick and dirty way to only keep unique elements
    prefixes = set(prefixes)
    prefixes = list(prefixes)
    
    files = [START_END_SUFFIX, CLAUSE_DB_SUFFIX, CLAUSE_TABLE_SUFFIX, DECIDER_SUFFIX]
    verilog_cmds = ['SET_VAR_START_END_TABLE', 'SET_CLAUSE_DATABASE', 'SET_CLAUSE_TABLE', 'SET_DECIDER']

    for prefix in prefixes:
        # outfile = open(f"{PREPROCESSED_DIR}{prefix}_v.txt", 'w+')
        new_text = []
        width = None

        for i in range(len(files)):
            file = open(f"{PREPROCESSED_DIR}{prefix}_{files[i]}.mif", 'r')
            all_zeros = None
            title = verilog_cmds[i].replace('_', ' ')
            new_text.append(f'{SPACES}// {title}\n')
            while True:
                line = file.readline()
                line = line.split()
                if not line:
                    continue
                elif line[0] == 'WIDTH':
                    width = int(line[2][:-1])
                    all_zeros = '0' * width
                elif len(line) >= 3 and line[0] != '0' and line[2][:-1] == all_zeros:
                    break
                elif line[0].isnumeric():
                    index = line[0]
                    bits = line[2]
                    new_text.append(f"{SPACES}{verilog_cmds[i]}({index}, {width}\'b{bits[:-1]});\n")
            new_text.append('\n')
            
    return new_text

def get_var_count(sat_problem_name):
    file = open(f"reduced/{sat_problem_name}.cnf", 'r')
    for line in file:
        line = line.split()
        if line and line[0] == 'p':
            return line[2]

    return None

def insert_text(sat_problem_name, new_text):
    template = open(BLANK_VERILOG_FILEPATH, 'r')
    outfile = open(f"{VERILOG_FILEPATH}control_{sat_problem_name}_test.sv", 'w+')
    for line in template:
        # Copy file exactly until sentinel line
        if 'PYTHON' in line:
            # Write set code
            s = ""
            outfile.write(s.join(new_text))

            # Read max_var_test but do not write it
            line = template.readline()
            max_var_text = get_var_count(sat_problem_name)
            outfile.write(f"{SPACES}max_var_test = {max_var_text};    // NUMBER OF VARIABLES IN PROBLEM\n")
        else:
            outfile.write(line)

if __name__ == '__main__':

    arr = convert_mif(FILENAME)
    insert_text(FILENAME, arr)
    
