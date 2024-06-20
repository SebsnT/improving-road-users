/**
* Name: Pedestrian
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/
model Pedestrian

import "./city/Building.gaml"
import "./city/Road.gaml"
import "../utils/variables/pedestrian_vars.gaml"
species pedestrian skills: [moving] {
	rgb color <- #green;
	point target;
	int staying_counter;

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

