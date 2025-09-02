#!/usr/bin/env bash
# element.sh - freeCodeCamp Periodic Table

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Función para armar y ejecutar la consulta
get_element_row() {
  local query="$1"
  $PSQL "$query"
}

INPUT="$1"
RESULT=""

if [[ $INPUT =~ ^[0-9]+$ ]]; then
  # Buscar por atomic_number
  RESULT="$(get_element_row "
    SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
    FROM elements e
    JOIN properties p USING(atomic_number)
    JOIN types t USING(type_id)
    WHERE e.atomic_number = $INPUT;
  ")"
else
  # Normalizar posible símbolo (Primera mayúscula + resto minúsculas)
  NORM_SYMBOL="$(echo "$INPUT" | sed -E 's/.*/\L&/; s/^(.)/\U\1/')"

  RESULT="$(get_element_row "
    SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
    FROM elements e
    JOIN properties p USING(atomic_number)
    JOIN types t USING(type_id)
    WHERE e.symbol = '$NORM_SYMBOL' OR e.name ILIKE '$INPUT';
  ")"
fi

if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

