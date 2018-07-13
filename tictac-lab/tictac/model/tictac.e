note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	TICTAC

inherit
	ANY
		redefine
			out
		end

create {TICTAC_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create	board.make(1,9)


			create player1.make
				player1.set_score(0)


			create player2.make
				player2.set_score(0)

			create gameinfo.make
			create message.make
			create gameinfo_string.make_from_string(gameinfo.new_game)
			create message_string.make_from_string(message.ok)

			create first_player.make_empty
			create second_player.make_empty
			create current_player.make_empty
			create history.make
		end



feature
	new_game(p1 : STRING; p2 : STRING)
		local
			ng : NEW_GAME
		do
			create ng.make(Current, p1, p2)
			ng.execute

		end

	play(p : STRING; press : INTEGER)
		local
			pl : PLAY
		do
			if
				history.index < history.count
			then
				history.remove_right
			end
			create pl.make (Current, p, press.as_integer_32)
			history.extend(pl)
			history.forth
			pl.execute
		end


	play_again
		local
			pa: PLAY_AGAIN
		do
			create pa.make (Current)
			pa.execute
		end


	undo
		local
			u : COMMAND
		do
			if
				not history.is_empty and
				not history.before
			then
				u := history.item
				u.undo
				history.back
			end
		end


	redo
		local
			r : COMMAND
		do
				if
					not history.is_empty and history.index < history.count
				then


				history.forth
				r := history.item
				r.redo
				end
		end


feature -- attributes
	player1, player2 : PLAYER
	board : GAMEBOARD
	gameinfo : GAMEINFO
	message: MESSAGES
	gameinfo_string : STRING
	message_string : STRING

	first_player : STRING
	second_player : STRING
	current_player: STRING

	game_finished : BOOLEAN

	history : LINKED_LIST[COMMAND]

feature

	set_name(name1: STRING; name2 : STRING)
		do
			player1.set_name (name1)
			player2.set_name (name2)

		end

	first_play(first : STRING)
		do
			first_player:=first
		end
	second_play(second : STRING)
		do
			second_player := second
		end


	current_play(c : STRING)
		do
			current_player := c
		end


	set_game_is_finished(o : BOOLEAN)
	 	do
	 		game_finished := o
	 	end


	check_if_game_finished : BOOLEAN
		do
			Result := game_finished
		end


	check_if_win : BOOLEAN
		do
					if	(board.gameboard[1] ~ "X" and board.gameboard[2] ~ "X" and board.gameboard[3] ~ "X")or
						(board.gameboard[4] ~ "X" and board.gameboard[5] ~ "X" and board.gameboard[6] ~ "X")or
						(board.gameboard[7] ~ "X" and board.gameboard[8] ~ "X" and board.gameboard[9] ~ "X")or
						(board.gameboard[1] ~ "X" and board.gameboard[4] ~ "X" and board.gameboard[7] ~ "X")or
						(board.gameboard[2] ~ "X" and board.gameboard[5] ~ "X" and board.gameboard[8] ~ "X")or
						(board.gameboard[3] ~ "X" and board.gameboard[6] ~ "X" and board.gameboard[9] ~ "X")or
						(board.gameboard[1] ~ "X" and board.gameboard[5] ~ "X" and board.gameboard[9] ~ "X")or
						(board.gameboard[3] ~ "X" and board.gameboard[5] ~ "X" and board.gameboard[7] ~ "X")or
						(board.gameboard[1] ~ "O" and board.gameboard[2] ~ "O" and board.gameboard[3] ~ "O")or
						(board.gameboard[4] ~ "O" and board.gameboard[5] ~ "O" and board.gameboard[6] ~ "O")or
						(board.gameboard[7] ~ "O" and board.gameboard[8] ~ "O" and board.gameboard[9] ~ "O")or
						(board.gameboard[1] ~ "O" and board.gameboard[4] ~ "O" and board.gameboard[7] ~ "O")or
						(board.gameboard[2] ~ "O" and board.gameboard[5] ~ "O" and board.gameboard[8] ~ "O")or
						(board.gameboard[3] ~ "O" and board.gameboard[6] ~ "O" and board.gameboard[9] ~ "O")or
						(board.gameboard[1] ~ "O" and board.gameboard[5] ~ "O" and board.gameboard[9] ~ "O")or
						(board.gameboard[3] ~ "O" and board.gameboard[5] ~ "O" and board.gameboard[7] ~ "O")
					then
						Result := true
					else
						Result := false
					end

		end

	check_if_tie :	BOOLEAN
		local
			index : INTEGER
			tf: BOOLEAN

		do
			tf := true
			from
				index := board.gameboard.lower
			until
				index > board.gameboard.upper
			loop
				if
					board.gameboard[index] ~ "_"
				then
					tf := false
				end
				index := index + 1
			end
			Result := tf
		end

	clear_history
		local
			new: LINKED_LIST[COMMAND]
		do
			create new.make
			history := new

		end


feature -- model operations
	default_update
			-- Perform update to the model state.
		do

		end

	reset
			-- Reset model state.
		do
			make
		end


feature -- queries
	out : STRING
		do

			create Result.make_from_string ("  ")
			if gameinfo_string ~ "start new game"
			then
				Result.append (message_string + ":  => ")
				Result.append (gameinfo_string + "%N")
				Result.append(board.out + "%N")
				Result.append("  " + player1.score.out + ": score for " + "%""+ player1.name + "%"" + " (as X)")
				Result.append("%N")
				Result.append("  " + player2.score.out + ": score for " + "%""+ player2.name + "%"" + " (as O)")

			else



			Result.append (message_string + ": => ")
			Result.append (gameinfo_string + "%N")
			Result.append(board.out + "%N")
			Result.append("  " + player1.score.out + ": score for " + "%""+ player1.name + "%"" + " (as X)")
			Result.append("%N")
			Result.append("  " + player2.score.out + ": score for " + "%""+ player2.name + "%"" + " (as O)")
			end

		end

end




