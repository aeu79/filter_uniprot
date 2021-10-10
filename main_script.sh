#!/bin/bash


cd /home/aure/Documents/corona_data/

## UNCOMMENT TO DOWNLOAD & extract
# Download
#wget ftp://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/uniprot_trembl_viruses.dat.gz

# Extract
#gzip -d uniprot_sprot_viruses.dat.gz /output/path

# Count
echo 'Uniprot trembl viruses contains:'
grep --count '^ID ' uniprot_trembl_viruses.dat
echo '(entries)'

# Create the pattern:
echo '^DT ' > pattern
echo '^DE ' >> pattern
echo '^GN ' >> pattern
echo '^OG ' >> pattern
echo '^OX ' >> pattern
echo '^RN ' >> pattern
echo '^RP ' >> pattern
echo '^RC ' >> pattern
echo '^RX ' >> pattern
echo '^RG ' >> pattern
echo '^RA ' >> pattern
echo '^RT ' >> pattern
echo '^RL ' >> pattern
echo '^CC ' >> pattern
echo '^DR ' >> pattern
echo '^PE ' >> pattern
echo '^KW ' >> pattern
echo '^FT ' >> pattern
echo '^SQ ' >> pattern
echo '^     ' >> pattern


# Filter "Coronaviridae"
time grep -v --file=./pattern uniprot_trembl_viruses.dat | grep --ignore-case --before-context=10 --after-context=8 '^OC.*Coronaviridae;' | sed 's#//#,Final de entrada,½#g' | tr -d '\n' | tr '½' '\n' | grep '^ID ' | sed -e 's/ID   /ID,/g' -e 's/\.AC   /,Accession number,/g' -e 's/;OS   /,Organism Species,/g' -e 's/;OC   /; /g' -e 's/\.OC   /.,Organism Classification,/g' -e 's/.OH   NCBI_TaxID=/, Host,/' -e 's/.OH   NCBI_TaxID=/|/g' > Coronaviridae_trembl_broken.csv​

# Add headers
sed -i '1iUno,ID,Tres,Accession number,Cinco,Organism Species,Siete,Organism Classification,Nueve,Host,Once,count' Coronaviridae_trembl_broken.csv​

# Wait to fix csv
echo 'Now open and save the file (as Coronaviridae_trembl_fixed.csv) with LibreOffice to fix the format.'
echo 'Use save as (save as shown) and not just save or will replace ";" with "+ADs-"'
read -p "Press enter if you've done that and are ready to continue."

python3 $HOME/GitHub/sars-cov-2/format_table.py -i $HOME/Documents/corona_data/Coronaviridae_trembl_fixed.csv -o $HOME/Documents/corona_data/Coronaviridae_trembl.csv -e $HOME/Documents/corona_data/AC_list


exit
