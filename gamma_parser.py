import os
import numpy as np

def extract_gamma_means(file_path):
    """Extract the gamma_mean values from the 2nd and last row of the given file."""
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    second_row_gamma_mean = float(lines[1].split()[8])
    last_row_gamma_mean = float(lines[-1].split()[8])
    
    return second_row_gamma_mean, last_row_gamma_mean

def process_directories(base_path):
    """Process all 'gamXXX' directories in ascending order and extract the relevant gamma_mean values."""
    second_row_values = []
    last_row_values = []
    
    # List all directories starting with 'gam' and extract their numeric part
    directories = [dir for dir in os.listdir(base_path) if dir.startswith('gam') and dir[3:].isdigit()]
    
    # Sort directories by the numeric part (ascending order)
    directories.sort(key=lambda x: int(x[3:]))
    
    # Process each directory
    for directory in directories:
        file_path = os.path.join(base_path, directory, 'BeamRelevant_beam2.txt')
        if os.path.isfile(file_path):
            second_row_gamma_mean, last_row_gamma_mean = extract_gamma_means(file_path)
            second_row_values.append(second_row_gamma_mean)
            last_row_values.append(last_row_gamma_mean)
    
    # Convert lists to numpy arrays
    second_row_array = np.array(second_row_values)
    last_row_array = np.array(last_row_values)
    
    return second_row_array, last_row_array

# Example usage
base_path = './saved_runs_alt'  # Replace with the path to the directory containing the 'gamXXX' directories
second_row_array, last_row_array = process_directories(base_path)

print("Second row values:", second_row_array)
print("Last row values:", last_row_array)
