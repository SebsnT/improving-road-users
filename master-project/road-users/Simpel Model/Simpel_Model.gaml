/**
* Name: SimpleModel
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model SimpleModel

import "../models/city/Footway.gaml"
import "../models/Vehicles.gaml"

import "Simple_Road_Agents.gaml"


global {
	
	//the typical step for the advanced driving skill
	float step <- 0.2 #s;
	
	//use only for display purpose
	float lane_width <- 1.0;
	
	//number of cars
	int num_cars;
	int num_trucks;
	int num_bicycles;
	int num_pedestrians;
	
	float proba_block_node_car <- 1.0; 
	
	float size_environment <-1#km;
	
	geometry shape <- square(1000);
	//graph used for the shortest path computation
	graph road_network;
	
	graph pedestrian_network;
	
	
	// constants for road creation
	int left_border <- 50;
	float right_border <- size_environment/2 + 300;
	
	float upper_border <- size_environment/2 - 200;
	float y_middle_road <- size_environment/2;
	float y_lower_road <- size_environment/2 + 200;
	float lower_border <- size_environment/2 + 400;
	
	
	float y_above_middle_road <- size_environment/2 - 5;
	float y_under_middle_road <- size_environment/2 + 5;
	
	float y_above_lower_road <- y_lower_road - 5;
	float y_under_lower_road <- y_lower_road + 5;
	
	float x_left_intersection <- size_environment/2 - 300;
	float x_right_intersection <- size_environment/2;
	
	
	
	

	init {
		
		//----------------------------------------------------------------------
		// Create Intersections
		//----------------------------------------------------------------------
			
		// Middle line
		create intersection with: (location: {left_border, y_middle_road}); 
		create intersection with: (location: {x_left_intersection,y_middle_road }, is_traffic_signal: true);
		create intersection with: (location: {x_right_intersection, y_middle_road }, is_traffic_signal: true);
		create intersection with: (location: {right_border, y_middle_road });
		
		// Upper Horizontal lines
		create intersection with: (location: {x_left_intersection,upper_border});
		create intersection with: (location: {x_right_intersection,upper_border});
		
		// Lower Horizontal lines
		create intersection with: (location: {x_left_intersection,y_lower_road});
		create intersection with: (location: {x_right_intersection,y_lower_road});
		
		// Lowest Horizontal line
		create intersection with: (location: {x_left_intersection,lower_border});
		create intersection with: (location: {x_right_intersection,lower_border});
		
		//----------------------------------------------------------------------
		// Connect Roads
		//----------------------------------------------------------------------
		
		// Connect Middle line
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[0],intersection[1]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[0]]));
		
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[2]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[2],intersection[1]]));
		
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[2],intersection[3]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[3],intersection[2]]));
	
		// Connect upper lines to lower
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[4],intersection[1]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[4]]));
		
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[5],intersection[2]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[2],intersection[5]]));
		
		// Connect lower lines to lower
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[6],intersection[1]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[6]]));
		
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[7],intersection[2]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[2],intersection[7]]));
		
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[6],intersection[7]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[7],intersection[6]]));
		
		
		//Connect Lowest line
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[8],intersection[6]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[6],intersection[8]]));
		
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[9],intersection[7]]));
		create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[7],intersection[9]]));
		
		
		// Connect ends (for torus)
		//create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[4],intersection[8]]));
		//create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[8],intersection[4]]));
		
		//create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[5],intersection[9]]));
		//create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[9],intersection[5]]));
		
		//create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[0],intersection[3]]));
		//create road with:(num_lanes:2, maxspeed: 50#km/#h, shape:line([intersection[3],intersection[0]]));

		//build the graph from the roads and intersections
		road_network <- as_driving_graph(road,intersection);
		
		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection where each.is_traffic_signal {
			do initialize;
			}
			
		
		//----------------------------------------------------------------------
		// Create and Connect Foootways
		//----------------------------------------------------------------------
			
		// Top nodes
		create footway_node with: (location: {x_left_intersection - 5 ,upper_border}, list_connected_index:[1, 6], number:"0");
		create footway_node with: (location: {x_left_intersection + 5 ,upper_border}, list_connected_index:[0, 8], number:"1");
		
		create footway_node with: (location: {size_environment/2 - 5 ,upper_border}, list_connected_index:[3, 10], number:"2");
		create footway_node with: (location: {size_environment/2 + 5 ,upper_border}, list_connected_index:[2, 12], number:"3");
		
		
		// Middle nodes
		
		create footway_node with: (location: {left_border ,y_above_middle_road}, list_connected_index:[5, 6], number:"4");
		create footway_node with: (location: {left_border ,y_under_middle_road}, list_connected_index:[4, 7], number:"5");
		
		create footway_node with: (location: {x_left_intersection - 5 ,y_above_middle_road}, list_connected_index:[0, 4, 7, 8], number:"6");
		create footway_node with: (location: {x_left_intersection - 5 ,y_under_middle_road}, list_connected_index:[5, 6, 9, 16], number:"7");
		
		create footway_node with: (location: {x_left_intersection + 5 ,y_above_middle_road}, list_connected_index:[1, 6, 9, 10], number:"8");
		create footway_node with: (location: {x_left_intersection + 5 ,y_under_middle_road}, list_connected_index:[7, 8, 11, 18 ], number:"9");
		
		create footway_node with: (location: {x_right_intersection - 5 ,y_above_middle_road}, list_connected_index:[2, 8, 11, 12], number:"10");
		create footway_node with: (location: {x_right_intersection - 5 ,y_under_middle_road}, list_connected_index:[9, 10, 13, 20], number:"11");
		
		create footway_node with: (location: {x_right_intersection + 5 ,y_above_middle_road}, list_connected_index:[3, 10, 13, 14], number:"12");
		create footway_node with: (location: {x_right_intersection + 5 ,y_under_middle_road}, list_connected_index:[11, 12, 15, 22], number:"13");
		
		create footway_node with: (location: {right_border ,y_above_middle_road}, list_connected_index:[12, 15], number:"14");
		create footway_node with: (location: {right_border ,y_under_middle_road}, list_connected_index:[13, 14], number:"15");
		
		
		// Lower Nodes
		
		create footway_node with: (location: {x_left_intersection - 5 ,y_above_lower_road}, list_connected_index:[7, 17, 17, 18], number:"16");
		create footway_node with: (location: {x_left_intersection - 5 ,y_under_lower_road}, list_connected_index:[16, 19, 24], number:"17");
		
		create footway_node with: (location: {x_left_intersection + 5 ,y_above_lower_road}, list_connected_index:[9, 16, 19, 20], number:"18");
		create footway_node with: (location: {x_left_intersection + 5 ,y_under_lower_road}, list_connected_index:[17,18, 21, 25], number:"19");
		
		create footway_node with: (location: {x_right_intersection - 5 ,y_above_lower_road}, list_connected_index:[11, 18, 21, 22], number:"20");
		create footway_node with: (location: {x_right_intersection - 5 ,y_under_lower_road}, list_connected_index:[19, 20, 23, 26], number:"21");
		
		create footway_node with: (location: {x_right_intersection + 5 ,y_above_lower_road}, list_connected_index:[13, 20, 23], number:"22");
		create footway_node with: (location: {x_right_intersection + 5 ,y_under_lower_road}, list_connected_index:[21, 22, 27], number:"23");
		
		
		// Lowest nodes
		create footway_node with: (location: {x_left_intersection - 5 ,lower_border}, list_connected_index:[17, 25], number:"24");
		create footway_node with: (location: {x_left_intersection + 5 ,lower_border}, list_connected_index:[19, 24], number:"25");
		
		create footway_node with: (location: {x_right_intersection - 5 ,lower_border}, list_connected_index:[21, 27], number:"26");
		create footway_node with: (location: {x_right_intersection + 5 ,lower_border}, list_connected_index:[23, 26], number:"27");
		
		
		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection where each.is_traffic_signal {
			do initialize;
			}
			
		pedestrian_network <- as_edge_graph(footway_edge);

		create car number: num_cars with: (location: one_of(intersection).location);
		//create truck number: num_trucks;
		//create bicycle number: num_bicycles;
		create pedestrian number: num_pedestrians with: (location: one_of(footway_edge).location);

	}
}





	species pedestrian skills:[moving]{
		
	point target;
	rgb color <- #green;
	int staying_counter;
	
	reflex new_target when: target = nil {
		target <- any_location_in (one_of(footway_node));

	}
	
	reflex move when: target != nil{
	do goto target: target on: pedestrian_network;
	if (location = target) {
	    target <- nil;
		} 
    }

	
	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;
		
	}
	
}




experiment test_city  type: gui {
	
	action _init_{
		create simulation with:[
			num_cars::10,
			//num_trucks::10
			//num_bicycles::100,
			num_pedestrians::10
		];
	}

	output synchronized: true {
		display city type: 2d background: #grey axes: false{

			species road aspect: base;
			species intersection aspect: base;
			species car aspect: base;
			//species truck aspect: base;
			//species bicycle aspect: base;
			species pedestrian aspect: base;
			
			//species footway aspect: base;
			species footway_node aspect: base;
	    	species footway_edge aspect: base;
		}
	}
}
