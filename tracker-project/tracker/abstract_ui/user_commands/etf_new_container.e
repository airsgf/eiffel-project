note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_CONTAINER
inherit
	ETF_NEW_CONTAINER_INTERFACE
		redefine new_container end
create
	make
feature -- command
	new_container(cid: STRING ; c: TUPLE[material: INTEGER_64; radioactivity: VALUE] ; pid: STRING)
		require else
			new_container_precond(cid, c, pid)
    	do
    		if
    			cid.is_empty or (not cid.at (1).is_alpha_numeric)
    		then
    			model.set_message2 (model.error.e5)
    		elseif
    			across model.container_objects as co some co.item.cidc  ~ cid end
    		then
    			model.set_message2 (model.error.e10)
    		elseif
    			pid.is_empty or (not pid.at (1).is_alpha_numeric)
    		then
    			model.set_message2 (model.error.e5)
    		elseif
    			across model.phase_objects as po all po.item.pid_new /~ pid end
    		then
    			model.set_message2(model.error.e9)
    		elseif
    			c.radioactivity.as_double < 0
    		then
    			model.set_message2 (model.error.e18)
    		elseif
    			model.phase_of (pid).count = model.phase_of (pid).capacity_new
    		then
    			model.set_message2 (model.error.e11)
    		elseif
    			c.radioactivity.as_double > model.max_container_radiation1
    		then
    			model.set_message2 (model.error.e14)
    		elseif
    			model.phase_of (pid).radiation1 + c.radioactivity.as_double > model.max_phase_radiation1
    		then
    			model.set_message2 (model.error.e12)
    		elseif
    			not	model.phase_of(pid).expected_material_new.has(c.material)
    		then
    			model.set_message2 (model.error.e13)

    		else
			-- perform some update on the model state
			model.new_container(cid,c,pid)  --no error and call new_container in ETF_MODEL
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
