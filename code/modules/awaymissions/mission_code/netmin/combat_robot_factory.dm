/area/awaymission/vr/combat_robot_factory
	name = "Abandoned Robot Factory"
	icon_state = "awaycontent4"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	pacifist = FALSE

/obj/item/paper/fluff/awaymissions/robot_factory/shipment_details
	name = "Shipment Details"
	info = "<b>Shipment Details:</b> <br>500x Agricultural Robots @ 1999.95 cr<br>200x Construction Robots @ 2499.95 cr<br><br><b>Total:</b> 1,499,965 cr<br><br><b>Destination:</b><br>Gamnar Military Base"

/obj/item/paper/fluff/awaymissions/robot_factory/advanced_model
	name = "Personal Research"
	info = "I've crunched the numbers on the capabilities of the servors in these robots. I'm pretty certain they could handle additional armor plating, and maybe even a more powerful gun. I'll tell the boss after I've finished my prototypes."

/obj/item/paper/fluff/awaymissions/robot_factory/benny
	name = "diary entry #631"
	info = "I should really stop naming all my passwords after you, <B>Benny</B>. The boss says it isn't secure, wouldn't want the workers getting in to the emergency supplies."

/obj/item/paper/fluff/awaymissions/robot_factory/spider
	name = "Beware: Spider"
	info = "Stop leaving your leftovers out! It's attracting bugs, and with bugs comes spiders. We've called an exterminator but the breakroom is off-limits until then."

/obj/item/paper/fluff/awaymissions/robot_factory/classified
	name = "Research Notes"
	info = {"The biggest limiter to the efficiency of our robots have always been the rigid programming. The Board has ordered me to explore if it's feasible to use human minds instead of programming. \
	If possible they should make a formidable addition as a commander type robot.\
	We'd have to wipe their memories or I'm sure they wouldn't be happy..."}


/obj/item/disk/holodisk/combat_robot/introduction
	preset_image_type = /datum/preset_holoimage/cc_official
	preset_record_text = {"
	NAME HR Representative
	DELAY 30
	SAY Welcome aboard your new home for the next 12 months!
	DELAY 30
	SAY As you know from the job listing your main duties will be to refill machinery, pack boxes, and most importantly..
	DELAY 30
	SAY Not asking any questions.
	DELAY 45
	SAY In addition, please refrain from bothering the Corporate Liason stationed here unless he specifically asks for your help.
	DELAY 30"}


/obj/item/disk/holodisk/combat_robot/classified
	preset_image_type = /datum/preset_holoimage/cc_official
	preset_record_text = {"
	NAME Mr. Nakada
	DELAY 30
	SAY Research log number 63
	DELAY 45
	SAY Further attempts to artifically grow and integrate a human host have failed.
	DELAY 60
	SAY Attempting one further growth cycle before returning to Central Command 
	DELAY 60
	SAY Using the local supervisor as the neural template.
	DELAY 60
	SAY Final report is estimated to be completed within the next two weeks.
	DELAY 30"}

/obj/item/disk/holodisk/combat_robot/experiment
	preset_image_type = /datum/preset_holoimage/researcher
	preset_record_text = {"
	NAME Doctor Williams
	DELAY 30
	SAY Beginning experiment number 31
	DELAY 60
	SAY Injecting solution...
	DELAY 45
	SAY Subject appears to be displaying decreased blood pressure. Subject having difficulty maintaining consciousness.
	DELAY 60
	SAY Neural activity appears incompatible with capture device.  
	DELAY 50
	SAY Subject has expired. End log for experiment number 31.
	DELAY 30"}

/obj/item/disk/holodisk/combat_robot/factory_floor
	preset_image_type = /datum/preset_holoimage/nanotrasenprivatesecurity
	preset_record_text = {"
	NAME Officer Rymes
	DELAY 30
	SAY After last nights incident I believe we should reiterate the corporate policy on rioting.
	DELAY 45
	SAY In case of any kind of illegal striking or insurrection by the stationed workers you are to close the blast door to the factory floor.
	DELAY 75
	SAY After the situation is under control and production ready to resume you should unlock the door.
	DELAY 45
	SAY For the forgetful amongst you, the password is 'Zandar' after our dear CEO.
	DELAY 45
	SAY Don't forget that the door is voice activated.
	DELAY 30"}
