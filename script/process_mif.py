import sys
import os

PREPROCESSED_DIR = './preprocessed/'
START_END_SUFFIX = 'var_start_end_table'
CLAUSE_TABLE_SUFFIX = 'clause_table'
CLAUSE_DB_SUFFIX = 'clause_database'
DECIDER_SUFFIX = 'decider'

def convert_mif():

    files = os.listdir(PREPROCESSED_DIR)
    files.sort()
    
    # Order: start/end table, clause db, clause table

    # List all mif files except for the deciders
    mif_files = [_ for _ in files]
    
    # List original file names
    prefixes = [_.split('_', 1)[0] for _ in mif_files]
    # Quick and dirty way to only keep unique elements
    prefixes = set(prefixes)
    prefixes = list(prefixes)
    
    files = [START_END_SUFFIX, CLAUSE_DB_SUFFIX, CLAUSE_TABLE_SUFFIX, DECIDER_SUFFIX]
    verilog_cmds = ['SET_VAR_START_END_TABLE', 'SET_CLAUSE_DATABASE', 'SET_CLAUSE_TABLE', 'SET_DECIDER']

    for prefix in prefixes:
        outfile = open(f"{PREPROCESSED_DIR}{prefix}_v.txt", 'w+')
        width = None

        for i in range(len(files)):
            file = open(f"{PREPROCESSED_DIR}{prefix}_{files[i]}.mif", 'r')
            all_zeros = None

            title = verilog_cmds[i].replace('_', ' ')
            outfile.write(f'// {title}\n')
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
                    outfile.write(f"{verilog_cmds[i]}({index}, {width}\'b{bits[:-1]});\n")
            outfile.write('\n')
            
if __name__ == '__main__':
    convert_mif()