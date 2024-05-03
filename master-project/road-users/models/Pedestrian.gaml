/**
* Name: Pedestrian
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/


model Pedestrian

import "./city/Footway.gaml"
import "./city/Building.gaml"

species pedestrian skills:[moving]{
	
	rgb color <- #green;
	point target;
	int staying_counter;
	
	reflex new_target when: target = nil {
	target <- point(one_of(building));
		
	}
	
	
	graph footway_network;
	init{
		footway_network <- as_edge_graph(footway);
		
	}
	
	reflex move when: target != nil{
		do goto target: target on: footway_network;
		if (location = target) {
			target <- nil;
		} 
	}	
	
	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;
		
	}
		
}

