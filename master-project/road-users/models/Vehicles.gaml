/**
* Name: Vehicles
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Vehicles

import "./city/Road.gaml"


species base_vehicle skills: [driving] {
	intersection target;
	
	// Create a graph representing the road network, with road lengths as weights
	graph road_network;
	init{
		map edge_weights <- road as_map (each::each.shape.perimeter);
		road_network <- as_driving_graph(road, intersection) with_weights edge_weights;
		
		proba_respect_priorities <- 1.0;
		proba_respect_stops <- [1.0];
	}
	
	rgb color;
	
	int lane_width;
	float num_of_lanes_occupied <- 1.0;
    
    
    reflex select_next_path when: current_path = nil {
		do compute_path graph: road_network target: one_of(intersection);
	}
	
	reflex commute when: current_path != nil {
		do drive;
	}
	
	point compute_position {
		// Shifts the position of the vehicle perpendicularly to the road,
		// in order to visualize different lanes
		if (current_road != nil) {
			float dist <- (road(current_road).num_lanes - current_lane -
				mean(range(num_lanes_occupied - 1)) - 0.5) * lane_width;
			if violating_oneway {
				dist <- -dist;
			}
		 	point shift_pt <- {cos(heading + 90) * dist, sin(heading + 90) * dist};	
		
			return location + shift_pt;
		} else {
			return {0, 0};
		}
	}
	
	//TODO calculate critical gap
	
	//TODO react to pedestrian -> reflex 
	
	//TODO speeding
	
	
	aspect base {
		if (current_road != nil) {
			point pos <- compute_position();
				
			draw rectangle(vehicle_length, lane_width * num_lanes_occupied) 
				at: pos color: color rotate: heading border: #black;
			draw triangle(lane_width * num_lanes_occupied) 
				at: pos color: #white rotate: heading + 90 border: #black;
		}
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


