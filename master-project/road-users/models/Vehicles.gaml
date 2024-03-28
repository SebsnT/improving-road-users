/**
* Name: BaseVehicle
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Vehicles

import "./city/Road.gaml"



species base_vehicle skills: [driving] {
	
	graph road_network;
	init{
		road_network <- as_driving_graph(road, intersection);
	}
	
	rgb color;
	
	int lane_width;
	float num_of_lanes_occupied <- 1.0;
    
    
    reflex select_next_path when: current_path = nil {
		// A path that forms a cycle
		do compute_path graph: road_network target: one_of(intersection);
	}
	
	reflex commute when: current_path != nil {
		do drive;
	}
	
	aspect base {
		draw rectangle(vehicle_length, lane_width * num_of_lanes_occupied) 
				color: color rotate: heading border: #black;
			draw triangle(lane_width * num_lanes_occupied) 
				 color: #white rotate: heading + 90 border: #black;
	}
}

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


