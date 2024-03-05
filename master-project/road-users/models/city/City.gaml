/**
* Name: Road
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Road

global
{
}

/* Insert your model definition here */

species road skills: [road_skill] {
	rgb color <- #white;
	
	aspect base {
		draw shape color: color end_arrow: 1;
	}
}

species intersection skills: [intersection_skill];


