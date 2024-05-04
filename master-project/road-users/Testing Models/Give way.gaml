/**
* Name: Giveway
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Giveway

import "../utils/variables/test_vars.gaml"

import "../Simpel Model/Simple_Vehicles.gaml"

import "../Simpel Model/Simple_Agents.gaml"

global {
	geometry shape <- square(size_environment);
	
	int num_cars;
	
	float car_avg_speed -> {mean(car collect (each.speed * 3.6))}; // average speed stats
	
	init {
		
		// intersections
		create intersection with: (location: {x_left_border, 	y_road}, traffic_signal_type:"");
		create intersection with: (location: {x_middle, 		y_road}, traffic_signal_type:"");
		create intersection with: (location: {x_right_border, 	y_road}, traffic_signal_type:"");
		
		create intersection with: (location: {x_middle, 		y_road + 5}, is_traffic_signal: true, traffic_signal_type:"give_way");
		create intersection with: (location: {x_middle, 		y_road + 100},traffic_signal_type:"");
		
		// roads
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[0],intersection[1]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[2]]));
		
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[4],intersection[3]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[3],intersection[1]]));
		
		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road,intersection);
		
		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection where each.is_traffic_signal {
			do initialize;
			do declare_spawn_nodes([intersection[0],intersection[4]]);
			do declare_end_nodes([intersection[2]]);
		}
			
		create car number: num_cars with: (location: one_of(intersection[0],intersection[4]).location);
	}		
}

experiment give_way  type: gui {
	
	action _init_{
		create simulation with:[
			num_cars::15
		];
	}

	output synchronized: true {
		display city type: 2d background: #grey axes: false{

			species road aspect: base;
			species intersection aspect: test;
			
			species car aspect: base;
			
			species footway_node aspect: base;
	    	species footway_edge aspect: base;
		}

		display car_speed_chart type: 2d {
      		chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Cycle" y_label: "Average speed km/h" {
        	data "Car" value: car_avg_speed color: #red;
      		}
    	}
	}
}


