/**
* Name: Vehicles
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model Vehicles

import "../utils/variables/vehicle_vars.gaml"
import "./city/Road.gaml"

global {
	bool despawn_vehicles;
	bool drive_random <- DRIVE_RANDOM;
}

species base_vehicle skills: [driving] {
	intersection target;
	int lane_width <- LANE_WIDTH;
	rgb color;
	bool is_stopping <- false;
	float counter <- 5 #sec;
	string fuel_type;

	// Create a graph representing the road network, with road lengths as weights
	graph road_network;

	init {
		map edge_weights <- road as_map (each::each.shape.perimeter);
	}

	reflex select_next_path when: current_path = nil {
		if not (drive_random){
			do compute_path graph: road_network target: one_of(end_nodes);
		} else {
			do compute_path graph: road_network target: one_of(intersection);
		}
		
	}

	reflex commute when: current_path != nil {
		do drive;
	}

	point compute_position {
	// Shifts the position of the vehicle perpendicularly to the road,
	// in order to visualize different lanes
		if (current_road != nil) {
			float dist <- (road(current_road).num_lanes - current_lane - mean(range(num_lanes_occupied - 1)) - 0.5) * lane_width;
			if violating_oneway {
				dist <- -dist;
			}

			point shift_pt <- {cos(heading + 90) * dist, sin(heading + 90) * dist};
			return location + shift_pt;
		} else {
			return {0, 0};
		}

	}

	// testing puposes for dead ends only
	reflex dead_end when: distance_to_goal < 2 and despawn_vehicles = true {
		if (final_target != nil and current_target = final_target and length(intersection(final_target).roads_out) <= 1) {
			do unregister;
			if (spawn_nodes != []) {
				create species(self) with: (location: one_of(spawn_nodes).location);
			}

			do die;
		} }

	reflex stop_at_stop_sign when: current_target != nil and intersection(current_target).traffic_signal_type != nil and intersection(current_target).traffic_signal_type = "stop" {
		if (distance_to_current_target <= 2) {
			ask intersection closest_to (self) {
				do block_roads_to_traffic_sign(roads_affected_by_traffic_signal);
				myself.speed <- 0.0;
			}

		}

	}

	aspect base {
		if (current_road != nil) {
			point pos <- compute_position();
			draw rectangle(vehicle_length, lane_width * num_lanes_occupied) at: pos color: color rotate: heading border: #black;
			draw triangle(lane_width * num_lanes_occupied) at: pos color: #white rotate: heading + 90 border: #black;
		}

	} }

species car parent: base_vehicle {
	rgb color <- #red;

	init {
		num_lanes_occupied <- CAR_LANE_OCCUPIED;
		vehicle_length <- rnd(CAR_MIN_LENGTH, CAR_MAX_LENGTH, 0.1);
		max_speed <- CAR_MAXSPEED;
		max_acceleration <- CAR_ACCELERATION_RATE;
		max_deceleration <- CAR_DECELERATION_RATE;
		speed_coeff <- rnd(MIN_SPEED_COEFF,MAX_SPEED_COEFF, 0.1);
		proba_lane_change_up <- gauss(0.5, 0.5);
		proba_lane_change_up <- gauss(0.5, 0.5);
		proba_use_linked_road <- 0.5;
	}

}

species truck parent: base_vehicle {
	rgb color <- #blue;

	init {
		num_lanes_occupied <- TRUCK_LANE_OCCUPIED;
		vehicle_length <- one_of(TRUCK_POWER_DRIVE_LENGTH, TRUCK_POWER_HEAVY_TRAILER);
		max_speed <- TRUCK_MAXSPEED;
		max_acceleration <- TRUCK_ACCELERATION_RATE;
		max_deceleration <- TRUCK_DECELERATION_RATE;
		proba_lane_change_up <- gauss(0.5, 0.5);
		proba_lane_change_up <- gauss(0.5, 0.5);
		proba_use_linked_road <- 0.5;
	}

}

species bicycle parent: base_vehicle {
	rgb color <- #yellow;

	init {
		num_lanes_occupied <- BICYCLES_LANE_OCCUPIED;
		vehicle_length <- rnd(BICYCLE_MIN_LENGTH, BICYCLE_MAX_LENGTH, 0.1);
		max_speed <- rnd(BICYCLE_MIN_SPEED, BICYCLE_MAX_SPEED, 1.0);
		max_acceleration <- rnd(BICYCLE_MIN_ACCLERATION, BICYCLE_MAX_ACCLERATION, 0.1);
		max_deceleration <- rnd(BICYCLE_MIN_DECELERATION, BICYCLE_MAX_DECELERATION, 0.1);
	}

}