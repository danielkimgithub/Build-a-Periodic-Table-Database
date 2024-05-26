#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    GET_SELECTED_ELEMENT=$($PSQL "select name, symbol, p.atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id from properties p inner join elements using (atomic_number) inner join types using (type_id) where symbol ilike '$1' or name ilike '$1';")
  else
    GET_SELECTED_ELEMENT=$($PSQL "select name, symbol, p.atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, p.type_id from properties p inner join types using (type_id) inner join elements using (atomic_number) where atomic_number = $1;")
  fi
  if [[ -z $GET_SELECTED_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $GET_SELECTED_ELEMENT | while read name bar symbol bar atomic_number bar type bar atomic_mass bar melting_pt bar boiling_pt bar type_id
    do
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_pt celsius and a boiling point of $boiling_pt celsius."
    done 
  fi
fi
