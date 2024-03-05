/**
* Name: Car
* Based on the internal empty template. 
* Author: Sebastian Toporsch
* Tags: 
*/


model Car

import "BaseVehicle.gaml" as base_vehicle

import "../city/CityAdapter.gaml"


species car skills: [driving] {
	
	rgb color <- rnd_color(255);
	
	float car_size <- 2.0;
	
	init {
		vehicle_length <- 1.9 #m;
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
		draw triangle(car_size) color: color rotate: heading + 90 border: #black;
	}
}


