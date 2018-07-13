note
	description: "Summary description for {PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER
inherit
	ANY

create
	make


feature
	make
		do
			create name.make_empty
		end


feature --attributes
	name : STRING
	score : INTEGER


feature -- queris
	set_name( player_name : STRING)
		do
			name := player_name
		end

	set_score( player_score : INTEGER)
	 	do
	 		score := player_score
	 	end

	plus_one
		do
			score := score + 1
		end


end
