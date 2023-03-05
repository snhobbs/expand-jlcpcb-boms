# Expand JLCPCB BOM

## Motivation
See [this gist](https://gist.github.com/snhobbs/969b84a1aa48b25ed7fc2294b181468f) for a walkthrough of why.

+ Use the JLCPCB database tools <https://github.com/Bouni/kicad-jlcpcb-tools>
+ Create the up-to-date parts database from kicad-jlcpcb-tools and expand the basic jlcpcb BOM using it.
+ Examples of how to do that are in wrangle_boms.sh. These are useful to add to a make file to expand the fabrication BOMs.
+ Useful for checking the BOM after putting into JLCPCB (they will auto fill fields which makes this error prone).


