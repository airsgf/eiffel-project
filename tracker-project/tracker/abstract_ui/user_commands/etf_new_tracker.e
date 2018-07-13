note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_TRACKER
inherit
	ETF_NEW_TRACKER_INTERFACE
		redefine new_tracker end
create
	make
feature -- command
	new_tracker(max_phase_radiation: VALUE ; max_container_radiation: VALUE)

    	do
			-- perform some update on the model state
			if max_phase_radiation.as_double < 0
			then
				model.set_message2 (model.error.e2)
			elseif max_container_radiation.as_double < 0
			then
			 	model.set_message2 (model.error.e3)
			elseif max_container_radiation.as_double > max_phase_radiation.as_double

			then
				model.set_message2 (model.error.e4)
			else

				model.new_tracker(max_phase_radiation.as_double, max_container_radiation.as_double)

			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
