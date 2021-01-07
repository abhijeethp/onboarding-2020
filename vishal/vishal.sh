#!/bin/bash


# Globals
FILE_PATH="./scorecard.txt"
userLives=5
machineLives=5
options=("rock" "paper" "scissor")
defeatedby=("paper" "scissor" "rock")



function getScoreboard() {

    score=($(cat $FILE_PATH))
    userScore=${score[0]}
    machineScore=${score[1]}
    
    echo "-----------------------------"
    echo "|        ScoreCard          |"
    echo "-----------------------------"
    echo " $(whoami) -> " 
    echo " Score -> $userScore"
    echo " Lives Left -> $userLives"
    echo ""
    echo " machine -> "
    echo " Score -> $machineScore"
    echo " Lives Left -> $machineLives"
    echo ""

}

function usersMove() {
    echo "0->rock 1->paper 2->scissors "
    read -p "your move is? [0, 1, 2] :" user_choice
    echo "your move was : ${options[user_choice]}"
}

function machineMove() {
    machine_choice=$(( RANDOM % 3))
    echo "machine move was : ${options[machine_choice]}"
}


function updateScore(){
    echo "$userScore $machineScore" > $FILE_PATH 
}

function getResult() {
    
    user_defeat=${defeatedby[$user_choice]}
    machine_value=${options[$machine_choice]}
    
    if [ $user_choice -eq $machine_choice ]
    then
        echo "Game Drawn"
    elif [ "$user_defeat" == "$machine_value" ]
    then 
        echo "Machine Won...!"
        (( machineScore++ ))
        (( userLives-- ))
    else
        echo "You Won...!"
        (( userScore++ ))
        (( machineLives-- ))
    fi

}


function gameLoop() {
    while [ $userLives -gt 0 -a $machineLives -gt 0 ]
    do
        getScoreboard
        usersMove
        machineMove
        getResult
        updateScore
    done
}


# Start of game

echo "Welcome to Rock Paper Scissor"

gameLoop

echo "------- -Game Over--------------"




