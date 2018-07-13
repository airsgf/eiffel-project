note
	description: "Summary description for {NEW_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_CONTAINER
inherit
	COMMAND
create{ETF_MODEL, REMOVE_CONTAINER}
	make

feature {ETF_MODEL,REMOVE_CONTAINER}
	-- initialization
	make(t : ETF_MODEL; cid: STRING ; ct: TUPLE[material: INTEGER_64; radioactivity: VALUE] ; pid: STRING)
		do
			tracker := t
			cidc := cid
			con := ct
			pidc := pid
			con_m := con.m
			con_r := con.rad.as_double
			create con_r_format.make(10,2)
			con_r_format.no_justify
			create material.make_empty

			old_state_count := t.state_count -- old state count in order to be used in undo
		ensure
			valid_tracker: tracker ~ t
			valid_cid: cidc ~ cid
			valid_tuple: con ~ ct
			valid_pid: pidc ~ pid
		end



feature -- attributes
	tracker : ETF_MODEL
	cidc : STRING
	con : TUPLE[m : INTEGER_64; rad : VALUE]
	pidc : STRING
	con_m : INTEGER_64
	con_r : REAL_64
	con_r_format: FORMAT_DOUBLE
	material : STRING
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
			i : INTEGER
			p : INTEGER
			p1 : INTEGER
			old_phase_rad: REAL_64
		do
			if
				tracker.state_message ~ "ok"
			then

			from
				i := tracker.phase_objects.lower
			until
				i > tracker.phase_objects.count
			loop
				if
					tracker.phase_objects[i].pid_new ~ pidc

				then
					tracker.phase_objects[i].increase_count
					tracker.phase_objects[i].increase_radiation1(con_r)
				else

				end
				i := i + 1
			end

			if
				con_m = 1
			then
			 	material := "glass"
			elseif
				con_m = 2
			then
				material := "metal"
			elseif
				con_m = 3
			then
				material := "plastic"
			elseif
				con_m = 4
			then
				material := "liquid"
			end
			tracker.set_message (tracker.error.ok)
			end
		end

	redo
		do
			execute
			tracker.container_objects.extend (Current)
			tracker.set_old_state_count2(old_state_count)
		ensure then
			history_unchanged: tracker.history.count = (old tracker.history).count
		end




	undo
		do
			from
				tracker.phase_objects.start
			until
				tracker.phase_objects.after
			loop
				if
					tracker.phase_objects.item.pid_new ~ pidc
				then
					tracker.phase_objects.item.decrease_count
					tracker.phase_objects.item.decrease_radiation1 (con_r)
				end
				tracker.phase_objects.forth
			end

			from
				tracker.container_objects.start
			until
				tracker.container_objects.after
			loop
				if
					tracker.container_objects.item.cidc ~ cidc
				then
					tracker.container_objects.remove
				end
				if
					not tracker.container_objects.after
				then
					tracker.container_objects.forth
				end

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
	container_out : STRING
		-- output current class information
		do
			create Result.make_from_string ("  ")
			Result := Result + cidc + "->" + pidc + "->"+ material +","+ con_r_format.formatted(con_r)
		ensure
			valid_output: Result /= void
		end


	set_pid(pid : STRING)
		-- set pid to current class
		require
			not_void: pid /= void
		do
			pidc := pid
		ensure
			valid_pid: pidc ~ pid
		end
end
