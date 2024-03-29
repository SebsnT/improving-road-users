/**
* Name: Footway
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Footway

species footway skills: [pedestrian_road]{
	rgb color <- #red;
	
	aspect base {
		draw shape color: color;
	}
}

