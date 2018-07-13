note
	description: "Summary description for {NEW_PHASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_PHASE
inherit
	COMMAND
create {ETF_MODEL, NEW_PHASE,REMOVE_PHASE}
	make
feature {ETF_MODEL, NEW_PHASE,REMOVE_PHASE}
	make(t : ETF_MODEL; pid : STRING; phase_name : STRING; capacity : INTEGER_64; expected_material: ARRAY[INTEGER_64])
		do
			tracker := t
			pid_new := pid
			phase_name_new := phase_name
			capacity_new := capacity
			create expected_material_new.make_empty
			expected_material_new := expected_material
			create materials.make_empty
			count := 0
			create radiation.make(10,2)
			radiation.no_justify
			radiation1 := 0.00

			old_state_count := t.state_count -- old state count in order to be used in undo
		ensure
			valid_tracker: tracker ~ t
			valid_pid: pid_new ~ pid
			valid_phase_name: phase_name_new ~ phase_name
			valid_capacity: capacity_new = capacity
			valid_expected_material: expected_material_new ~ expected_material
			valid_count: count = 0
			valid_radiation: radiation1 = 0
		end

feature -- attributes
	tracker : ETF_MODEL
	pid_new : STRING
	phase_name_new : STRING
	capacity_new : INTEGER_64
	count : INTEGER
		--number of containers in current phase
	radiation : FORMAT_DOUBLE
	radiation1 : REAL_64
	expected_material_new : ARRAY[INTEGER_64]
	materials : ARRAY[STRING]
	old_state_count : INTEGER_64
		-- store the old state count
	current_index : INTEGER
feature -- commands


	increase_count
		do
			count := count +1
		ensure
			count = old count +1
		end

	decrease_count
		do
			count := count - 1
		ensure
			count = old count - 1
		end

	increase_radiation1(r : REAL_64)
		do
			radiation1 := radiation1 + r
		ensure
			radiation1 = old radiation1 + r
		end

	decrease_radiation1(r: REAL_64)
		do
			radiation1 := radiation1 -r
		ensure
			radiation1 = old radiation1 -r
		end


feature --inherited commands
	execute
		--execute current command
	local
		i : INTEGER
		j: INTEGER
	do
	if
		tracker.state_message ~ "ok"
	then
		from
			i := expected_material_new.lower
		until
			i > expected_material_new.upper
		loop
			if expected_material_new[i] = 1
			then
				materials.force ("glass",i)
			elseif expected_material_new[i] = 2
			then
				 materials.force ("metal",i)
			elseif expected_material_new[i] = 3
			then
				materials.force ("plastic",i)
			elseif expected_material_new[i] = 4
			then
				materials.force ("liquid",i)
			else
			end
			i := i + 1
		end

		tracker.set_message (tracker.error.ok)
	end
	end

	redo
		-- redo current command
		do
			execute
			tracker.phase_objects.extend (Current)
			tracker.set_old_state_count2(old_state_count)
		ensure then
			history_unchanged: tracker.history.count = (old tracker.history).count
		end

	undo
		-- undo current command
	local
		i : INTEGER
	do
		across
			tracker.phase_objects as cursor
		loop
			if
				cursor.item.pid_new ~ pid_new
			then
				current_index := cursor.cursor_index
			end
		end
		tracker.removed_one_phase_objects (remove_phase_object(tracker.phase_objects[current_index]))

		-- if previous command in history list is an error message we undo current command, but not show to the users.
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
	ensure then
		history_unchanged: tracker.history.count = (old tracker.history).count
	end



feature -- queries
	is_error : BOOLEAN
		-- no error(set to False) if we successfully create an object of current class
		do
			Result := False
		ensure then
			Result = False
		end


	phase_out : STRING
		-- output current class information
		local
			array : STRING
			i : INTEGER
		do
			create array.make_from_string("")
			from
				i := materials.lower
			until
				i > materials.upper
			loop
				if
					i /= materials.upper
				then
					array.append(materials[i]+",")
				else
					array.append(materials[i])
				end
				i := i + 1
			end

			create Result.make_from_string("   ")
			Result := Result + pid_new + "->" + phase_name_new + ":"+capacity_new.out +","+count.out + ","+ radiation.formatted(radiation1)+"," + "{" +array+"}"
		ensure
			valid_output: Result /= void
		end


	remove_phase_object(o : NEW_PHASE) : LINKED_LIST[NEW_PHASE]
		require
			valid_input : o /= void
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
			list_not_void : Result /= void
		end

end

