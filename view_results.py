import pickle
import argparse

# Set up the command-line argument parser
parser = argparse.ArgumentParser(description='Display the contents of a pickle file')
parser.add_argument('pickle_file', type=str, help='Path to the pickle file')

# Parse the command-line arguments
args = parser.parse_args()

# Load data from the pickle file specified in the command-line arguments
with open(args.pickle_file, 'rb') as file:
    data = pickle.load(file)

# Display the loaded data
print(data)

# Close the file
file.close()
