note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE_CONTAINER
inherit
	ETF_MOVE_CONTAINER_INTERFACE
		redefine move_container end
create
	make
feature -- command
	move_container(cid: STRING ; pid1: STRING ; pid2: STRING)
		require else
			move_container_precond(cid, pid1, pid2)
    	do
    		if
    			across model.container_objects as cursor all cursor.item.cidc  /~ cid end
    		then
    			model.set_message2 (model.error.e15)
    		elseif
    			pid1 ~ pid2
    		then
    			model.set_message2 (model.error.e16)
    		elseif
    			across model.phase_objects as cursor all cursor.item.pid_new /~ pid1 end
    		then
    			model.set_message2 (model.error.e9)
    		elseif
    			across model.phase_objects as cursor all cursor.item.pid_new /~ pid2 end
    		then
    			model.set_message2 (model.error.e9)
    		elseif
    			model.container_of(cid).pidc /~ pid1
    		then
    			model.set_message2 (model.error.e17)
    		elseif
    			model.phase_of(pid2).count = model.phase_of (pid2).capacity_new
    		then
    			model.set_message2 (model.error.e11)
    		elseif
    			model.phase_of (pid2).radiation1 + model.container_of (cid).con_r > model.max_phase_radiation1
    		then
    			model.set_message2 (model.error.e12)
    		elseif
    			not	model.phase_of(pid2).expected_material_new.has(model.container_of(cid).con_m)
    		then
    			model.set_message2 (model.error.e13)

    		else

			-- perform some update on the model state
			model.move_container(cid, pid1,pid2)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
