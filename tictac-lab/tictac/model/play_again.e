note
	description: "Summary description for {PLAY_AGAIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY_AGAIN
inherit
	COMMAND

create
	make


feature
	make(g : TICTAC)
		do
			game := g
			create old_message.make_from_string(game.message_string)
			create old_gameinfo.make_from_string(game.gameinfo_string)
		end


feature
	game : TICTAC
	old_message: STRING
	old_gameinfo: STRING


feature
	execute
		do
			if
				game.check_if_game_finished
			then -- switch play order, who play first,he or she will play second at next game
				if game.first_player ~ game.player1.name
				then
				 	game.first_play(game.player2.name)
				 	game.second_play(game.player1.name)
				 	game.current_play(game.first_player)
				 	game.board.gameboard.fill_with("_")
				 	game.clear_history
				 	game.message_string.make_from_string (game.message.ok)
		 			game.gameinfo_string.make_from_string (game.gameinfo.next_player (game.current_player))

				else
					game.first_play(game.player1.name)
					game.second_play(game.player2.name)
					game.current_play(game.second_player)
					game.board.gameboard.fill_with("_")
					game.clear_history
					game.message_string.make_from_string (game.message.ok)
		 			game.gameinfo_string.make_from_string (game.gameinfo.next_player (game.current_player))
				end
			else
				game.message_string.make_from_string(game.message.finish_first)

			end
		end


	undo
		do
			game.message_string.make_from_string (old_message)
			game.gameinfo_string.make_from_string (old_gameinfo)
		end


	redo
		do
			execute
		end
end
