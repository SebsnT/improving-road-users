/**
* Name: Crosswalk
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model Crosswalk

import "../../utils/variables/global_vars_testing.gaml"
import "../../Simple_Model/Simple_Vehicles.gaml"
import "../../Simple_Model/Simple_Pedestrians.gaml"
import "../Base Testing Model.gaml"

global {
	string experiment_name <- "use_crosswalk";
	int num_pedestrians <- 20;

	init {

	// intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle}, is_traffic_signal: true, traffic_signal_type: "crossing");
		create intersection with: (location: {x_right_border, y_middle}, traffic_signal_type: "");

		// roads
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[2]]));

		// footways
		create footway_node with: (location: {x_left_border, y_above_middle}, list_connected_index: [1]);
		create footway_node with: (location: {x_middle, y_above_middle}, list_connected_index: [0, 2, 4]);
		create footway_node with: (location: {x_right_border, y_above_middle}, list_connected_index: [1]);
		create footway_node with: (location: {x_left_border, y_below_middle}, list_connected_index: [4]);
		create footway_node with: (location: {x_middle, y_below_middle}, list_connected_index: [1, 3, 5]);
		create footway_node with: (location: {x_right_border, y_below_middle}, list_connected_index: [4]);

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);

		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection {
			do declare_spawn_nodes([intersection[0]]);
			do declare_end_nodes([intersection[2]]);
			do setup_env();
		}

		ask road {
			do setup_roads();
		}

		ask footway_edge {
			do setup_edges();
		}

		create car number: num_cars with: (location: one_of(spawn_nodes).location);
		create pedestrian number: num_pedestrians with: (location: one_of(footway_edge[0], footway_edge[1], footway_edge[3], footway_edge[4]).location);
	} }

