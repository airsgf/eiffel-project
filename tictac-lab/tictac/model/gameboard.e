note
	description: "Summary description for {GAMEBOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAMEBOARD


inherit
	ANY
		redefine
			out
			end


create
	make


feature
	make(i : INTEGER_32; j : INTEGER_32)
		require
			i > 0 and j > 0
			do
				create gameboard.make_filled("_",i,j)
				create original.make_from_string("_")
				create x.make_from_string("X")
				create o.make_from_string("O")
			end


feature
	gameboard : ARRAY[STRING]
	original : STRING
	x : STRING
	o : STRING



feature
	out : STRING
		local
			a : INTEGER
		do
			create Result.make_from_string ("  ")
			from
				a := gameboard.lower
			until
				a > gameboard.upper
			loop
				if(a = 4 or a = 7)
				then
					Result.append("%N  ")
				else
				end
			Result.append(gameboard[a])
			a := a + 1
			end
		end
end
