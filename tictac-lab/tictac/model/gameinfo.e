note
	description: "Summary description for {GAMEINFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAMEINFO

create
	make


feature
	make
		do

		end


feature -- attributes
	next_player(player : STRING) : STRING
		do
			Result := player + " plays next"
		end

	new_game : STRING
		do
			Result := "start new game"
		end

	play_again_or_new_game : STRING
		do
			Result := "play again or start new game"
		end
end
