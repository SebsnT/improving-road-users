/**
* Name: OneStreetIntersection
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model SignalizedOneStreetWithoutSignals

import "../Base Testing Model.gaml"

global {
	string folder_name <- "signalized";
	string experiment_name <- folder_name + "_one_street_without_signals";

	init {

	// intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle - 5, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle}, is_traffic_signal: true, traffic_signal_type: "");
		create intersection with: (location: {x_middle + 5, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_right_border, y_middle}, traffic_signal_type: "");

		// roads
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[1]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[0]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[2]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[1]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[3]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[3], intersection[2]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[3], intersection[4]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[4], intersection[3]]));

		// footways
		create footway_node with: (location: {x_left_border, y_above_middle}, list_connected_index: [1]);
		create footway_node with: (location: {x_middle - 5, y_above_middle}, list_connected_index: [0, 2, 5]);
		create footway_node with: (location: {x_middle + 5, y_above_middle}, list_connected_index: [1, 3, 6]);
		create footway_node with: (location: {x_right_border, y_above_middle}, list_connected_index: [2]);
		create footway_node with: (location: {x_left_border, y_below_middle}, list_connected_index: [5]);
		create footway_node with: (location: {x_middle - 5, y_below_middle}, list_connected_index: [1, 4, 6]);
		create footway_node with: (location: {x_middle + 5, y_below_middle}, list_connected_index: [2, 5, 7]);
		create footway_node with: (location: {x_right_border, y_below_middle}, list_connected_index: [6]);

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);

		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection {
			do declare_spawn_nodes([intersection[0]]);
			do declare_end_nodes([intersection[4]]);
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