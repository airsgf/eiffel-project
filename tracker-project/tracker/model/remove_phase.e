note
	description: "Summary description for {REMOVE_PHASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_PHASE
inherit
	COMMAND

create {ETF_MODEL}
	make

feature {ETF_MODEL}
	-- initialization
	make(t : ETF_MODEL; p : STRING)
		do
			tracker := t
			pid := p
			old_state_count := t.state_count -- old state count in order to be used in undo
			old_phase_object := t.phase_of (p)
		ensure
			valid_tracker: tracker ~ t
			valid_pid: pid ~ p
		end

feature -- attributes

	tracker : ETF_MODEL
	pid : STRING
	old_phase_object: NEW_PHASE
	old_state_count : INTEGER_64
	current_index: INTEGER

feature -- inherited commands and query

	is_error : BOOLEAN
		do
			Result := False
		ensure then
		 	Result = False
		end

	execute
	local
		i: INTEGER
		do
			if
				tracker.state_message ~ "ok"
			then
				from
					i:= tracker.phase_objects.lower
				until
					i > tracker.phase_objects.count
				loop
					if
						tracker.phase_objects[i].pid_new ~ pid
					then
						current_index := i
					end
					i:=i + 1
				end
			end
			tracker.removed_one_phase_objects (remove_phase_object(tracker.phase_objects[current_index]))
		end

	redo
		do
			execute
			tracker.set_old_state_count2(old_state_count)
		ensure then
			history_unchanged: tracker.history.count = (old tracker.history).count
		end

	undo
		do

			tracker.phase_objects.extend (old_phase_object)

			if
		    	not tracker.history.before
			then
				tracker.history.back
				if
					tracker.history.item.is_error
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
		ensure then
			history_unchanged: tracker.history.count = (old tracker.history).count
		end


feature --query
	remove_phase_object(o : NEW_PHASE) : LINKED_LIST[NEW_PHASE]
		require
			valid_input: o /= void
		local
			index: INTEGER
			new_phase_objects : LINKED_LIST[NEW_PHASE]
			in: INTEGER
		do
			in := 1
			create new_phase_objects.make
			from
				index :=tracker.phase_objects.lower
			until
				index >tracker.phase_objects.count
			loop
				if
					tracker.phase_objects[index].pid_new /~ o.pid_new
				then
					new_phase_objects.extend(tracker.phase_objects[index])
					in := in + 1
				else
				end
				index := index + 1
			end
			Result := new_phase_objects
		ensure
			Result /= void
		end

end
