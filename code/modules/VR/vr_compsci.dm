GLOBAL_DATUM_INIT(compsci_vr, /datum/compsci_vr, new)
GLOBAL_LIST_EMPTY(compsci_mission_markers)
GLOBAL_VAR(compsci_vr_mission_reciever)


/datum/compsci_vr
	var/unlocked_missions = list()

	var/roundstart_missions = list(
		/datum/compsci_mission/scientist_raid
	)


	var/datum/compsci_mission/current_mission

	var/mob/living/ai_occupant

	var/emagged = TRUE


/datum/compsci_vr/New()
	. = ..()
	unlocked_missions |= roundstart_missions

/datum/compsci_vr/proc/can_join(mob/user)
	if(isAI(user) && ai_occupant)
		return FALSE
	return TRUE

/datum/compsci_vr/proc/emag(mob/user)
	emagged = TRUE

/datum/compsci_vr/proc/complete_mission()
	if(current_mission)
		unlocked_missions -= current_mission.type
		current_mission.complete()
		QDEL_NULL(current_mission)

/datum/compsci_vr/proc/start_mission(id)
	if(current_mission)
		return
	var/datum/compsci_mission/found_mission
	for(var/datum/compsci_mission/unlocked as anything in unlocked_missions)
		if(initial(unlocked.id) == id)
			found_mission = unlocked
			break

	if(!found_mission)
		return
	var/datum/compsci_mission/new_m = new found_mission()
	current_mission = new_m

	var/obj/effect/landmark/vr_spawn/vr_mission/V_landmark = safepick(GLOB.compsci_mission_markers[current_mission.id])
	var/turf/T = get_turf(V_landmark)
	var/datum/outfit/mission_outfit = new(V_landmark.vr_outfit)
	if(human_occupant)
		mission_outfit.equip(human_occupant)
		human_occupant.forceMove(T)

	if(ai_occupant)
		mission_outfit.equip(ai_occupant)
		ai_occupant.forceMove(T)


/obj/machinery/computer/compsci_mission_selector
	name = "exploration drone dispatch console"
	desc = "Used for monitoring the various servers assigned to the AI network."

	icon_keyboard = "tech_key"
	icon_screen = "ai-fixer"
	light_color = LIGHT_COLOR_PINK

/obj/machinery/computer/compsci_mission_selector/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CompsciMissionSelect", name)
		ui.open()

/obj/machinery/computer/compsci_mission_selector/ui_data(mob/living/carbon/human/user)
	var/list/data = list()
	data["missions"] = list()
	for(var/datum/compsci_mission/M as anything in GLOB.compsci_vr.unlocked_missions)
		data["missions"] += list(list("name" = initial(M.name), "desc" = initial(M.desc), "id" = initial(M.id)))
	return data

/obj/machinery/computer/compsci_mission_selector/ui_act(action, list/params)
	if(..())
		return
	
	switch(action)
		if("start_mission")
			var/mission_id = params["mission_id"]
			GLOB.compsci_vr.start_mission(mission_id)


/obj/machinery/compsci_reciever
	name = "bluespace item transmuter"
	desc = "Use this to send artifacts back ot the station"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	pass_flags = PASSTABLE
	
/obj/machinery/compsci_reciever/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(is_station_level(T.z))
		if(!GLOB.compsci_vr_mission_reciever)
			GLOB.compsci_vr_mission_reciever = src
		name = "bluespace item reciever"
		desc = "Used to recieve artifacts from remote exploration drones"

/obj/machinery/compsci_reciever/Destroy()
	. = ..()
	if(GLOB.compsci_vr_mission_reciever == src)
		GLOB.compsci_vr_mission_reciever = null

/obj/machinery/compsci_reciever/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!istype(user, /mob/living/carbon/human/virtual_reality))
		return
	if(GLOB.compsci_vr.current_mission && istype(I, GLOB.compsci_vr.current_mission.completion_item))
		var/obj/machinery/compsci_reciever/station_machine = GLOB.compsci_vr_mission_reciever
		I.forceMove(station_machine.drop_location())
		GLOB.compsci_vr.complete_mission()
		to_chat(user, span_notice("Successfully transferred artifact. Now reverting to reality.."))
		qdel(user)
		return TRUE
