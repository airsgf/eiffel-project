note
	description: "Summary description for {MOVE_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE_CONTAINER

inherit
	COMMAND
create {ETF_MODEL}
	make

feature {ETF_MODEL}
	-- initialization
	make(t : ETF_MODEL; c : STRING; p1 : STRING; p2 : STRING)
		do
			tracker := t
			cid := c
			pid1 := p1
			pid2 := p2
			old_state_count := t.state_count -- old state count in order to be used in undo
		ensure
			valid_tracker: tracker ~ t
			valid_cid: cid ~ c
			valid_pid1: pid1 ~ p1
			valid_pid2: pid2 ~ p2
		end

feature --attributes
	tracker: ETF_MODEL
	cid : STRING
	pid1 : STRING
	pid2 : STRING
	old_state_count : INTEGER_64 -- store the old state count

feature -- inherited commands and query

	is_error : BOOLEAN
		do
			Result := False
		ensure then
			Result = False
		end

	execute
		local
			a : INTEGER
			b : INTEGER
		do

		if
			tracker.state_message ~ "ok"
		then
			tracker.set_message (tracker.error.ok)
			from
				a:= tracker.container_objects.lower
			until
				a > tracker.container_objects.count
			loop
				if
					tracker.container_objects[a].cidc ~ cid
				then
					tracker.container_objects[a].set_pid(pid2)
					from
						b := tracker.phase_objects.lower
					until
						b > tracker.phase_objects.count
					loop
						if
							tracker.phase_objects[b].pid_new ~ pid1
						then
							tracker.phase_objects[b].decrease_count
							tracker.phase_objects[b].decrease_radiation1(tracker.container_objects[a].con_r)
						elseif
							tracker.phase_objects[b].pid_new ~ pid2
						then
							tracker.phase_objects[b].increase_count
							tracker.phase_objects[b].increase_radiation1 (tracker.container_objects[a].con_r)
						end
						b := b + 1
					end

				end
				a := a+1
			end
		end
		end

	redo
		do
			execute
			tracker.set_old_state_count2(old_state_count)
		end

	undo
	do
		from
			tracker.container_objects.start
		until
			tracker.container_objects.after
		loop
			if
				tracker.container_objects.item.cidc ~ cid
			then
	            tracker.container_objects.item.set_pid (pid1)
				from
					tracker.phase_objects.start
				until
					tracker.phase_objects.after
				loop
					if
						tracker.phase_objects.item.pid_new ~ pid2
					then
						tracker.phase_objects.item.decrease_count
						tracker.phase_objects.item.decrease_radiation1(tracker.container_objects.item.con_r)
					elseif
						tracker.phase_objects.item.pid_new ~ pid1
					then
						tracker.phase_objects.item.increase_count
						tracker.phase_objects.item.increase_radiation1 (tracker.container_objects.item.con_r)
					end
					tracker.phase_objects.forth
				end
				tracker.set_old_state_count (old_state_count)
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

	end

end
