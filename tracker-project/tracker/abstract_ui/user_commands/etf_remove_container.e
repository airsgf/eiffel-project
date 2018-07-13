note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REMOVE_CONTAINER
inherit
	ETF_REMOVE_CONTAINER_INTERFACE
		redefine remove_container end
create
	make
feature -- command
	remove_container(cid: STRING)
		require else
			remove_container_precond(cid)
    	do
    		if
    			across model.container_objects as cursor all cursor.item.cidc /~ cid end
    		then
    			model.set_message2 (model.error.e15)
    		else
			-- perform some update on the model state
			model.remove_container(cid)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
