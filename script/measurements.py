import numpy as np
import random
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker

# x: num devices, y: cycles
# histogram of data

file = open("old_combined_output.txt", 'r')
num_samples = 1500
numbers_str = ['TWO', 'FOUR', 'EIGHT', 'SIXTEEN']
numbers = [1, 2, 4, 8, 16]

def sample_and_plot():

    data = []
    device_pair = []
    avgs = []
    
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

uf50_03 = [32735.02667, 15907.94667, 9104.209333, 5448.092667, 3810.757333]
hole6 = [399750.78, 351436.8847, 323818.2707, 302189.9253, 284641.282]
uf50_88 = [48454.49333, 26991.39, 15028.57867, 9059.704667, 5816.762]

def plot_data(data, test_name):
    _, ax = plt.subplots()
    ax.plot(numbers, data)
    plt.xscale("log")
    ax.set_xlim(1, 16)
    ylim = 40_000 if test_name == 'uf50_03' else None
    # ax.set_ylim(0, ylim)
    ax.xaxis.set_major_formatter(mticker.ScalarFormatter())
    plt.minorticks_off()
    # plt.ticklabel_format(style='plain')
    plt.xticks(numbers)
    plt.xlabel('Number of Devices')
    plt.ylabel('Cycles')
    plt.grid()
    plt.title(f'Average Execution Times on {test_name}.cnf')
    plt.show()

if __name__ == '__main__':
    # y = sample_and_plot()
    # print(y)
    plot_data(hole6, 'hole6')