/**
* Name: Car
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/


model Car


import "BaseVehicle.gaml" as base_vehicle

species car parent: base_vehicle{
	
	rgb color <- #red;
	 
	int lane_width <- 1;
	float num_of_lanes_occupied <- 1.0;
	
	init {
		// TODO research vehicle parameters
		vehicle_length <- 4.0 #m;
		max_speed <- 50 #km / #h;
		max_acceleration <- 3.5;
	}


	
}


