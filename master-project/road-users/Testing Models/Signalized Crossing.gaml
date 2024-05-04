/**
* Name: SignalizedCrossing
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/

model SignalizedCrossing

import "../utils/variables/test_vars.gaml"

import "../Simpel Model/Simple_Vehicles.gaml"

import "../Simpel Model/Simple_Agents.gaml"

global {
	geometry shape <- square(size_environment);
	
	int num_cars;
	int num_pedestrians;

	float car_avg_speed -> {mean(car collect (each.speed * 3.6))}; // average speed stats
	float pedestrian_avg_speed -> {mean(pedestrian collect (each.speed * 3.6))}; // average speed stats
	
	
	init {
		
		// intersections
		create intersection with: (location: {x_left_border, 	y_road}, traffic_signal_type:"");
		create intersection with: (location: {x_middle, 	y_road}, is_traffic_signal: true, traffic_signal_type:"traffic_signals");
		create intersection with: (location: {x_right_border, 	y_road}, traffic_signal_type:"");
		
		// roads
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[0],intersection[1]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[2]]));
		
		// footways
		create footway_node with: (location: {x_left_border,	y_above_road}, list_connected_index:[1], number:"0");
		create footway_node with: (location: {x_middle,	y_above_road}, list_connected_index:[0,2,4], number:"1");
		create footway_node with: (location: {x_right_border,	y_above_road}, list_connected_index:[1], number:"2");
		
		
		create footway_node with: (location: {x_left_border,	y_below_road}, list_connected_index:[4], number:"3");
		create footway_node with: (location: {x_middle,	y_below_road}, list_connected_index:[1,3,5], number:"4");
		create footway_node with: (location: {x_right_border,	y_below_road}, list_connected_index:[4], number:"5");
		
		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road,intersection);
		
		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection where each.is_traffic_signal {
			do initialize;
			do declare_spawn_nodes([intersection[0]]);
			do declare_end_nodes([intersection[2]]);
		}
			
		create car number: num_cars with: (location: intersection[0].location);
		create pedestrian number: num_pedestrians with: (location: one_of(footway_edge[0],footway_edge[1],footway_edge[3],footway_edge[4]).location);
	}		
}

experiment cross_road  type: gui {
	
	action _init_{
		create simulation with:[
			num_cars::10
			,num_pedestrians::10
		];
	}

	output synchronized: true {
		display city type: 2d background: #grey axes: false{

			species road aspect: base;
			species intersection aspect: test;
			
			species car aspect: base;
			species pedestrian aspect: base;
			
			species footway_node aspect: base;
	    	species footway_edge aspect: base;
		}
		/* 
		display car_speed_chart type: 2d {
      		chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Cycle" y_label: "Average speed km/h" {
        	data "Car" value: car_avg_speed color: #red;
        	data "Pedestrian" value: pedestrian_avg_speed color: #green;
      		}
    	}
		*/
	}
}