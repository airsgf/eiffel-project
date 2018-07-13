note
	description: "Summary description for {NEW_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_GAME
inherit
	COMMAND
create
	make

feature -- attributes
	p1_name, p2_name : STRING

	newgame : TICTAC



feature -- initialization
	make(new_game : TICTAC; player_one : STRING; player_two : STRING)
		do
			newgame := new_game
			p1_name := player_one
			p2_name := player_two

		end



	execute
		do
			if p1_name ~ p2_name
			then
				newgame.message_string.make_from_string (newgame.message.name_differ)
			elseif
				p1_name.is_empty or
				p2_name.is_empty or
				(not p1_name.at (1).is_alpha) or
				(not p2_name.at (1).is_alpha)
			then
				newgame.message_string.make_from_string (newgame.message.wrong_name)
			else
			newgame.clear_history
			newgame.board.gameboard.fill_with("_")
			newgame.set_name (p1_name, p2_name)
			newgame.first_play(newgame.player1.name)
			newgame.second_play(newgame.player2.name)
			newgame.current_play(newgame.first_player)
			newgame.player1.set_score (0)
			newgame.player2.set_score (0)
			newgame.set_game_is_finished (false)

			newgame.message_string.make_from_string (newgame.message.ok)
			newgame.gameinfo_string.make_from_string (newgame.gameinfo.next_player (newgame.current_player))
			end

		end

	undo
		do

		end
	redo
		do

		end
end
