/**
* Name: RoadAgents
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model SimplePedestrians

import "../utils/variables/pedestrian_vars.gaml"
import "./Simple_Footways.gaml"


global {
	graph pedestrian_network;
	
	init {
		pedestrian_network <- as_edge_graph(footway_edge);
	}

}
	
species pedestrian skills:[moving]{
	rgb color <- #green;
	
	point target;
	int staying_counter;
	
	init {
		speed <- WALKING_SPEED;
	}
	
	
	reflex new_target when: target = nil {
	target <- any_location_in (one_of(footway_edge));	
	}
	
	action set_speed_for_crossing {
	 	speed <- CROSSING_SPEED;
	}
	
	action set_speed_for_walking {
	 	speed <- WALKING_SPEED;
	}
	
	
	reflex move when: target != nil{
		do goto target: target on: pedestrian_network;
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
	
	
	//TODO calculate critical gap
	
	
	 
	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;	
	}
}
	


