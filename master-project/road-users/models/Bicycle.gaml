/**
* Name: Bicycle
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/


model Bicycle

import "BaseVehicle.gaml" as base_vehicle

species bicycle parent: base_vehicle  {
	
	rgb color <- #yellow;
	
	float lane_width <- 1.0;
	float num_of_lanes_occupied <- 0.5;

	init {
		// TODO research vehicle parameters
		vehicle_length <- 1.75 #m;
		max_speed <- 50 #km / #h;
		max_acceleration <- 3.5;
	}

	
}

