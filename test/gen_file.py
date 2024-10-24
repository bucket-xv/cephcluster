import random

# Define the number of random numbers you want to generate
num_random_numbers = 2000000

# Define the range for the random numbers
range_start = 1
range_end = 100

# Define the file name
filename = 'file.txt'

# Open the file in write mode
with open(filename, 'w') as file:
    # Generate and write random numbers to the file
    for _ in range(num_random_numbers):
        random_number = random.randint(range_start, range_end)
        file.write(f"{random_number}")

print(f"Random numbers have been written to {filename}")
