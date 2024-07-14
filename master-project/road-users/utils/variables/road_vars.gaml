/**
* Name: road_vars
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model road_vars

global {

	// road
	float TRAFFIC_LIGHT_INTERVAL <- 30 #s;
	float TIME_TO_UNBLOCK <- 3 #s;
	int NUM_LANES <- 2;
	float road_width <- 8.0;
	float lane_width <- 4.0;
}

