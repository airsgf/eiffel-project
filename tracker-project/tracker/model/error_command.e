note
	description: "Summary description for {ERROR_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR_COMMAND
inherit
	COMMAND
create
	make
feature -- initialize
	make(t : ETF_MODEL; error: STRING)
		do
			tracker := t
			error_command := error
			old_state_count := t.state_count -- old state count in order to be used in undo
		ensure
			valid_tracker: tracker ~ t
			valid_error: error_command ~ error
		end

feature -- attributes
	tracker : ETF_MODEL
	error_command: STRING
	old_state_count : INTEGER_64 -- store the old state count

feature -- inherited commands and query

	is_error : BOOLEAN
		do
			Result := True
		ensure then
			Result = True
		end

	execute
		do

			tracker.set_message (error_command)
		end


	undo
		do
			tracker.set_message (tracker.error.ok)

			if
		    	not tracker.history.before
			then
				tracker.history.back
				if
					tracker.history.readable and tracker.history.item.is_error
				then
					check attached {ERROR_COMMAND} tracker.history.item as h1
					then
					tracker.set_message (h1.error_command)
					end
					tracker.history.forth
				else
					tracker.history.forth
				end
			end

			tracker.set_old_state_count (old_state_count)
		end

	redo
		do
			execute
			tracker.set_old_state_count2(old_state_count)
		end

end
