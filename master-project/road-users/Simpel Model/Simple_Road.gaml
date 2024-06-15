/**
* Name: Simpel_Road
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model Simpel_Road

import "../utils/variables/road_vars.gaml"
import "./Simple_Vehicles.gaml"

global {
	list<intersection> end_nodes;
	list<intersection> spawn_nodes;

	// bool to show number of objects
	bool show_road_numbers;
	bool show_intersection_numbers;
	bool measure_density;

	// bool to keep track of number of objects
	int number_of_road <- 0;
	int number_of_intersection <- 0;
}

species road skills: [road_skill] {
	rgb color <- #white;
	rgb label_color <- #red;
	string oneway;
	string number;
	bool leads_to_prioriy_node <- false;
	bool leads_from_prioriy_node <- false;
	float traffic_density;
	float all_segments_length;

	init {
		number <- string(number_of_road);
		number_of_road <- number_of_road + 1;
	}

	action calculate_road_occupied (list vehicles) {
		float occupied;
		loop v over: vehicles {
			occupied <- occupied + base_vehicle(v).vehicle_length;
		}

		traffic_density <- occupied / all_segments_length;
	}

	action set_leads_from_prioriy_node {
		if (intersection(target_node).roads_from_street_signs contains self) {
			leads_to_prioriy_node <- true;
		}

	}

	action set_leads_to_prioriy_node {
		if (intersection(target_node).roads_from_priority_node contains self) {
			leads_from_prioriy_node <- true;
		}

	}

	action set_all_segments_length {
		loop s over: to_list(segment_lengths) {
			all_segments_length <- all_segments_length + float(s);
		}

	}

	action setup_roads {
		do set_all_segments_length();
		do set_leads_to_prioriy_node();
		do set_leads_from_prioriy_node();
	}

	reflex calculate_traffic_density when: all_agents != nil and all_agents != [] and measure_density = true {
		do calculate_road_occupied(all_agents);
	}

	reflex reset_traffic_density when: all_agents = [] {
		traffic_density <- 0.0;
	}

	aspect base {
		draw shape color: color end_arrow: 1;
		if (show_road_numbers) {
			draw number color: label_color font: font("Helvetica", 15, #plain) at: location + {rnd(0), rnd(3)};
		}

	}

}

species intersection skills: [intersection_skill] {
	rgb color;
	rgb label_color <- #black;
	rgb traffic_light_color;
	rgb opposite_color;
	font label_font <- font("Helvetica", 20, #plain);
	string number;
	string traffic_signal_type;
	bool is_traffic_signal;
	bool is_connected_to_traffic_signal <- false;
	bool intersection_blocked;
	bool is_green;
	float time_to_change <- TRAFFIC_LIGHT_INTERVAL;
	float time_to_unblock <- TIME_TO_UNBLOCK;
	float counter <- rnd(time_to_change);
	float blocked_counter <- 0.0;
	list<road> ways1;
	list<road> ways2;
	list<road> roads_to_and_from_street_signs;
	list<road> roads_to_street_signs;
	list<road> roads_from_street_signs;
	list<road> roads_to_priority_node;
	list<road> roads_from_priority_node;
	list<road> roads_affected_by_traffic_signal;
	list<intersection> connected_nodes;
	list<intersection> connected_street_signs;
	list<intersection> connected_crossings;
	list<intersection> priority_nodes;
	intersection connected_to_traffic_signal;

	init {
		number <- string(number_of_intersection);
		number_of_intersection <- number_of_intersection + 1;
	}

	action initialize_traffic_signals {
		if (traffic_signal_type = "traffic_signals") {
			do compute_crossing;
			stop << [];
			if (flip(0.5)) {
				do to_green;
			} else {
				do to_red;
			}

			if (connected_crossings != []) {
			// do initialize_crossings_connected_to_traffic_signals();
			}

		}

	}

	action initialize_crossings_connected_to_traffic_signals {
		int c <- 0;
		loop i over: connected_crossings {
			do set_crossing_ways(i);
			if (c mod 2 = 0) {
				i.stop << i.roads_out;
				i.is_green <- true;
				i.traffic_light_color <- #green;
				i.opposite_color <- #red;
				i.counter <- counter;
			} else if (c mod 2 = 1) {
				i.stop << i.roads_in;
				i.is_green <- false;
				i.traffic_light_color <- #red;
				i.opposite_color <- #green;
				i.counter <- counter;
			}

			c <- c + 1;
		}

	}

	action set_crossing_ways (intersection crossing) {
	// if green
		crossing.ways2 <- list<road>(crossing.roads_out);
	}

	// Actions and reflexes related to crossing the road
	action wait_to_cross {
		stop <- stop + roads_in;
		intersection_blocked <- true;
	}

	action block_roads_to_traffic_sign (list<road> roads) {
		if (stop = []) {
			stop <- stop + roads;
			intersection_blocked <- true;
		}

	}

	action unblock_road {
		stop <- [];
		intersection_blocked <- false;
		blocked_counter <- 0.0;
	}

	reflex wait_to_unblock when: intersection_blocked = true {
		blocked_counter <- blocked_counter + step;
		if (blocked_counter >= time_to_unblock) {
			do unblock_road();
		}

	}

	// Actions related to setting up the environment

	// creates points used for reference of stopping before intersection
	action set_connected_intersections {

	// loop over all roads
		loop r over: roads_in + roads_out {
			intersection source_node <- intersection(road(r).source_node);
			intersection target_node <- intersection(road(r).target_node);
			if (!(connected_nodes contains source_node) and source_node != self) {
				connected_nodes <- connected_nodes + source_node;
				source_node.connected_to_traffic_signal <- self;
				source_node.is_connected_to_traffic_signal <- true;
			}

			if (!(connected_nodes contains target_node) and target_node != self) {
				connected_nodes <- connected_nodes + target_node;
				target_node.connected_to_traffic_signal <- self;
				target_node.is_connected_to_traffic_signal <- true;
			}

		}

	}

	// sets all intersection that are connected to a street sign
	action set_connected_street_signs {
		loop i over: connected_nodes {
			string type_of_intersection <- i.traffic_signal_type;
			if (type_of_intersection = "give_way" or type_of_intersection = "stop") {
				connected_street_signs <- connected_street_signs + i;
			}

		}

	}

	// sets all roads that are coming from or going to a street sign
	action set_connected_street_signs_roads {
		loop i over: connected_street_signs {
			loop j over: (i.roads_in + i.roads_out) {
				if not (roads_to_and_from_street_signs contains road(j)) and (road(j).target_node = self or road(j).source_node = self) {
					roads_to_and_from_street_signs <- roads_to_and_from_street_signs + road(j);
				}

			}

		}

		do set_roads_to_street_signs();
		do set_roads_from_street_signs();
	}

	action set_roads_to_street_signs {
		loop i over: roads_to_and_from_street_signs {
			if (intersection(i.source_node) = self) {
				roads_to_street_signs <- roads_to_street_signs + i;
			}

		}

	}

	action set_roads_from_street_signs {
		loop i over: roads_to_and_from_street_signs {
			if (intersection(i.target_node) = self) {
				roads_from_street_signs <- roads_from_street_signs + i;
			}

		}

	}

	// Roads that have priority over other roads
	action set_priority_roads {
		if (connected_street_signs != [] and traffic_signal_type != "stop" and traffic_signal_type != "give_way" and traffic_signal_type != "crossing" and traffic_signal_type !=
		"traffic_signals") {
			loop r over: roads_in + roads_out {
				if not (roads_to_street_signs contains road(r)) {
					priority_roads <- priority_roads + road(r);
				}

			}

		}

	}

	// Intersections that has priority rodas
	action set_priority_nodes {
		loop i over: connected_nodes {
			if (i.priority_roads != []) {
				priority_nodes <- priority_nodes + i;
			}

		}

		do set_roads_to_priority_node();
		do set_roads_from_priority_node();
	}

	// set roads leading to nodes that have priority roads
	action set_roads_to_priority_node {
		loop i over: priority_nodes {
			loop j over: i.roads_in {
				if (road(j).source_node = self) {
					roads_to_priority_node <- roads_to_priority_node + road(j);
				}

			}

		}

	}

	// set roads leading away from nodes that have priority roads
	action set_roads_from_priority_node {
		loop i over: priority_nodes {
			loop j over: i.roads_out {
				if (road(j).target_node = self) {
					roads_from_priority_node <- roads_from_priority_node + road(j);
				}

			}

		}

	}

	// Crossings related to intersections 
	action set_traffic_signal_connected_crossings {
		loop i over: connected_nodes {
			if (i.traffic_signal_type = "crossing" and !(connected_crossings contains i)) {
				connected_crossings <- connected_crossings + i;
			}

		}

	}

	action set_road_affected_by_traffic_signal {
		loop i over: roads_in {
			if !(roads_from_priority_node contains i) {
				roads_affected_by_traffic_signal <- roads_affected_by_traffic_signal + road(i);
			}

		}

	}

	// Setting up the environemnt for interactions
	action setup_env {
		do set_connected_intersections();
		do set_connected_street_signs();
		do set_connected_street_signs_roads();
		do set_priority_nodes();
		do set_priority_roads();
		do set_traffic_signal_connected_crossings();
		do set_road_affected_by_traffic_signal();
		do initialize_traffic_signals();
	}

	// Declare where vehicles spawn and despawn
	action declare_end_nodes (list<intersection> nodes) {
		end_nodes <- nodes;
	}

	action declare_spawn_nodes (list<intersection> nodes) {
		spawn_nodes <- nodes;
	}

	action compute_crossing {
		if (length(roads_in) >= 2) {
			road rd0 <- road(roads_in[0]);
			list<point> pts <- rd0.shape.points;
			float ref_angle <- last(pts) direction_to rd0.location;
			loop rd over: roads_in {
				list<point> pts2 <- road(rd).shape.points;
				float angle_dest <- last(pts2) direction_to rd.location;
				float ang <- abs(angle_dest - ref_angle);
				if (ang > 45 and ang < 135) or (ang > 225 and ang < 315) {
					ways2 << road(rd);
				}

			}

		}

		loop rd over: roads_in {
			if not (rd in ways2) {
				ways1 << road(rd);
			}

		}

	}

	// Traffic lights
	action to_green {
		stop[0] <- ways2;
		traffic_light_color <- #green;
		opposite_color <- #red;
		is_green <- true;
	}

	action to_red {
		stop[0] <- ways1;
		traffic_light_color <- #red;
		opposite_color <- #green;
		is_green <- false;
	}

	reflex dynamic_node when: traffic_signal_type = "traffic_signals"
	//or (traffic_signal_type = "crossing" and is_connected_to_traffic_signal) 
	{
		counter <- counter + step;
		if (counter >= time_to_change) {
			counter <- 0.0;
			stop[0] <- empty(stop[0]) ? roads_in : [];
			if is_green {
				do to_red;
			} else {
				do to_green;
			}

		}

	}

	// Aspects
	aspect base {
		if (is_traffic_signal) {
			draw circle(1) color: traffic_light_color;
		} else {
			draw circle(1) color: color;
		}

		switch traffic_signal_type {
			match "crossing" {
				draw circle(1) color: #black;
			}

			match "give_way" {
				draw triangle(3) color: #red;
			}

			match "stop" {
				draw hexagon(3) color: #red;
			}

			match "bus_stop" {
				draw circle(1) color: #white;
			}

			match "" {
				draw circle(1) color: #white;
			}

		}

	}

	aspect simple {
		if (is_traffic_signal and traffic_signal_type = "traffic_signals") {

		// Show numbers on the intersection
			if (show_intersection_numbers) {
				draw number color: label_color font: label_font;
			}

		} else {
			draw circle(1) color: color;
			if (show_intersection_numbers) {
				draw number color: label_color font: label_font;
			}

		}

		switch traffic_signal_type {
			match "crossing" {
				if (is_green and is_connected_to_traffic_signal) {
					draw circle(1) color: #green;
				} else if (is_connected_to_traffic_signal) {
					draw circle(1) color: #black;
				} else {
					draw circle(1) color: #black;
				}

			}

			match "traffic_signals" {
			// left
				draw circle(1) color: traffic_light_color at: {location.x - 8, location.y + 3};

				//right
				draw circle(1) color: traffic_light_color at: {location.x + 8, location.y - 3};

				// bottom
				draw circle(1) color: opposite_color at: {location.x + 3, location.y + 8};

				// top
				draw circle(1) color: opposite_color at: {location.x - 3, location.y - 8};
			}

			match "give_way" {
				draw triangle(3) color: #red;
			}

			match "stop" {
				draw hexagon(3) color: #red;
			}

			match "bus_stop" {
				draw circle(1) color: #white;
			}

			match "" {
				draw circle(1) color: #white;
			}

		}

	}

}




