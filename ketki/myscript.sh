#!/bin/bash

# rules
# ------
# choices -> rock(0), paper(1), scissor(2)
# defeats -> scissor, rock, paper
# defeated by -> paper, scissor, rock

# players
# -------
# man -> 0
# machine -> 1

# live
# -----
# everyone gets 5 lives

options=(rock paper scissor)
defeats=(scissor rock paper)

function load_scores(){
	ind=0
	for i in $(cat score.txt)
	do
		if [ $ind -eq 0 ] 
		then
			man_score=$i
		else
			machine_score=$i
		fi
		ind=$(expr $ind + 1)
	done
	echo "man's score is : $man_score"
	echo "machine's score is : $machine_score"
	echo " "
}
		
function get_man_move() {
	echo "${options[@]}"
	echo "options -> rock(0) , paper(1), scissor(2)"
	read -p "what is your move? :"  mans_move
	echo "your move was ${options[mans_move]}"
}

function get_machine_move()
{
	machine_move=$(( RANDOM % 3 ))
	echo "machine's move was ${options[machine_move]}" 
}


function declare_winner()
{
	if [ ${options[mans_move]} == ${options[machine_move]} ]
	then
		echo "DRAW"
	elif [ ${options[machine_move]} == ${defeats[mans_move]} ]
	then
		man_score=$(expr $man_score + 1)
		echo "you win"
	else
		machine_score=$(expr $machine_score + 1)
		echo "You loose"
	fi

	echo "current scores:"
	echo "man : $man_score"
	echo "machine : $machine_score"
}

function get_final_winner(){
	echo "FINAL RESULT:"
	if [ $man_score -eq $machine_score ]
	then
		echo "DRAW"
	elif [ $man_score -gt $machine_score ]
	then
		echo "YOU WIN"
	else
		echo "YOU LOOSE"
	fi
}

function write_scores(){
	string="$man_score $machine_score"
	echo "$string" > "score.txt"
}

load_scores
echo "you get five lives"
echo " "
for j in 1 2 3 4 5
do
	echo ""
	get_man_move
	get_machine_move
	declare_winner
	echo ""
done
get_final_winner
write_scores
