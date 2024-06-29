/**
* Name: CrossIntersection
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model SignalizedCrossIntersectionWithoutSignals

import "../Base Testing Model.gaml"

global {
	string experiment_name <- "signalized_cross_intersection_without_signals";

	init {

	// intersections

	// Middle Intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle}, is_traffic_signal: true, traffic_signal_type: "");
		create intersection with: (location: {x_right_border, y_middle}, traffic_signal_type: "");

		// 	Top and bottom intersection	
		create intersection with: (location: {x_middle, y_top_border}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_bottom_border}, traffic_signal_type: "");

		// Intersections around crossing streets
		create intersection with: (location: {x_middle - 5, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle + 5, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle - 5}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle + 5}, traffic_signal_type: "");

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
		create footway_node with: (location: {x_left_border, y_above_middle}, list_connected_index: [1]);
		create footway_node with: (location: {x_middle - 5, y_above_middle}, list_connected_index: [0, 2, 5, 8]);
		create footway_node with: (location: {x_middle + 5, y_above_middle}, list_connected_index: [1, 3, 6, 9]);
		create footway_node with: (location: {x_right_border, y_above_middle}, list_connected_index: [2]);
		create footway_node with: (location: {x_left_border, y_below_middle}, list_connected_index: [5]);
		create footway_node with: (location: {x_middle - 5, y_below_middle}, list_connected_index: [1, 4, 6, 10]);
		create footway_node with: (location: {x_middle + 5, y_below_middle}, list_connected_index: [2, 5, 7, 11]);
		create footway_node with: (location: {x_right_border, y_below_middle}, list_connected_index: [6]);

		// top nodes
		create footway_node with: (location: {x_middle - 5, y_top_border}, list_connected_index: [1]);
		create footway_node with: (location: {x_middle + 5, y_top_border}, list_connected_index: [2]);

		// bottom nodes
		create footway_node with: (location: {x_middle - 5, y_bottom_border}, list_connected_index: [5]);
		create footway_node with: (location: {x_middle + 5, y_bottom_border}, list_connected_index: [6]);

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);

		// setup environment
		ask intersection {
			do declare_spawn_nodes([intersection[0], intersection[3]]);
			do declare_end_nodes([intersection[2], intersection[4]]);
			do setup_env();
		}

		ask road {
			do setup_roads();
		}

		ask footway_edge {
			do setup_edges();
		}

		create car number: num_cars with: (location: one_of(spawn_nodes).location);
	} }