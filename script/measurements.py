import numpy as np
import random
import matplotlib.pyplot as plt

# x: num devices, y: cycles
# histogram of data

file = open("old_combined_output.txt", 'r')
num_samples = 1500

def sample_and_plot():

    data = []
    device_pair = []
    avgs = []
    
    numbers_str = ['TWO', 'FOUR', 'EIGHT', 'SIXTEEN']
    numbers = [2, 4, 8, 16]
    
    # Reading data from file
    for line in file:
        line = line.split(" ")

        if line[0] == "$finish" and line[2] == "simulation":
            data.append(int(line[-1])//10)

    print(data)
    print(np.average(data))

    for i in range(len(numbers)):
        for j in range(num_samples):
            pair = []
            for k in range(numbers[i]):
                index = random.randint(1, len(data))
                pair.append(data[index-1])
            device_pair.append(np.min(pair))
        print(f"{numbers_str[i]} DEVICES")
        avg = np.average(device_pair)
        avgs.append(avg)
        print(avg)

    plt.hist(data, 30)
    plt.xlabel('Cycles')
    plt.ylabel('Count')
    plt.title('Distribution of Execution Times on uf50n03.cnf')
    plt.show()
    # plt.savefig('histogram.png')
    

    return avgs

if __name__ == '__main__':
    y = sample_and_plot()
    print(y)