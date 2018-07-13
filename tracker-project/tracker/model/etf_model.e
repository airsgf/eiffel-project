note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create error.make
			state_count := 0
			create state_message.make_empty
			state_message.append("ok")
			create max_phase_radiation.make (10,2)
			max_phase_radiation.no_justify
			max_phase_radiation1 := 0.00
			create max_container_radiation.make(10,2)
			max_container_radiation.no_justify
			max_container_radiation1 := 0.00
			create p.make_empty
			p.append("phases: pid->name:capacity,count,radiation")
			create c.make_empty
			c.append("containers: cid->pid->material,radioactivity")

			--new phase
			create phase_objects.make
		--	phase_objects_num := 0
			create sorted_phase.make

			--new_container
			create container_objects.make
			container_objects_num :=0
			create sorted_container.make

			--history
			create history.make

			create old_state_count.make_empty
		ensure
			state_count = 0
			state_message ~ "ok"
			max_phase_radiation1 = 0
			max_container_radiation = 0


		end

feature -- model attributes
	error : ERROR
	state_count : INTEGER_64
	old_state_count_int : INTEGER_64
	old_state_count: STRING
	state_message : STRING
	p : STRING
	c : STRING

	max_phase_radiation: FORMAT_DOUBLE
	max_phase_radiation1 : REAL_64
		-- assign the the value of max_phase_radiation to the type of REAL_64
	max_container_radiation: FORMAT_DOUBLE
	max_container_radiation1: REAL_64
		-- assign the value of max_container_radiation to the type of REAL_64

	-- new_phase attributes
	phase_objects: LINKED_LIST[NEW_PHASE]
--	phase_objects_num : INTEGER
	sorted_phase : LINKED_LIST[NEW_PHASE]

	--new_container attributes
	container_objects : LINKED_LIST[NEW_CONTAINER]
	container_objects_num: INTEGER
	sorted_container: LINKED_LIST[NEW_CONTAINER]

	--history list store executed commands
	history : LINKED_LIST[COMMAND]

feature -- command

	sort_phase_objects
		-- sort objects in the list "phase_objects" to increasing order accroding to "pid" and store the sorted list into a new array which called "sorted_phase"
		local
			i : INTEGER
			j : INTEGER
			k : INTEGER
			pid_list : SORTED_TWO_WAY_LIST[STRING]
		do
			clear_sorted_phase
			create pid_list.make
			from
				i := phase_objects.lower
			until
				i > phase_objects.count
			loop
				pid_list.extend(phase_objects[i].pid_new)
				i := i+1
			end
			pid_list.sort
			from
				j := 1
			until
				j > pid_list.count
			loop
				from
					k := phase_objects.lower
				until
					k > phase_objects.count
				loop
					if pid_list[j] ~ phase_objects[k].pid_new
					then
						sorted_phase.extend(phase_objects[k])
					end
					k := k+1
				end
				j:=j+1
			end
		ensure
			order_changed_elements_unchanged: across sorted_phase as cursor all phase_objects.has(cursor.item) end
		end

		sort_container_objects
			-- sort objects in the list "container_objects" to increasing order accroding to "cid" and store the sorted list into a new list which called "sorted_container"
			local
				x : INTEGER
				y : INTEGER
				z : INTEGER
				cid_list : SORTED_TWO_WAY_LIST[STRING]
			do
				clear_sorted_container
					-- each time before we sort "container_objects", we must (clear)make current "sorted_container" empty
				create cid_list.make
				from
					x := container_objects.lower
				until
					x > container_objects.count
				loop
					cid_list.extend (container_objects[x].cidc)
					x := x + 1
				end
				cid_list.sort
				from
					y := cid_list.lower
				until
					y > cid_list.count
				loop
					from
						z := container_objects.lower
					until
						z > container_objects.count
					loop
						if
							cid_list[y] ~ container_objects[z].cidc
						then
							sorted_container.extend(container_objects[z])
						end
						z := z + 1
					end
					y := y + 1
				end
			ensure
				order_changed_elements_unchanged: across sorted_container as cursor all container_objects.has(cursor.item) end
			end

	set_message2(set2 : STRING)
		--set ok or error message for output
		require
			valid_input : set2 /= void
		local
			error_command: ERROR_COMMAND
		do
			create error_command.make(Current, set2)
			error_command.execute
			if
				set2 /~ error.e19 and set2 /~ error.e20
			then
				history.extend (error_command)
				history.forth
			end
		ensure
			valid_output : state_message /= void
		end
	set_message(set: STRING)
		do
			state_message:= set
		ensure
			correct_state_message: state_message ~ set
		end


	set_old_state_count(number : INTEGER_64)
	    -- set old state count in undo
		require
			valid_number: number > 0
		do
			old_state_count_int := number-1
			old_state_count := "(to "+(number-1).out+") "

		ensure
			valid_string: old_state_count ~ "(to "+(number-1).out+") "
		end

	set_old_state_count2(number2: INTEGER_64)
	    -- set old state count in redo
		require
			valid_number: number2 > 0
		do
			old_state_count_int := number2
			old_state_count := "(to "+ number2.out + ") "
		ensure
			valid_string: old_state_count ~ "(to "+number2.out+") "
		end

	removed_one_container_objects(new_container_objects : LINKED_LIST[NEW_CONTAINER])
		--after removing one element from "conatiner_objects", store the rest of them into "container_objects"
		do

			container_objects := new_container_objects
		end

	removed_one_phase_objects(new_phase_objects : LINKED_LIST[NEW_PHASE])
		--after removing one element from "phase_objects", store the rest of them into "phase_objects"
		do
			phase_objects := new_phase_objects
		end

	clear_sorted_container
		--clear array which called "sorted_continer"
		local
			cleared_sorted_container : LINKED_LIST[NEW_CONTAINER]
		do
			create cleared_sorted_container.make
			sorted_container:= cleared_sorted_container
		ensure
			list_is_empty: sorted_container.is_empty
		end

	clear_sorted_phase
		--clear array which called "sorted_phase"
		local
			cleared_sorted_phase: LINKED_LIST[NEW_PHASE]
		do
			create cleared_sorted_phase.make
			sorted_phase := cleared_sorted_phase
		ensure
			list_is_empty : sorted_phase.is_empty
		end

	default_update
		do

		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	container_of(cc : STRING): NEW_CONTAINER
		-- input cid and return its corresponding object from container_objects
		require
			container_not_empty: not container_objects.is_empty
			container_exist : across container_objects as cursor some cursor.item.cidc ~ cc end

		do
			create Result.make (Current, container_objects[1].cidc, container_objects[1].con,container_objects[1].pidc)
			across
				container_objects as cursor
			loop
				if
					cursor.item.cidc ~cc
				then
					Result := cursor.item
				end
			end
		ensure
			Result.cidc ~ cc
		end

	phase_of(phase_id : STRING) : NEW_PHASE
		--input pid and return its corresponding object from phase_objects
		require
			phase_not_empty:	not phase_objects.is_empty
			phase_exist: across phase_objects as cursor some cursor.item.pid_new ~ phase_id  end
		do
			create Result.make(Current,phase_objects[1].pid_new, phase_objects[1].phase_name_new, phase_objects[1].capacity_new, phase_objects[1].expected_material_new)
			across
				phase_objects as cursor
			loop
				if
					cursor.item.pid_new ~ phase_id
				then
					Result := cursor.item
				end
			end
		ensure
			Result.pid_new ~ phase_id
		end


feature -- model commands

	new_tracker(mpr : REAL_64; mcr : REAL_64)
		require
			positive_phase_radiation: mpr > 0
			positive_container_radiation: mcr > 0
			phase_radiation_greater_than_container_radiation: mcr <= mpr
		do
				max_phase_radiation1 := mpr
				max_container_radiation1 := mcr
				set_message(error.ok)
		ensure
			max_phase_radiation1_not_void: max_phase_radiation1 = mpr
			max_container_radiation1_not_void: max_container_radiation1 = mcr
			state_message_ok: state_message ~ "ok"
		end		-- create a new tracker

	new_phase(pid: STRING ; phase_name: STRING ; capacity: INTEGER_64 ; expected_materials:ARRAY[INTEGER_64])
		require
			valid_pid : pid.at (1).is_alpha_numeric
			valid_phase_name: phase_name.at (1).is_alpha_numeric
			valid_capacity : capacity > 0
			exit_epected_materials: not expected_materials.is_empty
		local
			np : NEW_PHASE
		do
			create np.make(Current, pid, phase_name, capacity, expected_materials)
			np.execute
			if
				history.index < history.count
			then
				history.remove_right
			end
			phase_objects.extend(np)
			history.extend (np) -- add current object to history list
			history.forth
		ensure
			phase_objects_count_increased: phase_objects.count = (old phase_objects.deep_twin).count + 1
			phase_objects_added: across phase_objects as cursor some cursor.item.pid_new ~ pid end
			other_phase_objects_unchanged: across old phase_objects.deep_twin as cursor all cursor.item.pid_new /~ pid end
			state_message_ok: state_message ~ "ok"
			history_count_increased: history.count = (old history.deep_twin).count + 1

		end 		--create a new phase

	new_container(cid: STRING ; ct: TUPLE[material: INTEGER_64; radioactivity: VALUE] ; pid: STRING)
		--create new container
		require
			valid_cid : cid.at (1).is_alpha_numeric
			valid_pid : pid.at (1).is_alpha_numeric
			phase_exist : across phase_objects as c0 some c0.item.pid_new ~ pid end
			valid_material : across phase_objects as c1 some c1.item.pid_new ~ pid implies c1.item.expected_material_new.has(ct.material) end
				-- container material must be one of the expected materials in target phase
			valid_radioactivity : ct.radioactivity.as_double >= 0 and ct.radioactivity.as_double <= max_container_radiation1
		local
			nc : NEW_CONTAINER
		do
			create nc.make(Current, cid, ct, pid)
			nc.execute
			if
				history.index < history.count
			then
				history.remove_right
			end
			container_objects.extend (nc)
			container_objects_num := container_objects_num + 1
			history.extend (nc)
			history.forth
		ensure
			container_objects_count_increased : container_objects.count = (old container_objects.deep_twin).count + 1
			container_objects_num_increased : container_objects_num = old container_objects_num + 1
			container_objects_added : across container_objects as cursor some cursor.item.cidc  ~ cid end
			other_container_objects_unchanged:   across old container_objects.deep_twin as cursor all cursor.item.cidc /~ cid  end
			not_greater_than_max_phase_radiation : across phase_objects as c3 some c3.item.pid_new ~ pid implies c3.item.radiation1 <= max_phase_radiation1 end
			state_message_ok: state_message ~ "ok"
			history_count_increased: history.count = (old history.deep_twin).count + 1
		end

	move_container(cid :STRING ; pid1 : STRING; pid2: STRING)
		--move one container from one phase to another
		require
			container_exist: across container_objects as cursor some cursor.item.cidc ~ cid  end
			source_phase_exist: across phase_objects as cursor some cursor.item.pid_new ~ pid1  end
			target_phase_exist: across phase_objects as cursor some cursor.item.pid_new ~ pid2  end
			pid_different : pid1 /~ pid2
			container_already_in_source_phase: container_of(cid).pidc ~ pid1
		local
			mc: MOVE_CONTAINER
		do
			create mc.make(Current,cid, pid1, pid2)
			mc.execute
			if
				history.index < history.count
			then
				history.remove_right
			end
			history.extend (mc)
			history.forth
		ensure
			success_moved: container_of(cid).pidc ~ pid2
			history_count_increased: history.count = (old history.deep_twin).count + 1
		end

	remove_container(cid : STRING)
		-- remove one container from phase
		require
			container_exist : across container_objects as cursor some cursor.item.cidc ~ cid  end
		local
			rm : REMOVE_CONTAINER
		do
			create rm.make(Current, cid)
			rm.execute
			if
				history.index < history.count
			then
				history.remove_right
			end
			history.extend (rm)
			history.forth
			container_objects_num := container_objects_num - 1
		ensure
			not container_objects.has (container_of(cid))
			history_count_increased: history.count = (old history.deep_twin).count + 1
		end

	remove_phase(pid: STRING)
		--remove phase when there is no contianer in it
		require
			phase_exist: across phase_objects as cursor some cursor.item.pid_new ~ pid  end
			phase_has_no_container: phase_of(pid).count = 0

		local
			rp : REMOVE_PHASE
		do
			create rp.make(Current, pid)
			rp.execute
			if
				history.index < history.count
			then
				history.remove_right
			end
			history.extend (rp)
			history.forth
		ensure
			success_removed: not phase_objects.has (phase_of(pid))
			history_count_increased: history.count = (old history.deep_twin).count + 1
		end

	undo
		local
			op : COMMAND
		do
			op:=history.item
			op.undo
			history.back
		ensure
			history.count = (old history.deep_twin).count
		end

	redo
		local
			rd: COMMAND
		do
			history.forth
			rd := history.item
			rd.redo
		ensure
			history.count = (old history.deep_twin).count
		end

feature -- output
	out : STRING
	local
		a: INTEGER
		b: INTEGER

		do
			create Result.make_from_string ("  ")
			if
				state_message /~ "ok"
			then
				Result := Result + "state"+ " " + state_count.out + " "+old_state_count + state_message
				state_count := state_count + 1
				set_message(error.ok)
			else
				Result := Result + "state"+ " " + state_count.out + " " +old_state_count+ state_message + "%N"
				Result := Result + "  " + "max_phase_radiation:" + " " + max_phase_radiation.formatted(max_phase_radiation1) + ", " + "max_container_radiation:"
				+ " " + max_container_radiation.formatted(max_container_radiation1) + "%N"
				Result := Result + "  " + p

				if not phase_objects.is_empty
				then
					sort_phase_objects
					from
						a := sorted_phase.lower
					until
						a > sorted_phase.count
					loop
						Result := Result +"%N" + " " + sorted_phase[a].phase_out
						a:= a+1
					end
				end
				Result := Result +"%N"+ "  " + c
				if
					not container_objects.is_empty
				then
					sort_container_objects
					from
						b := sorted_container.lower
					until
						b > sorted_container.count
					loop
						Result := Result + "%N" +"  " + sorted_container[b].container_out
						b := b+1
					end
				end

				state_count := state_count + 1
			end
			old_state_count.make_empty
		end
end




