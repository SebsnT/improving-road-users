/**
* Name: Simple_Pedestrians
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model Simple_Pedestrians

import "../utils/variables/pedestrian_vars.gaml"
import "./Simple_Road.gaml"

global {
	graph pedestrian_network;
	bool show_footway_nodes;
	bool show_footway_edges;
	int number_of_footway <- 0;
	int number_of_footway_edges <- 0;

	init {
		pedestrian_network <- as_edge_graph(footway_edge);
	}

}

species pedestrian skills: [moving] {
	rgb color <- #green;
	point target;
	int staying_counter;
	bool is_crossing;
	bool is_waiting;
	bool waits_for_green;
	float waiting_time <- rnd(MIN_CROSSING_WAITING_TIME, MAX_CROSSING_WAITING_TIME, 0.1) #s;
	float waiting_counter <- 0 #s;
	float walking_speed <- gauss(4, 1) #km / #h;
	float crossing_speed <- walking_speed * 1.1;

	init {
		speed <- walking_speed;
	}

	reflex new_target when: target = nil {
		target <- any_location_in(one_of(footway_edge));
	}

	// cross road with higher speed
	reflex cross_road when: footway_edge(current_edge) != nil and footway_edge(current_edge).intersects_with_crossing != nil and is_crossing = false {
		intersection intersecting_crossing <- footway_edge(current_edge).intersects_with_crossing;
		if (intersecting_crossing.is_connected_to_traffic_signal) {
			if (intersecting_crossing.connected_to_traffic_signal.is_green) {
				waits_for_green <- true;
			}

		} else {
			is_waiting <- true;
			is_crossing <- true;
			do set_speed_for_crossing();
		}

	}

	reflex wait_to_cross_signalized_crossing when: footway_edge(current_edge) != nil and waits_for_green {
		speed <- 0.0;
		if not (footway_edge(current_edge).intersects_with_crossing.is_green) {
			waits_for_green <- false;
			do set_speed_for_crossing();
		}

	}

	// reset speed once road is_crossed
	reflex reset_speed when: footway_edge(current_edge) != nil and footway_edge(current_edge).intersects_with_crossing = nil and is_crossing = true {
		is_crossing <- false;
		do set_speed_for_walking();
	}

	reflex wait_before_crossing when: is_crossing = true and is_waiting = true {
		speed <- 0.0 #m / #s;
		waiting_counter <- waiting_counter + step;
		if (waiting_counter >= waiting_time #s) {
			waiting_counter <- 0 #s;
			is_waiting <- false;
			speed <- crossing_speed;
		}

	}

	// setters
	action set_speed_for_crossing {
		speed <- crossing_speed;
	}

	action set_speed_for_walking {
		speed <- walking_speed;
	}

	reflex move when: target != nil {
		do wander on: pedestrian_network;
		if (location = target) {
			target <- nil;
		}

	}

	action jaywalk {
	/*
	 * get opposite edge
	 * make target opposite edge
	 * set heading 90 degrees
	 * move to target
	 * set target nil
	 */
	}

	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;
	}

}

species footway_node parent: graph_node edge_species: footway_edge {
	rgb color <- #blue;
	rgb label_color <- #white;
	geometry shape <- circle(1);
	list<int> list_connected_index;
	string number;

	init {
		number <- string(number_of_footway);
		number_of_footway <- number_of_footway + 1;
	}

	bool related_to (footway_node other) {
		if (list_connected_index contains (footway_node index_of other)) {
			return true;
		}

		return false;
	}

	aspect base {
		if (show_footway_nodes) {
			draw shape color: #blue;
		}

		if (show_footway_nodes) {
			draw number color: label_color;
		}

	}

}

species footway_edge skills: [pedestrian_road] parent: base_edge {
	rgb color <- #black;
	rgb label_color <- #orange;
	rgb occupied_color <- #red;
	bool is_occupied <- false;
	bool intersects_traffic_signal_crossing;
	intersection intersects_with_crossing;
	string number;

	init {
		number <- string(number_of_footway_edges);
		number_of_footway_edges <- number_of_footway_edges + 1;
	}

	action set_intersects_with_crossing {
		if (self overlaps (road closest_to (self))) {
			self.intersects_with_crossing <- intersection closest_to self;
			if ((intersection closest_to self).is_connected_to_traffic_signal) {
				intersects_traffic_signal_crossing <- true;
			}

		}

	}

	action setup_edges {
		do set_intersects_with_crossing();
	}

	reflex update_agents_on {
		agents_on <- pedestrian where (each.current_edge = self);
	}

	// TODO handle car driving left or right at intersection
	reflex block_node when: !intersects_traffic_signal_crossing{
		if (agents_on != []) {
			is_occupied <- true;
			if (intersects_with_crossing != nil) {
				ask intersection {
					do wait_to_cross();
				}

			}

		} else {
			is_occupied <- false;
			if (intersects_with_crossing != nil) {
				ask intersection {
					//do unblock_road();
				}

			}

		}

	}

	aspect base {
		if (is_occupied) {
			draw shape color: occupied_color;
		} else {
			draw shape color: color;
		}

		if (show_footway_edges) {
			draw number color: label_color;
		}

	}

}
	


