# import csv

# # CSV file input
# csv_file = 'episodes.csv'
# table_name = 'episodes'  # Replace with your table name
# num_columns = 6  # Replace with the number of columns you want

# try:
#     with open(csv_file, 'r') as csvfile:
#         csv_reader = csv.reader(csvfile)
#         header = next(csv_reader)  # Read the first row as column names

#         # Build the column part of the INSERT statement with the specified number of columns
#         column_names = f"({', '.join(header[:num_columns])})"
        
#         # Print the initial part of the INSERT statement
#         print(f"INSERT INTO {table_name}")
#         print(f"{column_names})")
#         print("VALUES")
        
#         for row in csv_reader:
#             # Filter out empty values and build the VALUES part of the INSERT statement with the specified number of columns
#             filtered_values = [f"'{value}'" if value != '' else 'NULL' for value in row[:num_columns]]
#             values = f"({', '.join(filtered_values)})"
#             print(values)
            
# except Exception as e:
#     print(f"Error: {e}")




import csv
import re

# Function to escape quotes within a string
def escape_quotes(value):
    return re.sub(r"([\"'])", r"\\\1", value)

# CSV file input
csv_file = './csv_files/series_director.csv'
table_name = 'series_director'  # Replace with your table name
num_columns = 6  # Replace with the number of columns you want

try:
    with open(csv_file, 'r') as csvfile:
        csv_reader = csv.reader(csvfile)
        header = next(csv_reader)  # Read the first row as column names

        # Build the column part of the INSERT statement with the specified number of columns
        column_names = f"({', '.join(header[:num_columns])})"
        
        # Print the initial part of the INSERT statement
        print(f"INSERT INTO {table_name}")
        print(f"{column_names}")
        print("VALUES")
        
        for row in csv_reader:
            # Filter out empty values, escape quotes, and build the VALUES part of the INSERT statement
            filtered_values = [f"'{escape_quotes(value)}'" if value != '' else 'NULL' for value in row[:num_columns]]
            values = f"({', '.join(filtered_values)}),"
            print(values)
            
except Exception as e:
    print(f"Error: {e}")