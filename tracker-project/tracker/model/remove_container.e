note
	description: "Summary description for {REMOVE_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_CONTAINER
inherit
	COMMAND

create
	make
feature --initialization

	make(t : ETF_MODEL; c : STRING)
		do
			tracker := t
			cid := c
			old_state_count := t.state_count -- old state count in order to be used in undo
			old_container:= t.container_of (c)
		ensure
			valid_tracker: tracker ~ t
			valid_cid: cid ~ c
		end

feature -- attributes

	tracker : ETF_MODEL
	cid : STRING
	old_state_count : INTEGER_64
		-- store the old state count
	old_container: NEW_CONTAINER

feature -- inherited commands and qury

	is_error : BOOLEAN
		do
			Result := False
		ensure then
			Result = False
		end

	execute
	local
		c : INTEGER
		p : INTEGER
		index_container : INTEGER
		do

		if
			tracker.state_message ~ "ok"
		then


			from
				c := tracker.container_objects.lower
			until
				c > tracker.container_objects.count
			loop
				if
					tracker.container_objects[c].cidc ~ cid
				then
					index_container := c
					from
						p:= tracker.phase_objects.lower
					until
						p > tracker.phase_objects.count
					loop
						if
							tracker.phase_objects[p].pid_new ~ tracker.container_objects[c].pidc
						then
							tracker.phase_objects[p].decrease_count
							tracker.phase_objects[p].decrease_radiation1(tracker.container_objects[c].con_r)
						end
						p := p + 1


					end
				end
				c := c + 1
			end
			tracker.removed_one_container_objects(remove_container_object(tracker.container_objects[index_container])) -- new tracker.container_objects
		end
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
			tracker.container_objects.extend (old_container)
			from
				tracker.container_objects.start
			until
				tracker.container_objects.after
			loop
				if
					tracker.container_objects.item.cidc ~ cid
				then
					from
						tracker.phase_objects.start
					until
						tracker.phase_objects.after
					loop
						if
							tracker.phase_objects.item.pid_new ~ tracker.container_objects.item.pidc
						then
							tracker.phase_objects.item.increase_count
							tracker.phase_objects.item.increase_radiation1 (tracker.container_objects.item.con_r)
						end
						tracker.phase_objects.forth
					end

				end
				tracker.container_objects.forth
			end


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

feature -- query
	remove_container_object(o: NEW_CONTAINER) : LINKED_LIST[NEW_CONTAINER]
		require
			valid_input: o /= void
		local
			new_container_objects: LINKED_LIST[NEW_CONTAINER]
			i : INTEGER
		do
			create new_container_objects.make
			from
				i := tracker.container_objects.lower
			until
				i > tracker.container_objects.count
			loop
				if
					tracker.container_objects[i].cidc /~ o.cidc
				then
					new_container_objects.extend(tracker.container_objects[i])
				else
				end
				i := i + 1
			end
			Result := new_container_objects
		ensure
			vlaid_output: Result /= void
		end
end
