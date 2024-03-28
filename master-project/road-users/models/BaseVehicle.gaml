/**
* Name: BaseVehicle
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model BaseVehicle
import "../adapters/CityAdapter.gaml"



species base_vehicle skills: [driving] {
	
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

