note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
		redefine redo end
create
	make
feature -- command
	redo
    	do
			-- perform some update on the model state
			if
				model.old_state_count_int > model.history.count -- state count should be larger than history.count, cause new_tracker command did not put in the history list
			then
				model.set_message2 (model.error.e20)
			else
				model.redo
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
