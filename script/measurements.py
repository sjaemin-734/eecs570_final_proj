import os
import sys
import random


data = []

file1 = open("combined_output.txt", 'r')


print("ONE DEVICE")
for line in file1:
    line = line.split(" ")

    if line[0] == "$finish" and line[2] == "simulation":
        data.append(int(line[-1])//10)

# print(data)

def average(numbers):
    return sum(numbers)/len(numbers)

print(average(data))


print("TWO DEVICES")
device_pair = []

for i in range(150):
    pair = []
    for j in range(2):
        index = random.randint(1, len(data))
        pair.append(data[index-1])
    device_pair.append(min(pair))

# print(device_pair)
print(average(device_pair))


print("FOUR DEVICES")
device_four = []
for i in range(150):
    group = []
    for j in range(4):
        index = random.randint(1, len(data))
        group.append(data[index-1])
    device_four.append(min(group))

print(average(device_four))


print("EIGHT DEVICES")
device_eight = []
for i in range(150):
    group = []
    for j in range(8):
        index = random.randint(1, len(data))
        group.append(data[index-1])
    device_eight.append(min(group))

print(average(device_eight))


print("SIXTEEN DEVICES")
device_16 = []
for i in range(150):
    group = []
    for j in range(8):
        index = random.randint(1, len(data))
        group.append(data[index-1])
    device_16.append(min(group))

    
print(average(device_16))
        