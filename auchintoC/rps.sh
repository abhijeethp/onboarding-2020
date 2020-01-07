#!/bin/bash

# rules
# --------
# choices - rock (1), paper(2), scissor(3)
# defeats - scissor rock paper
# defeated by - paper scissor rock

# players
# -------
# man (0)
# computer (1)

# persist the score
# -------
# keep the variables: manScore, pcScore
# load the score from file
# store the score in file

options=("rock" "paper" "scissor")
defeats=("scissor" "rock" "paper")
defeatedBy=("paper" "scissor" "rock")
num_options="${#options[@]}"  # (@) flattens out the array: array -> list; finally returns the length of the list

function get_man_move(){
  echo "0->rock 1->paper 2->scissors"
  read -p "your move is? [0, 1, 2] :" mans_choice
  echo "your move was : ${options[mans_choice]}"
}

function get_pc_move(){
  pc_choice=$(( RANDOM % 3 ))
  echo "pc move was : ${options[pc_choice]}"
}

function load_score(){
  IFS="," read -a score <<< "$(cat score.txt)"
  mans_score=${score[0]}
  pc_score=${score[1]}
  echo "scores : man -> $mans_score, pc -> $pc_score"
}

function get_winner(){
  if [ ${options[mans_choice]} == ${options[pc_choice]} ]; then
    echo "DRAW"
  elif [ ${defeats[mans_choice]} == ${options[pc_choice]} ]; then
    echo "YOU WIN"
    (( mans_score++ ))
  else
    echo "YOU LOSE"
    (( pc_score++ ))
  fi
}

function store_score(){
  echo "scores : man -> $mans_score, pc -> $pc_score"
  echo "$mans_score,$pc_score" > score.txt
}

load_score
get_man_move
get_pc_move
get_winner
store_score