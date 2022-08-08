////////////////////////////////////////////
// AI NETWORK DATUM
// each contiguous network of ethernet cables & AI machinery
/////////////////////////////////////
/datum/ai_network
	var/number					// unique id
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected machines

	var/list/ai_list = list() 	//List of all AIs in this network

	var/list/remote_networks = list()

	var/total_activity = 0		// How much data is being sent through the network. For transmitters and receivers
	
	var/networked_cpu = 0		//How much CPU is in this network
	var/networked_ram = 0		//How much RAM is in this network


/datum/ai_network/New()
	SSmachines.ainets += src

/datum/ai_network/Destroy()
	//Go away references, you suck!
	for(var/obj/structure/ethernet_cable/C in cables)
		cables -= C
		C.network = null
	for(var/obj/machinery/ai/M in nodes)
		nodes -= M
		M.network = null

	SSmachines.ainets -= src
	return ..()

/datum/ai_network/proc/is_empty()
	return !cables.len && !nodes.len

//remove a cable from the current network
//if the network is then empty, delete it
//Warning : this proc DON'T check if the cable exists
/datum/ai_network/proc/remove_cable(obj/structure/ethernet_cable/C)
	cables -= C
	C.network = null
	if(is_empty())//the network is now empty...
		qdel(src)///... delete it

//add a cable to the current network
//Warning : this proc DON'T check if the cable exists
/datum/ai_network/proc/add_cable(obj/structure/ethernet_cable/C)
	if(C.network)// if C already has a network...
		if(C.network == src)
			return
		else
			C.network.remove_cable(C) //..remove it
	C.network = src
	cables +=C

//remove a power machine from the current network
//if the network is then empty, delete it
//Warning : this proc DON'T check if the machine exists
/datum/ai_network/proc/remove_machine(obj/machinery/ai/M)
	nodes -=M
	M.network = null
	if(is_empty())//the network is now empty...
		qdel(src)///... delete it


//add a power machine to the current network
//Warning : this proc DOESN'T check if the machine exists
/datum/ai_network/proc/add_machine(obj/machinery/ai/M)
	if(M.network)// if M already has a network...
		if(M.network == src)
			return
		else
			M.disconnect_from_network()//..remove it
	M.network = src
	nodes[M] = M

/datum/ai_network/proc/find_data_core()
	for(var/obj/machinery/ai/data_core/core in get_all_nodes())
		if(core.can_transfer_ai())
			return core

/datum/ai_network/proc/get_all_nodes(checked_nets = list())
	. = nodes
	var/list/checked_networks = checked_nets
	for(var/datum/ai_network/net in remote_networks)
		if(net in checked_networks)
			continue
		checked_networks += checked_networks
		. += net.get_all_nodes(checked_networks)
		

/datum/ai_network/proc/get_all_ais(checked_nets = list())
	. = ai_list
	var/list/checked_networks = checked_nets
	for(var/datum/ai_network/net in remote_networks)
		if(net in checked_networks)
			continue
		checked_networks += checked_networks
		. += net.get_all_ais(checked_networks)

/datum/ai_network/proc/update_remotes()
	for(var/obj/machinery/ai/networking/N in nodes)
		if(N.partner && N.partner.network && !(N.partner.network in remote_networks))
			remote_networks += N.partner.network


/proc/merge_ainets(datum/ai_network/net1, datum/ai_network/net2)
	if(!net1 || !net2) //if one of the network doesn't exist, return
		return

	if(net1 == net2) //don't merge same networks
		return

	//We assume net1 is larger. If net2 is in fact larger we are just going to make them switch places to reduce on code.
	if(net1.cables.len < net2.cables.len)	//net2 is larger than net1. Let's switch them around
		var/temp = net1
		net1 = net2
		net2 = temp


	//merge net2 into net1
	for(var/obj/structure/ethernet_cable/Cable in net2.cables) //merge cables
		net1.add_cable(Cable)
	
	for(var/obj/machinery/ai/Node in net2.nodes) //merge power machines 
		if(!Node.connect_to_network())
			Node.disconnect_from_network() //if somehow we can't connect the machine to the new network, disconnect it from the old nonetheless

	var/list/merged_remote_networks = list()
	for(var/datum/ai_network/net in net2.remote_networks)
		if(net != net1)
			merged_remote_networks += net

	for(var/datum/ai_network/net in net1.remote_networks)
		if(net == net2)
			net1.remote_networks -= net2

	net1.remote_networks += merged_remote_networks

	net1.ai_list += net2.ai_list //AIs can only be in 1 network at a time

	return net1


//remove the old network and replace it with a new one throughout the network.
/proc/propagate_ai_network(obj/O, datum/ai_network/AN)
	var/list/worklist = list()
	var/list/found_machines = list()
	var/index = 1
	var/obj/P = null

	worklist+=O //start propagating from the passed object

	while(index<=worklist.len) //until we've exhausted all power objects
		P = worklist[index] //get the next power object found
		index++

		if( istype(P, /obj/structure/ethernet_cable))
			var/obj/structure/ethernet_cable/C = P
			if(C.network != AN) //add it to the network, if it isn't already there
				AN.add_cable(C)
			worklist |= C.get_connections() //get adjacents power objects, with or without a network
		else if(P.anchored && istype(P, /obj/machinery/ai))
			var/obj/machinery/ai/M = P
			found_machines |= M //we wait until the network is fully propagates to connect the machines
		else
			continue

	//now that the network is set, connect found machines to it
	for(var/obj/machinery/ai/PM in found_machines)
		if(!PM.connect_to_network()) //couldn't find a node on its turf...
			PM.disconnect_from_network() //... so disconnect if already on a network
	

/proc/ai_list(turf/T, source, d, unmarked = FALSE, cable_only = FALSE)
	. = list()

	for(var/AM in T)
		if(AM == source)
			continue			//we don't want to return source

		if(!cable_only && istype(AM, /obj/machinery/ai))
			var/obj/machinery/ai/P = AM
			if(P.network == 0)
				continue

			if(!unmarked || !P.network)		//if unmarked we only return things with no network
				if(d == 0)
					. += P

		else if(istype(AM, /obj/structure/ethernet_cable))
			var/obj/structure/ethernet_cable/C = AM

			if(!unmarked || !C.network)
				if(C.d1 == d || C.d2 == d)
					. += C
	return .

