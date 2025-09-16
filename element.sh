#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # query element by atomic_number OR symbol OR name
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1';")

  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    # split values into variables
    echo "$ELEMENT" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL
    do
      PROPERTIES=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties AS p INNER JOIN types AS t ON p.type_id = t.type_id WHERE atomic_number='$ATOMIC_NUMBER';")
      echo $PROPERTIES | while read TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done      
    done
  fi
  
fi
