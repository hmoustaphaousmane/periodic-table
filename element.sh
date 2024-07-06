#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c" 2>/dev/null

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  KEY=$1

  if [[ $($PSQL "SELECT * FROM elements WHERE atomic_number = $KEY;" 2>/dev/null) ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $KEY;")
  elif [[ $($PSQL "SELECT * FROM elements WHERE symbol = '$KEY';" 2>/dev/null) ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$KEY';")
  elif [[ ELEMENT=$($PSQL "SELECT * FROM elements WHERE name = '$KEY';" 2>/dev/null) ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE name = '$KEY';")
    # fi
  else
    exit 1
  fi
  echo "$ELEMENT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME
  do
    # echo "$ATOMIC_NUMBER, $SYMBOL, $NAME"
    PROPERTIES=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    echo "$PROPERTIES" | while IFS='|' read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID
    do
      # echo "$ATOMIC_NUMBER $ATOMIC_MASS $MELTING_POINT_CELSIUS $BOILING_POINT_CELSIUS $TYPE_ID"
      TYPES=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID;")
      echo "$TYPES" | while IFS='|' read TYPE
      do
        # echo "$TYPE"
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    done
  done
fi