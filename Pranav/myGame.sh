
# choices - rock(1) paper(2) scissors(3)
# defeats - scissors rock paper
# defeated by - paper scissors rock
# players
# -------
# man(0)
# machine(1)

options=("rock" "paper" "scissor")
defeat=("scissor" "rock" "paper")
defeatBy=("paper" "scissor" "rock") 


function get_mans_option() {
	echo ""
	echo "Please enter your move"
	echo "Enter 1.Rock 2.Paper 3.Scissor"
	read -p "Your move is? :" mans_move
	echo "Mans move is ${options[mans_move]}"
}

function get_computer_move() {
 	computer_move=$(( RANDOM % 3 ))
	echo "Computer's move is ${options[computer_move]}"
}

function get_winner() {

	if [ ${options[mans_move]} == ${options[computer_move]} ]; then
		echo "It's Draw!"
	elif [ ${options[mans_move]} == ${defeat[computer_move]} ]; then
		echo "Computer win"
		(( comp_score++ ))
		(( mans_life-- ))
		(( mans_score-- ))
	else 
		echo "You won"
		(( mans_score++ ))
		(( comp_life-- ))
		(( comp_score-- ))
	fi
}

mans_life=5
comp_life=5

while [[ $mans_life -ne 0 && $comp_life -ne 0 ]]; do 

	typeset -i mans_score=$(cat mans_life_file.txt)
	typeset -i comp_score=$(cat comp_life_file.txt)

	get_mans_option
	get_computer_move
	get_winner

	echo "Now Mans life are $mans_life and comps life are $comp_life"

	if [ $mans_life -eq 0 ]; then
		echo "Computer won the game! Better Luck Next Time!!"
	elif [ $comp_life -eq 0 ]; then
		echo "You won the game! Congrats!!"
	else 
		echo "Continue..."
	fi

	echo "$mans_score" > "mans_life_file.txt"
	echo "$comp_score" > "comp_life_file.txt"

done

echo ""

