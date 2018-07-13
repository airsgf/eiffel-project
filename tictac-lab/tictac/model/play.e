note
	description: "Summary description for {PLAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY
inherit
	COMMAND

create
	make
feature
	make( g : TICTAC ;p : STRING ; press : INTEGER)
		do
			game := g
			player := p
			position := press.as_integer_32
			create old_message.make_from_string(game.message_string)
			create old_gameinfo.make_from_string(game.gameinfo_string)

		end




feature
	game : TICTAC
	player : STRING
	position: INTEGER


	old_message: STRING
	old_gameinfo : STRING
	old_score1: INTEGER
	old_score2: INTEGER




feature
	execute
	do


		if
			check_if_player_can_play
		then
		 	if
		 		game.current_player ~ game.player1.name
		 	then
		 		game.board.gameboard.put (game.board.x, position)
		 		if
		 			game.check_if_win
		 		then
		 			old_score1 := game.player1.score
		 			old_score2 := game.player2.score
		 			game.player1.plus_one
		 			game.set_game_is_finished (true)
		 			game.message_string.make_from_string (game.message.winner)
		 			game.gameinfo_string.make_from_string (game.gameinfo.play_again_or_new_game)
		 		elseif
					game.check_if_tie
		 		then
		 			game.set_game_is_finished (true)
		 			game.message_string.make_from_string (game.message.end_in_tie)
		 			game.gameinfo_string.make_from_string (game.gameinfo.play_again_or_new_game)
				else
					game.set_game_is_finished (false)
					game.current_play (game.player2.name)
					game.message_string.make_from_string (game.message.ok)
		 			game.gameinfo_string.make_from_string (game.gameinfo.next_player (game.current_player))

		 		end

		 	else
		 		game.board.gameboard.put (game.board.o, position)
		 		if
		 			game.check_if_win
		 		then
		 			old_score1 := game.player1.score
		 			old_score2 := game.player2.score
		 			game.player2.plus_one
		 			game.set_game_is_finished (true)
		 			game.message_string.make_from_string (game.message.winner)
		 			game.gameinfo_string.make_from_string (game.gameinfo.play_again_or_new_game)
		 		elseif
					game.check_if_tie
		 		then
		 			game.set_game_is_finished (true)
		 			game.message_string.make_from_string (game.message.end_in_tie)
		 			game.gameinfo_string.make_from_string (game.gameinfo.play_again_or_new_game)
				else
					game.set_game_is_finished (false)
					game.current_play (game.player1.name)
					game.message_string.make_from_string (game.message.ok)
		 			game.gameinfo_string.make_from_string (game.gameinfo.next_player (game.current_player))
		 		end

		 	end
		elseif
			player /~ game.player2.name and
			player /~ game.player1.name
		then
			game.message_string.make_from_string (game.message.no_player)
		elseif
			player /~ game.current_player
		then
			game.message_string.make_from_string (game.message.wrong_turn)
		elseif
			game.board.gameboard[position] /~ "_"
		then
			game.message_string.make_from_string (game.message.button_taken)
		end
	end

	undo
	do
		if game.check_if_game_finished
		then
			game.player1.set_score (old_score1)
			game.player2.set_score (old_score2)
			game.board.gameboard.put(game.board.original, position)
			if
				game.current_player ~ game.player1.name
			then
				game.current_play (game.player2.name)
				game.message_string.make_from_string (old_message)
				game.gameinfo_string.make_from_string (old_gameinfo)
				game.set_game_is_finished (false)
			else
				game.current_play (game.player1.name)
				game.message_string.make_from_string (old_message)
				game.gameinfo_string.make_from_string (old_gameinfo)
				game.set_game_is_finished (false)
			end

		else


				game.board.gameboard.put(game.board.original, position)
			if
				game.current_player ~ game.player1.name
			then
				game.current_play (game.player2.name)
				game.message_string.make_from_string (old_message)
				game.gameinfo_string.make_from_string (old_gameinfo)
			else
				game.current_play (game.player1.name)
				game.message_string.make_from_string (old_message)
				game.gameinfo_string.make_from_string (old_gameinfo)
			end
		end
	end


	redo
	do
		execute

	end


feature{NONE}
	check_if_player_can_play : BOOLEAN
		do
			Result := player ~ game.current_player and game.board.gameboard[position] ~ "_"
		end
end
