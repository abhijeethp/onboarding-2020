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
# keep variables man_score, machine_score
# load score from file
# store score in file

options=("rock" "paper" "scissors")
defeats=("scissors" "rock" "paper")
defeated_by=("paper" "scissors" "rock")
num_options="${#options[@]}"

function load_score(){
    man_score=$(curl https://us-central1-singular-vector-135519.cloudfunctions.net/rps_get_score?user=keshavLakhotia | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["man_score"]')
    machine_score=$(curl https://us-central1-singular-vector-135519.cloudfunctions.net/rps_get_score?user=keshavLakhotia | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["machine_score"]')
    echo "loaded scores : man->$man_score machine->$machine_score"
}

function get_mans_move() {
    echo "0->rock 1->paper 2->scissors"
    read -p "your move is? [0, 1, 2] :" mans_choice
    echo "your move was : ${options[mans_choice]}"
}

function get_machines_move() {
    machines_choice=$(( RANDOM % 3 ))
    echo "the machines move was : ${options[machines_choice]}"
}

function get_winner() {
    if [ $mans_choice -eq $machines_choice ]; then
        echo "you drew"
    elif [ ${options[mans_choice]} == ${defeats[machines_choice]} ]; then
        echo "the machine won!"
        machine_score=$(( machine_score + 1))
    else
        echo "you won!"
        man_score=$(( man_score + 1))
    fi
}

function post_score(){
    echo "final scores $man_score $machine_score"
    curl -s --location --request POST 'https://us-central1-singular-vector-135519.cloudfunctions.net/rps_set_score' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'user=keshavLakhotia' --data-urlencode 'man_score='"$man_score" --data-urlencode 'machine_score='"$machine_score"
}

load_score
get_mans_move
get_machines_move
get_winner
post_score