/**
* Name: Pedestrian
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/


model Pedestrian

species pedestrian skills:[pedestrian]{
	
	rgb color <- #green;
	point current_target;
	
	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;
		
		
	}
	
}

