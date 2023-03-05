# Take the JLCPCB data base in JSON and a BOM with the ref des and JLCPCB numbers.
# Return a BOM with the manufacturer and manufacturers part number appended
import click
import sqlite3
import os
from spreadsheet_wrangler import read_file_to_df, read_pseodonyms, extract_columns_by_pseudonyms

ordering = ("Package", "Manufacturer", "MFR.Part", "Solder Joint", "Description")

schema = {
    "parts": [],
    "mapping": ['footprint', 'value', 'LCSC'],
    "meta": ['filename', 'size', 'partcount', 'date', 'last_update'],
    "rotation": ['regex', 'correction'],
    "parts": ['LCSC Part', 'First Category', 'Second Category', 'MFR.Part', 'Package', 'Solder Joint', 'Manufacturer', 'Library Type', 'Description', 'Datasheet', 'Price', 'Stock']
}

def expand_bom_from_db(database, bom, pseudonyms):
    bom = os.path.realpath(bom)

    df = read_file_to_df(bom)
    pseudonyms=read_pseodonyms(pseudonyms)
    left = extract_columns_by_pseudonyms(df, pseudonyms)
    right = extract_columns_by_pseudonyms(df, pseudonyms)

    join_column = "LCSC Part"
    print(df.columns)
    assert(join_column in df.columns)

    # initialize to empty columns
    for column in ordering:
        if column in df:
            df[column + "_l"] = df[column] # rename the existing column
        df[column] = [""]*len(df)

    dbfile = os.path.realpath(database)
    db = sqlite3.connect(dbfile)
    selection = ",".join(["\"{}\"".format(p) for p in ordering])
    print(selection)
    for _, line in df.iterrows():
        join_value = line[join_column]
        table = get_table(join_column)
        command = f"select {selection} from {table} where \"{join_column}\"=\"{join_value}\""
        data_read = list(db.execute(command))
        if data_read:
            data = data_read[0]
            print(data)
            for column, value in zip(ordering, data):
                line[column] = value
    return df

@click.command()
@click.option("--database", "-d", default="parts.db")
@click.option("--bom", "-b", default="BOM.csv")
@click.option("--out", "-o", default=None)
@click.option("--save", "-s", type=bool, default=True)
@click.option("--pseudonyms", "-p", type=str, default="", help="Alternative column names in json format")
def main(database, bom, out, save, pseudonyms):
    if out is None:
        split = bom.split(".")
        out = f"{split[0]}_Expanded.xlsx"
    else:
        save = True

    df = expand_bom_from_db(database, bom, pseudonyms)
    if save:
        df.to_excel(out, index=False)
        print(f"Saved to {out}")
    else:
        print(df)


if __name__ == "__main__":
    command()
