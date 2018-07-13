note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
		redefine undo end
create
	make
feature -- command
	undo
    	do
			-- perform some update on the model state
			if
				model.old_state_count_int = 1
			then
				model.set_message2 (model.error.e19)
			else
				model.undo
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
