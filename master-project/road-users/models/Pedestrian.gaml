/**
* Name: Pedestrian
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/
model Pedestrian
import "../utils/variables/pedestrian_vars.gaml"
import "./city/Building.gaml"
import "./city/Road.gaml"

global  {
	int number_of_footway <- 0;
	int number_of_footway_edges <- 0;
	bool show_footway_nodes;
	bool show_footway_edges_numbers;
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

	reflex new_target when: target = nil {
		target <- point(one_of(building));
	}

	graph footway_network;

	init {
		footway_network <- as_edge_graph(footway);
	}

	reflex move when: target != nil {
		do goto target: target on: footway_network;
		if (location = target) {
			target <- nil;
		}

	}

	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;
	}

}

species footway skills: [pedestrian_road] {
	rgb color <- #black;
	rgb label_color <- #orange;
	bool is_occupied <- false;
	bool intersects_traffic_signal_crossing;
	intersection intersects_with_crossing;

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

	reflex block_node when: !intersects_traffic_signal_crossing {
		if (agents_on != []) {
			is_occupied <- true;
			if (intersects_with_crossing != nil) {
				ask intersection closest_to (self) {
					do wait_to_cross();
				}

			}

		} else {
			is_occupied <- false;
			if (intersects_with_crossing != nil) {
				ask intersection closest_to (self) {
					do unblock_road();
				}

			}

		}

	}

	aspect base {
		draw shape color: color;
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
	reflex block_node when: !intersects_traffic_signal_crossing {
		if (agents_on != []) {
			is_occupied <- true;
			if (intersects_with_crossing != nil) {
				ask intersection closest_to (self) {
					do wait_to_cross();
				}

			}

		} else {
			is_occupied <- false;
			if (intersects_with_crossing != nil) {
				ask intersection closest_to (self) {
					if (stop != []) {
						do unblock_road();
					}

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

		if (show_footway_edges_numbers) {
			draw number color: label_color;
		}

	}

}

