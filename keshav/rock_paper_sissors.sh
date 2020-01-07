#!/bin/bash

clear

options=("rock" "paper" "sissor")
defeats=("sissor" "rock" "paper")

function get_my_move() {
    select opt in "${options[@]}"
    do
        case $opt in
            "rock")
              m=0
              my_option=$opt
              break
              ;;
            "paper")
              m=1
              my_option=$opt
              break
              ;;
            "sissor")
              m=2
              my_option=$opt
              break
              ;;
            *) echo "invalid option $REPLY";;
        esac
    done

    echo "you chose: $my_option"
}

function get_comp_move() {
    c=$(($RANDOM%3))
    comp_choice=${options[$c]}
    echo "computer chose: $comp_choice"
}

function play() {
    if [ $c == $m ]; then
        echo "it's a draw :P"
    elif [ ${options[m]} == ${defeats[c]} ]; then
        echo "you lost"
    else
        echo "you win"
    fi
}

get_my_move
get_comp_move
play