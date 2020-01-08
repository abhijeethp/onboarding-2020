#!/bin/bash
options=("rock" "paper" "scissors")
defeats=("scissors" "rock" "paper")
defeated_by=("paper" "scissors" "rock")
user_name=""

function createUser(){
  script="curl -s --location --request POST 'https://us-central1-singular-vector-135519.cloudfunctions.net/rps_set_score' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'user=$user_name' --data-urlencode 'man_score=0' --data-urlencode 'machine_score=0'"
  eval "$script"
  echo "New User Created"
}

function getInitialScores() {
    script="curl -s https://us-central1-singular-vector-135519.cloudfunctions.net/rps_get_score?user=$user_name"
    data=$(eval "$script")

    if [ "$data" == "user does not exist" ]; then
        createUser
        echo "{\"user\":\"$user_name\",\"man_score\":0,\"machine_score\":0}" > "temp.json"
    else
        echo $data > "temp.json"
    fi

    user_name=$(python3 json_query.py user)
    mans_score=$(python3 json_query.py man_score)
    machines_score=$(python3 json_query.py machine_score)

    echo "Mans Score: $mans_score"
    echo "Machines Score: $machines_score"
}

function get_mans_move() {
  echo "0->rock 1->paper 2->scissors or exit!"
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
      (( machines_score++ ))
    else
      echo "you won!"
      (( mans_score++ ))
    fi
    echo "inside winner $mans_score,$machines_score"
}

# Geting the username by user
read -p "Enter User Name:" user_name


echo "Initial Scores: "
getInitialScores


get_mans_move
get_machines_move
get_winner


function updateScore(){
 lol="curl -s --location --request POST 'https://us-central1-singular-vector-135519.cloudfunctions.net/rps_set_score' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'user=$user_name' --data-urlencode 'man_score=$mans_score' --data-urlencode 'machine_score=$machines_score'"
  eval "$lol"
  echo ""

}

updateScore
echo "Final Scores: "
getInitialScores


#curl -s --location --request POST 'https://us-central1-singular-vector-135519.cloudfunctions.net/rps_set_score' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'user=username' --data-urlencode 'man_score=0' --data-urlencode 'machine_score=0'
