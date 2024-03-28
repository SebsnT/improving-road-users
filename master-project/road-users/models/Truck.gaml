/**
* Name: Truck
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/
model Truck

import "BaseVehicle.gaml" as base_vehicle

species truck parent: base_vehicle {
	
	rgb color <- #blue;
	
	float lane_width <- 1.0;  
	float num_of_lanes_occupied <- 1.0;

	init {
		// TODO research vehicle parameters
		vehicle_length <- 10.0 #m;
		max_speed <- 50 #km / #h;
		max_acceleration <- 3.5;
	}
}



