#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  # if param is not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBERS=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol = '$1' or name = '$1'")
  else
    ATOMIC_NUMBERS=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $1")
  fi

  #if atomic_number doesn't exist 
  if [[ -z $ATOMIC_NUMBERS ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ATOMIC_NUMBERS" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do 
      PROPS=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      #echo "$PROPS"
      echo "$PROPS" | while read MASS BAR MELT BAR BOIL BAR TYPE_ID
      do 
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
        #TYPE="$(sed -e 's/[[:space:]]*$//' <<<${TYPE})"
        #echo $TYPE
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    done
  fi
else
  echo "Please provide an element as an argument."
fi 

#MAIN_FUNCTION() {
#  echo "Please provide an element as an argument."
#}

#MAIN_FUNCTION
