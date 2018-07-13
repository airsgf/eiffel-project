note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REMOVE_PHASE
inherit
	ETF_REMOVE_PHASE_INTERFACE
		redefine remove_phase end
create
	make
feature -- command
	remove_phase(pid: STRING)
		require else
			remove_phase_precond(pid)
    	do
    		if
    			across model.phase_objects as cursor all cursor.item.pid_new  /~ pid end
    		then
    			model.set_message2 (model.error.e9)
    		else
			-- perform some update on the model state
			model.remove_phase(pid)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
