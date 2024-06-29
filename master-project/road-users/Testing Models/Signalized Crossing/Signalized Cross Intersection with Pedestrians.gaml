/**
* Name: CrossIntersection
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model SignalizedCrossIntersectionWithPedestrians

import "../../utils/variables/global_vars_testing.gaml"
import "../../Simple_Model/Simple_Vehicles.gaml"
import "../../Simple_Model/Simple_Pedestrians.gaml"
import "../Base Testing Model.gaml"

global {
	string experiment_name <- "use_crosswalk";
	int num_pedestrians <- 20;

	init {
		// Middle Intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle}, is_traffic_signal: true, traffic_signal_type: "traffic_signals");
		create intersection with: (location: {x_right_border, y_middle}, traffic_signal_type: "");

		// 	Top and bottom intersection	
		create intersection with: (location: {x_middle, y_top_border}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_bottom_border}, traffic_signal_type: "");

		// Intersections around crossing streets
		create intersection with: (location: {x_middle - 5, y_middle}, traffic_signal_type: "crossing");
		create intersection with: (location: {x_middle + 5, y_middle}, traffic_signal_type: "crossing");
		create intersection with: (location: {x_middle, y_middle - 5}, traffic_signal_type: "crossing");
		create intersection with: (location: {x_middle, y_middle + 5}, traffic_signal_type: "crossing");

		// roads
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[5]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[5]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[6]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[7]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[8]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[6]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[3], intersection[7]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[4], intersection[8]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[5], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[6], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[6], intersection[2]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[7], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[8], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[8], intersection[4]]));

		// footways
		create footway_node with: (location: {x_middle - 5, y_above_middle}, list_connected_index: [1,2]);
		create footway_node with: (location: {x_middle + 5, y_above_middle}, list_connected_index: [0,3]);
		create footway_node with: (location: {x_middle - 5, y_below_middle}, list_connected_index: [0,3]);
		create footway_node with: (location: {x_middle + 5, y_below_middle}, list_connected_index: [1,2]);



		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);

		// setup environment
		ask intersection {
			do declare_spawn_nodes([intersection[0], intersection[3]]);
			do declare_end_nodes([intersection[2], intersection[4]]);
			do setup_env();
		}
		
		ask footway_edge {
			do setup_edges();
		}

		create car number: num_cars with: (location: one_of(spawn_nodes).location);
		create pedestrian number: num_pedestrians with: (location: one_of(footway_edge[0],footway_edge[1],footway_edge[2],footway_edge[3]).location);
	} }