import csv
import codecs

##### CLEAN UP REPORT ####
# Clean up GAdsDISC raw report before it gets processed and encode it in a compatible format
def clean_disc(path):
    new_landing = '/tmp/gads_disc.csv'
    with open(path) as f1:
        reader = csv.reader(f1)
        next(reader) # Skip Title line
        next(reader) # Skip Date Range line
        next(reader) # Skip column headers
        header = ['date', 'campaign', 'ad_group', 'device', 'currency', 'cost', 'impressions']
        with open(new_landing, 'w', encoding='utf-8') as f2:
            writer = csv.writer(f2)
            writer.writerow(header)
            for row in reader:
                row[5] = row[5].replace(',','')
                row[6] = int(row[6].replace(',',''))
                writer.writerow(row)
    return new_landing
