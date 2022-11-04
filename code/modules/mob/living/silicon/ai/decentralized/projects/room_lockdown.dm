/datum/ai_project/room_lockdown
	name = "Room Lockdown"
	description = "This ability will allow you to close and bolt all working doors, and trigger the fire alarms in a clicked area after a short delay and announcement."
	research_cost = 2000
	ram_required = 0

	category = AI_PROJECT_CROWD_CONTROL
	
	can_be_run = FALSE
	ability_path = /datum/action/innate/ai/ranged/room_lockdown
	ability_recharge_cost = 1000

/datum/ai_project/room_lockdown/finish()
	add_ability(ability_path)

/datum/action/innate/ai/ranged/room_lockdown
	name = "Room Lockdown"
	desc = "Closes and bolts all working doors and triggers the fire alarm in a clicked room. Takes 2.5 seconds to take effect, and expires after 20 seconds."
	button_icon_state = "lockdown"
	uses = 1
	delete_on_empty = FALSE
	linked_ability_type = /obj/effect/proc_holder/ranged_ai/room_lockdown

/datum/action/innate/ai/ranged/room_lockdown/proc/lock_room(atom/target)
	if(target && !QDELETED(target))
		var/area/A = get_area(target)
		if(!A)
			return FALSE
		if(!is_station_level(A.z))
			return FALSE
		log_game("[key_name(usr)] locked down [A].")
		minor_announce("Lockdown commencing in area [A] within 2.5 seconds","Network Alert:", TRUE)
		addtimer(CALLBACK(src, .proc/_lock_room, target), 2.5 SECONDS)
		return TRUE


/datum/action/innate/ai/ranged/room_lockdown/proc/_lock_room(atom/target)
	var/area/A = target
	for(var/obj/machinery/door/airlock/D in A.contents)
		if(istype(D, /obj/machinery/door/airlock/external))
			continue
		INVOKE_ASYNC(D, /obj/machinery/door/airlock.proc/safe_lockdown)
		addtimer(CALLBACK(D, /obj/machinery/door/airlock.proc/disable_safe_lockdown), 20 SECONDS)
	A.firealert(loc)
	addtimer(CALLBACK(A, /area.proc/firereset), 20 SECONDS)
			

/obj/effect/proc_holder/ranged_ai/room_lockdown
	active = FALSE
	enable_text = span_notice("You ready the lockdown signal.")
	disable_text = span_notice("You disarm the lockdown signal.")

/obj/effect/proc_holder/ranged_ai/room_lockdown/InterceptClickOn(mob/living/caller, params, atom/target)
	if(..())
		return
	if(ranged_ability_user.incapacitated())
		remove_ranged_ability()
		return
	var/area/A = get_area(target)
	if(!A)
		to_chat(ranged_ability_user, span_warning("No area detected!"))
		return
	if(istype(A, /area/maintenance))
		to_chat(ranged_ability_user, span_warning("It is not possible to lockdown maintenance areas due to poor networking!"))
		return


	var/datum/action/innate/ai/ranged/room_lockdown/action = attached_action
	if(action.lock_room(A))
		attached_action.adjust_uses(-1)
		to_chat(caller, span_notice("You lock [A]."))
	remove_ranged_ability()
	return TRUE
