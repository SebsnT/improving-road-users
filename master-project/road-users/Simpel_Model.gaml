/**
* Name: Mix Drive City
* Description: Vehicles driving in a road graph
* Author: Duc Pham and Patrick Taillandier
* Tags: gis, shapefile, graph, agent_movement, skill, transport
*/

model simple_intersection

import "./models/city/Road.gaml"


global {
	float size_environment <- 1#km;
	
	geometry shape <- envelope(size_environment);
	
	//the typical step for the advanced driving skill
	float step <- 0.5 #s;
	
	//use only for display purpose
	float lane_width <- 2.0;
	
	//number of cars
	int num_cars <- 300;
	
	float proba_block_node_car <- 1.0; 
	
	//graph used for the shortest path computation
	graph road_network;
	
	init {
		// Middle line
		create intersection with: (location: {0,size_environment/2}); 
		create intersection with: (location: {size_environment/2 - 300,size_environment / 2 }, is_traffic_signal: true);
		create intersection with: (location: {size_environment/2, size_environment / 2 }, is_traffic_signal: true);
		create intersection with: (location: {size_environment/2 + 300, size_environment / 2 });
		
		// Upper Horizontal lines
		create intersection with: (location: {size_environment/2 - 300,size_environment/2 - 200});
		create intersection with: (location: {size_environment/2,size_environment/2 - 200});
		
		// Lower Horizontal lines
		create intersection with: (location: {size_environment/2 - 300,size_environment/2 + 200});
		create intersection with: (location: {size_environment/2,size_environment/2 + 200});
		
		// Lowest Horizontal line
		create intersection with: (location: {size_environment/2 - 300,size_environment/2 + 500});
		create intersection with: (location: {size_environment/2,size_environment/2 + 500});
		
		// Connect Middle line
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[0],intersection[1]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[2]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[2],intersection[3]]));


	
		// Connect upper lines to lower
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[4],intersection[1]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[5],intersection[2]]));
		
		// Connect lower lines to lower
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[6],intersection[1]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[7],intersection[2]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[6],intersection[7]]));
		
		//Connect Lowest line
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[8],intersection[6]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[9],intersection[7]]));

		//build the graph from the roads and intersections
		road_network <- as_driving_graph(road,intersection);
		
		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection where each.is_traffic_signal {
			do initialize;
		}
		
	}
	
	reflex add_car {
		//create car with: (location: intersection[0].location, target: intersection[3]);
		create car with: (location: intersection[0].location, target: intersection[1]);
	}
}







species car skills: [driving] {
	rgb color <- rnd_color(255);
	intersection target;
	
	init {
		vehicle_length <- 3.8 #m;
		//car occupies 2 lanes
		num_lanes_occupied <-1;
		max_speed <-150 #km / #h;
				
		proba_block_node <- proba_block_node_car;
		proba_respect_priorities <- 1.0;
		proba_respect_stops <- [1.0];
		proba_use_linked_road <- 0.0;

		lane_change_limit <- 2;
		linked_lane_limit <- 0;
		
	}
	//choose a random target and compute the path to it
	reflex choose_path when: final_target = nil {
		do compute_path graph: road_network target: target; 
	}
	reflex move when: final_target != nil {
		do drive;
		//if arrived at target, kill it and create a new car
		if (final_target = nil) {
			do unregister;
			do die;
		}
	}
	
	// Just use for display purpose
	// Shifts the position of the vehicle perpendicularly to the road,
	// in order to visualize different lanes
	point compute_position {
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
	
	
	aspect default {
		if (current_road != nil) {
			point pos <- compute_position();
				draw rectangle(vehicle_length*4, lane_width * num_lanes_occupied*4) 
				at: pos color: color rotate: heading border: #black;
			draw triangle(lane_width * num_lanes_occupied) 
				at: pos color: #white rotate: heading + 90 ;
		}
	}
}


experiment simple_intersection  type: gui {

	output synchronized: true {
		display city type: 2d background: #black axes: false{
			species road aspect: base;
			species intersection aspect: base;
			species car ;
		}
	}
}
