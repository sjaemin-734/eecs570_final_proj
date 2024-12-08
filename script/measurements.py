import os
import sys


data = []

file1 = open("combined_output.txt", 'r')

for line in file1:
    line = line.split(" ")

    if line[0] == "$finish" and line[2] == "simulation":
        data.append(int(line[-1])//10)

print(data)

    