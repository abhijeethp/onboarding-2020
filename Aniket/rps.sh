#!/bin/bash

# rules
# --------
# choices - rock(1) paper(2) scissors(3)
# defeats - scissors rock paper
# defeated by - paper scissors rock

# players
# -------
# man(0)
# machine(1)

# persist the score
# -------------------
# keep variables mans_score, machines_score
# load score from file
# store score in file

options=("rock" "paper" "scissors")
defeats=("scissors" "rock" "paper")
defeated_by=("paper" "scissors" "rock")
num_options="${#options[@]}"

function get(){
    curl https://us-central1-singular-vector-135519.cloudfunctions.net/rps_get_score?user=Aniket > scoretemp.txt
    python3 saveScore.py
}

function load_score(){
    read -a scores <<< "$(cat score.txt)"
    mans_score=${scores[0]}
    machines_score=${scores[1]}
    echo "scores : man->$mans_score machine->$machines_score"
}

function get_mans_move() {
    echo "0->rock 1->paper 2->scissors"
    read -p "your move is? [0, 1, 2] :" mans_choice
    # echo "your move was : ${options[mans_choice]}"
}

function get_machines_move() {
    machines_choice=$(( RANDOM % 3 ))
    # echo "the machines move was : ${options[machines_choice]}"
}

function get_winner() {
    if [ $mans_choice -eq $machines_choice ]; then
        echo "you drew"
    elif [ ${options[mans_choice]} == ${defeats[machines_choice]} ]; then
        echo "the machine won!"
        machines_score=$(( machines_score + 1))
    else
        echo "you won!"
    mans_score=$(( mans_score + 1))    
    fi
      # echo "inside winner $mans_score,$machines_score"
}

function store_score() {
    echo "$mans_score,$machines_score"
    echo "$mans_score $machines_score" > score.txt
}

function post(){
    echo "$machine_score"
    curl -s --location --request POST 'https://us-central1-singular-vector-135519.cloudfunctions.net/rps_set_score' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'user=Aniket' --data-urlencode 'man_score='"$mans_score" --data-urlencode 'machine_score='"$machines_score" 
}

get
load_score
get_mans_move
get_machines_move
get_winner
store_score
post

