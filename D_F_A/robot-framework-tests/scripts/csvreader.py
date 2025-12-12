import csv

def read_csv_file(filename='robot-framework-tests/env/publiccountryspecific.csv'):
    '''This creates a keyword named "Read CSV File"

        This keyword takes one argument, which is a path to a .csv file. It
        returns a list of rows, with each row being a list of the data in
        each column.
        '''
    data = []
    with open(filename, 'rt') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
                data.append(row)
    return data

print(read_csv_file())