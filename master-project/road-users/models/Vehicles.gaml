/**
* Name: Vehicles
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Vehicles

import "./city/Road.gaml"
import "../utils/variables/vehicle_vars.gaml"


species base_vehicle skills: [driving] {
	intersection target;
	float lane_width <- 1.0;
	
	// Create a graph representing the road network, with road lengths as weights
	graph road_network;
	init{
		map edge_weights <- road as_map (each::each.shape.perimeter);
		road_network <- as_driving_graph(road, intersection) with_weights edge_weights;
		
		right_side_driving <- RIGHT_SIDE_DRIVING;
		
		min_safety_distance <- MIN_SAFETY_DISTANCE;
		min_security_distance <- MIN_SECURITY_DISTANCE;
		
		proba_respect_priorities <- PROBA_RESPECT_PRIORITIES;
		proba_respect_stops <- PROBA_RESPECT_STOPS;
		
		
	}
    
    
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
	/*
	reflex stop_before_crossing {
		if(current_target != nil and intersection(current_target).is_green = false ){
			write "test";
		}
	}
	*/
	
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
	
	init {
		// TODO research vehicle parameters
		num_lanes_occupied <- BICYCLES_LANE_OCCUPIED;
		vehicle_length <- BICYCLE_LENGTH;
		
		max_speed <- BICYCLE_MAXSPEED;
		max_acceleration <- BICYCLE_ACCELERATION_RATE;
		max_deceleration <- BICYCLE_DECELERATION_RATE;
	}
}

species truck parent: base_vehicle {
	
	rgb color <- #blue;

	init {
		// TODO research vehicle parameters
		num_lanes_occupied <- TRUCK_LANE_OCCUPIED;
		vehicle_length <- TRUCK_LENGTH;
		
		max_speed <- TRUCK_MAXSPEED;
		max_acceleration <- TRUCK_ACCELERATION_RATE;
		max_deceleration <- TRUCK_DECELERATION_RATE;
	}
}

species car parent: base_vehicle{
	
	rgb color <- #red;
	
	init {
		// TODO research vehicle parameters
		num_lanes_occupied <- CAR_LANE_OCCUPIED;
		vehicle_length <- CAR_LENGTH;
		
		max_speed <- CAR_MAXSPEED;
		max_acceleration <- CAR_ACCELERATION_RATE;
		max_deceleration <- CAR_DECELERATION_RATE;
	}

}


