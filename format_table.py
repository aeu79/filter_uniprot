import argparse
import pandas as pd
"""
Receives a csv table to be reformatted. 
Split the ID column into info and entry name and then deletes unwanted columns.
Exports a list of accession numbers only (output).
"""

def getArgs():  # "args = None" allows to pass arguments for testing
    # (so it works also without command line arguments.
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", required=True,
                        help="Path to the csv file.")
    parser.add_argument("-o", "--output", required=False,
                        help="Path to the output csv (edited) file.")
    parser.add_argument("-e", "--export", required=False,
                        help="Path to the output list of accessions.")
    # return parser.parse_args() # Use None to avoid errors when run from PyCharm
    return parser.parse_known_args()


# Get arguments
arguments, unknown_args = getArgs()
csv_path = arguments.input
try:
    output = arguments.output
except:
    output = "edited_file.csv"
try:
    export = arguments.export
except:
    export = 'AC_list'

# Rad the file
print("Reading {}.".format(csv_path))
df_csv = pd.read_csv(csv_path) # index_col='ID'

print("Raw data: \n" + str(df_csv.shape))
# Remove unwanted rows
filtro = df_csv['Tres']=='Accession number'
filtro2 = df_csv['Siete']=='Organism Classification'
filtrados = df_csv[filtro & filtro2]
print("Filtered AC & OC: \n" + str(filtrados.shape))

# Keep desired columns
df_tabla = filtrados.loc[filtrados['Organism Classification'].str.contains('Coronaviridae'),[
    'ID', 'Accession number', 'Organism Species', 'Organism Classification', 'Host']] # .loc [rows, columns]
print("Filter Coronaviridae and keep only desired columns: \n" + str(df_tabla.shape))
df_tabla = df_tabla.reset_index()
df_tabla.drop('index', inplace=True, axis=1)


# Split the ID into its parts (entry, status and seq length)
df_tabla[['Entry name', 'new']] = df_tabla['ID'].str.split(' ', n=1, expand=True)
df_tabla[['Status', 'Seq length']] = df_tabla['new'].str.split(';', n=1, expand=True)
df_tabla.drop(['new','ID'], inplace=True, axis=1)

# Reorder the columns
columns_titles = ['Entry name', 'Status', 'Seq length','Accession number',
                  'Organism Species', 'Organism Classification','Host']
df_tabla = df_tabla.reindex(columns=columns_titles)
df_tabla.to_csv(output)
df_tabla.info()

# Export accession list
df_firstaccession = df_tabla['Accession number'].str.split(';', n=1, expand=True)
df_firstaccession.iloc[:,0].to_csv(export, index=False, header=False)