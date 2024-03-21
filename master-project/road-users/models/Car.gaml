/**
* Name: Car
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/


model Car

import "../adapters/CityAdapter.gaml"


species car skills: [driving]{
	
	rgb color <- #red;
	
	float car_size <- 4.0;
	
	float lane_width <- 1.0;  
	
	
	init {
		// TODO research vehicle parameters
		vehicle_length <- 4.0 #m;
		max_speed <- 100 #km / #h;
		max_acceleration <- 3.5;
	}

	reflex select_next_path when: current_path = nil {
		// A path that forms a cycle
		do compute_path graph: road_network target: one_of(intersection);
	}
	
	reflex commute when: current_path != nil {
		do drive;
	}
	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;
	}
}


