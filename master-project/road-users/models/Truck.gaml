/**
* Name: Truck
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/
model Truck

import "../adapters/CityAdapter.gaml"


species truck skills: [driving] {
	rgb color <- #blue;
	float car_size <- 3.0;
	float lane_width <- 1.0;  

	init {
		// TODO research vehicle parameters
		vehicle_length <- 7.0 #m;
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
		draw rectangle(vehicle_length, lane_width * num_lanes_occupied) 
				color: color rotate: heading border: #black;
			draw triangle(lane_width * num_lanes_occupied) 
				 color: #white rotate: heading + 90 border: #black;
	}

}

/* Insert your model definition here */



