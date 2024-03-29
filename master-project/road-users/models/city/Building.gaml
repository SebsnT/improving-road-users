/**
* Name: Building
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Building

species building {
	rgb color <- #black;
	string type;
	aspect base { 
		draw shape color: color; 
	}
}

