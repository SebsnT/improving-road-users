/**
* Name: Pedestrian
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/


model Pedestrian

import "./city/Footway.gaml"
import "./city/Building.gaml"

species pedestrian skills:[pedestrian]{
	
	rgb color <- #green;
	
	graph footway_network;
	init{
		footway_network <- as_edge_graph(footway);
		
	}
	
	reflex move {
		if (final_waypoint = nil) {
			// do compute_virtual_path pedestrian_graph: footway_network target: one_of(footway);
		}
		do walk ;
	}	
	
	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;
		
	}
	
		
}



