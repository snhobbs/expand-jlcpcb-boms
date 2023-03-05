JLCBOM=${1}
DESIGNBOM=${2}
DATABASE=${3}
DESIGNBOM_BASE=${DESIGNBOM%.*}
JLCBOM_BASE=${JLCBOM%.*}
PSEUDONYMS='{"Value": ["Comment"], "References": ["Designator"], "LCSC Part": ["JLCPCB Part"]}'
#DATABASE="~/tools/kicad-jlcpcb-tools/jlcpcb/parts.db"

# Uncluster from ref des
spreadsheet_wrangler.py uncluster --column="References" -p "${PSEUDONYMS}" -s ${JLCBOM} -o ${JLCBOM_BASE}_Unclustered.xlsx
spreadsheet_wrangler.py uncluster --column="References" -p "${PSEUDONYMS}" -s ${DESIGNBOM} -o ${DESIGNBOM_BASE}_Unclustered.xlsx

# Same Ref Des Delmiters
#spreadsheet_wrangler.py delimiter --column="References" -p "${PSEUDONYMS}" -n ' ' -d ',' -i ${JLCBOM}.csv -o ${JLCBOM}.xlsx

# Sort Ref Des
#spreadsheet_wrangler.py sort-column --column="References" -p "${PSEUDONYMS}" -d ' ' -i ${JLCBOM}.xlsx -o ${JLCBOM}A.xlsx
#mv ${JLCBOM}A.xlsx ${JLCBOM}.xlsx

# Expand BOM
jlc_part_lookup.py --database ${DATABASE} --bom ${JLCBOM_BASE}_Unclustered.xlsx -o ${JLCBOM_BASE}_Unclustered_Expanded.xlsx

# Merge
spreadsheet_wrangler.py merge --on="References" -p "${PSEUDONYMS}" -r ${DESIGNBOM_BASE}_Unclustered.xlsx -l ${JLCBOM_BASE}_Unclustered_Expanded.xlsx --method outer -o Merged.xlsx

