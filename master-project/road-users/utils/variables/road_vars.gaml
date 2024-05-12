/**
* Name: road_vars
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model road_vars

global {
	float TRAFFIC_LIGHT_INTERVAL <- 30#s;
	
	float road_width <- 8.0;
	float lane_width <- 4.0;
	
	float DISTANCE_TO_INTERSECTION <- 8#m;
}

