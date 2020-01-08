#!/bin/bash

options=("rock" "paper" "scissor")
defeats=("scissors" "rock" "paper")
num_options="${#options[@]}"

function get_mans_move() {
  echo "0->rock 1->paper 2->scissors"
  read -p "your move is? [0, 1, 2] :" mans_choice
  echo "your move was : ${options[mans_choice]}"
}
function get_machines_move() {
  machines_choice=$(( RANDOM % 3 ))
  echo "the machines move was : ${options[machines_choice]}"
}
function load_score(){
  st="curl -s https://us-central1-singular-vector-135519.cloudfunctions.net/rps_get_score?user=kashmira"
  eval "$st"
  IFS="," read -a scores <<< "$(cat score.txt)"
  mans_score=${scores[0]}
  machines_score=${scores[1]}
  echo "scores : man->$mans_score machine->$machines_score"
}
function get_winner() {
    if [ $mans_choice -eq $machines_choice ]; then
      echo "you drew"
    elif [ ${options[mans_choice]} == ${defeats[machines_choice]} ]; then
      echo "the machine won!"
      (( machines_score++ ))
    else
      echo "you won!"
      (( mans_score++ ))
    fi
}
function store_score() {
  st="curl -s --location --request POST 'https://us-central1-singular-vector-135519.cloudfunctions.net/rps_set_score' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'user=kashmira' --data-urlencode 'man_score=$mans_score' --data-urlencode 'machine_score=$machines_score'"
  echo $(eval "$st")
  echo "scores : man->$mans_score machine->$machines_score"
  echo "$mans_score,$machines_score" > score.txt
}

load_score
get_mans_move
get_machines_move
get_winner
store_score