#!/bin/bash

moves=(rock paper scissor)

get_users_move(){
	echo "rock(0) paper(1) scissor(2)"
	read -p "Enter your move 0, 1 or 2: " users_move
	echo "User's move : ${moves[users_move]}"
}
get_computers_move(){
	computers_move=$((  RANDOM % 3 ))
      	echo "Computer's move : ${moves[computers_move]}"
}

get_winner(){
	if [ $users_move == $computers_move ]
	then
		echo "Game Draw"
		winner=-1
	else
        	if [ ${moves[users_move]} == "rock" ]
		then
			if [ ${moves[computers_move]} == "paper" ]
			then
				winner=0
			elif [ ${moves[computers_move]} == "scissor" ]
			then
				winner=1
			fi
		elif [ ${moves[users_move]} == "paper" ]
		then
			if [ ${moves[computers_move]} == "rock" ]
			then
				winner=1
			elif [ ${moves[computers_move]} == "scissor" ]
			then
				winner=0
			fi
		else
			if [ ${moves[computers_move]} == "rock" ]
			then
				winner=0
			elif [ ${moves[computers_move]} == "paper" ]
			then
				winner=1
			fi
		fi

	fi

 	if [ ! -e score.txt ]
	then
		echo "Users_Score=0" >> score.txt
		echo "Computers_Score=0" >> score.txt
	fi

	if [ $winner == 1 ]
	then
		echo "User Wins :-)"
		user_score=$(sed -n '1p' score.txt)
		score=(${user_score//=/ })
		((score[1]++))
		sed -i '1s/.*/Users_Score='${score[1]}'/' score.txt
	elif [ $winner == 0 ]
	then
		echo "Computer Wins. Bad Luck"
		computer_score=$(sed -n '2p' score.txt)
		score=(${computer_score//=/ })
		((score[1]++))
		sed -i '2s/.*/Computers_Score='${score[1]}'/' score.txt
	else
		echo "Draw"
	fi
}

gameplay(){
	users_lives=5
	computer_lives=5

	while [[ $users_lives != 0 && $computer_lives != 0 ]]
	do
		get_users_move
		get_computers_move
		get_winner
		if [ $winner == 1 ]
		then
			((computer_lives=computer_lives-1))
		elif [ $winner == 0 ]
		then
			((users_lives=users_lives-1))
		fi
		echo "Lives Remaining:"
		echo "Users Lives: $users_lives"
		echo "Computer Lives: $computer_lives"
		echo ""
	done
}

get_scores(){
	echo "Game Scores:- "
	echo $(cat score.txt)
}

gameplay
echo " "
get_scores
