JLCBOM=${1}
DESIGNBOM=${2}
PSEUDONYMS='{"Value": ["Comment"], "References": ["Designator"]}'
DATABASE="~/tools/kicad-jlcpcb-tools/jlcpcb/parts.db"

# Uncluster from ref des
spreadsheet_wrangler.py uncluster --column="References" -p "${PSEUDONYMS}" -s ${JLCBOM}.csv -o ${JLCBOM}_Unclustered.xlsx
spreadsheet_wrangler.py uncluster --column="References" -p "${PSEUDONYMS}" -s ${DESIGNBOM}.csv -o ${DESIGNBOM}_Unclustered.xlsx

# Same Ref Des Delmiters
#spreadsheet_wrangler.py delimiter --column="References" -p "${PSEUDONYMS}" -n ' ' -d ',' -i ${JLCBOM}.csv -o ${JLCBOM}.xlsx

# Sort Ref Des
#spreadsheet_wrangler.py sort-column --column="References" -p "${PSEUDONYMS}" -d ' ' -i ${JLCBOM}.xlsx -o ${JLCBOM}A.xlsx
#mv ${JLCBOM}A.xlsx ${JLCBOM}.xlsx

# Expand BOM
jlc_part_lookup.py --database ${DATABASE} --bom ${JLCBOM}_Unclustered.xlsx -o ${JLCBOM}_Unclustered_Expanded.xlsx

# Merge
spreadsheet_wrangler.py merge --on="References" -p "${PSEUDONYMS}" -r ${DESIGNBOM}_Unclustered.xlsx -l ${JLCBOM}_Unclustered_Expanded.xlsx --method outer -o Merged.xlsx

