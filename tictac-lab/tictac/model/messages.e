note
	description: "Summary description for {MESSAGES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGES

create
	make


feature
	make
		do

		end


feature
	ok: STRING
		attribute
			Result := "ok"
	   		end
	name_differ : STRING
		attribute
			Result := "names of players must be different"
			end

	wrong_name : STRING
		attribute
			Result := "name must start with A-Z or a-z"
			end
	wrong_turn : STRING
		attribute
			Result := "not this player's turn"
			end
	no_player : STRING
		attribute
			Result := "no such player"
			end
	button_taken : STRING
	 	attribute
	 		Result := "button already taken"
	 		end
	winner : STRING
	 	attribute
	 		Result := "there is a winner"
	 		end

	finish_first : STRING
		attribute
			Result := "finish this game first"
			end
	game_finished : STRING
		attribute
			Result := "game is finished"
			end
	end_in_tie : STRING
		attribute
			Result := "game ended in a tie"
			end
end
