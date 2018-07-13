note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	TICTAC_ACCESS

feature
	m: TICTAC
		once
			create Result.make
		end

invariant
	m = m
end




