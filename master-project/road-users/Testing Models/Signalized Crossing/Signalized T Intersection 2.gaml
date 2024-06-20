/**
* Name: TIntersection
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/

model TIntersection

import "../../utils/variables/global_vars_testing.gaml"

import "../../Simple_Model/Simple_Vehicles.gaml"

import "../../Simple_Model/Simple_Pedestrians.gaml"

global {
	geometry shape <- square(size_environment);
	
	int num_cars;
	int num_pedestrians;

	float car_avg_speed -> {mean(car collect (each.speed * 3.6))}; // average speed stats
	float pedestrian_avg_speed -> {mean(pedestrian collect (each.speed * 3.6))}; // average speed stats
	
	init {
		
		// intersections
		
		// Middle Intersections
		create intersection with: (location: {x_left_border, 	y_middle}, traffic_signal_type:"");
		create intersection with: (location: {x_middle, 	 	y_middle}, is_traffic_signal: true, traffic_signal_type:"traffic_signals");
		create intersection with: (location: {x_right_border,	y_middle}, traffic_signal_type:"");
		
		// 	Top and bottom intersection	
		create intersection with: (location: {x_middle, 		y_top_border}, traffic_signal_type:"");
		
		// Intersections around crossing streets
		create intersection with: (location: {x_middle - 5, 	y_middle}, traffic_signal_type:"crossing");
		create intersection with: (location: {x_middle + 5, 	y_middle}, traffic_signal_type:"crossing");
		
		create intersection with: (location: {x_middle, 		y_middle - 5}, traffic_signal_type:"crossing");
		
		// roads
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[0],intersection[4]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[4],intersection[0]]));
		
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[4],intersection[1]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[4]]));
		
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[5]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[5],intersection[1]]));
		
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[5],intersection[2]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[2],intersection[5]]));
		
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[1],intersection[6]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[6],intersection[1]]));
		
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[6],intersection[3]]));
		create road with:(num_lanes:1, maxspeed: 50#km/#h, shape:line([intersection[3],intersection[6]]));
		
		
		// footways
		create footway_node with: (location: {x_left_border,	y_above_middle}, list_connected_index:[1]);
		create footway_node with: (location: {x_middle - 5,		y_above_middle}, list_connected_index:[0,2,5,8]);
		create footway_node with: (location: {x_middle + 5,		y_above_middle}, list_connected_index:[1,3,6,9]);
		create footway_node with: (location: {x_right_border,	y_above_middle}, list_connected_index:[2]);
		
		
		create footway_node with: (location: {x_left_border,	y_below_middle}, list_connected_index:[5]);
		create footway_node with: (location: {x_middle - 5,		y_below_middle}, list_connected_index:[1,4,6,10]);
		create footway_node with: (location: {x_middle + 5,		y_below_middle}, list_connected_index:[2,5,7,11]);
		create footway_node with: (location: {x_right_border,	y_below_middle}, list_connected_index:[6]);
		
		// bottom nodes
		create footway_node with: (location: {x_middle - 5,		y_top_border}, list_connected_index:[5]);
		create footway_node with: (location: {x_middle + 5,		y_top_border}, list_connected_index:[6]);
		
		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road,intersection);
		
		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection{
			do declare_spawn_nodes([intersection[0]]);
			do declare_end_nodes([intersection[2], intersection[3]]);
			do setup_env();
		}
			
		create car number: num_cars with: (location: one_of(spawn_nodes).location);
		create pedestrian number: num_pedestrians with: (location: one_of(footway_edge[0],footway_edge[1],footway_edge[3],footway_edge[4]).location);
	}		
}

experiment signalized_t_intersection  type: gui {
	
	action _init_{
		create simulation with:[
			num_cars::10
			//,num_pedestrians::10
		];
	}

	output synchronized: true {
		display city type: 2d background: #grey axes: false{

			species road aspect: base;
			species intersection aspect: simple;
			
			species car aspect: base;
			species pedestrian aspect: base;
			
			species footway_node aspect: base;
	    	species footway_edge aspect: base;
		}
		/* 
		display car_speed_chart type: 2d {
      		chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Seconds" y_label: "Average speed km/h" {
        	data "Car" value: car_avg_speed color: #red;
        	data "Pedestrian" value: pedestrian_avg_speed color: #green;
      		}
    	}
		*/
	}
}