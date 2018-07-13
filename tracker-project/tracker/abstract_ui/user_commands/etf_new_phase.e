note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_PHASE
inherit
	ETF_NEW_PHASE_INTERFACE
		redefine new_phase end
create
	make
feature -- command
	new_phase(pid: STRING ; phase_name: STRING ; capacity: INTEGER_64 ; expected_materials: ARRAY[INTEGER_64])

		require else
			new_phase_precond(pid, phase_name, capacity, expected_materials)

    	do
			if
			 pid.is_empty or (not pid.at (1).is_alpha_numeric)
			then
				model.set_message2 (model.error.e5)
			elseif
				across model.phase_objects as c1 some c1.item.pid_new ~ pid end
			then
				model.set_message2 (model.error.e6)
			elseif
				phase_name.is_empty or (not phase_name.at (1).is_alpha_numeric)
			then
				model.set_message2 (model.error.e5)
			elseif
				capacity <= 0
			then
				model.set_message2 (model.error.e7)
			elseif
				expected_materials.is_empty

			then
				model.set_message2 (model.error.e8)

			else
				-- perform some update on the model state

				model.new_phase(pid, phase_name, capacity, expected_materials)

			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
