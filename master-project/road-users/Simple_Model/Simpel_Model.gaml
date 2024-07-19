/**
* Name: SimpleModel
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model SimpleModel

import "../utils/variables/global_vars_testing.gaml"
import "../models/Vehicles.gaml"
import "../models/Pedestrian.gaml"

global {
	
	int num_cars;
	int num_trucks;
	int num_bicycles;
	int num_pedestrians;

	// measure density of the road
	bool measure_density <- true;
	bool despawn_vehicles <- true;
	
	
	float size_environment <- 5 #km;
	geometry shape <- square(size_environment);
	// constants for road creation
	float padding <- 100.0;
	
	float left_border <- padding;
	float right_border <- size_environment - padding;
	float upper_border <- padding;
	float lower_border <- size_environment - padding;
	float y_middle_road <- size_environment / 2 - 500;
	float y_lower_road <- size_environment / 2 + 500;
	float y_above_middle_road <- y_middle_road - 5;
	float y_under_middle_road <- y_middle_road + 5;
	float y_above_lower_road <- y_lower_road - 5;
	float y_under_lower_road <- y_lower_road + 5;
	float y_between_roads <- y_middle_road + 300;
	float x_left_intersection <- size_environment / 2 - 1000;
	float x_right_intersection <- size_environment / 2;

	init {

	//----------------------------------------------------------------------
	// Create Intersections
	//----------------------------------------------------------------------

		// Middle line

		// left border
		create intersection with: (location: {left_border, y_middle_road}, traffic_signal_type: "");

		// left traffic light
		create intersection with: (location: {x_left_intersection, y_middle_road}, is_traffic_signal: true, traffic_signal_type: "traffic_signals");

		// left and right crossings
		create intersection with: (location: {x_left_intersection - 5, y_middle_road}, is_traffic_signal: true, traffic_signal_type: "crossing");
		create intersection with: (location: {x_left_intersection + 5, y_middle_road}, is_traffic_signal: true, traffic_signal_type: "crossing");

		// up and down crossings
		create intersection with: (location: {x_left_intersection, y_middle_road - 5}, is_traffic_signal: true, traffic_signal_type: "crossing");
		create intersection with: (location: {x_left_intersection, y_middle_road + 5}, is_traffic_signal: true, traffic_signal_type: "crossing");

		// right traffic light
		create intersection with: (location: {x_right_intersection, y_middle_road}, is_traffic_signal: true, traffic_signal_type: "traffic_signals");

		// left and right crossings
		create intersection with: (location: {x_right_intersection - 5, y_middle_road}, is_traffic_signal: true, traffic_signal_type: "crossing");
		create intersection with: (location: {x_right_intersection + 5, y_middle_road}, is_traffic_signal: true, traffic_signal_type: "crossing");

		// up and down crossings
		create intersection with: (location: {x_right_intersection, y_middle_road - 5}, is_traffic_signal: true, traffic_signal_type: "crossing");
		create intersection with: (location: {x_right_intersection, y_middle_road + 5}, is_traffic_signal: true, traffic_signal_type: "crossing");

		// right border
		create intersection with: (location: {right_border, y_middle_road}, traffic_signal_type: "");

		// Upper Horizontal lines
		create intersection with: (location: {x_left_intersection, upper_border}, traffic_signal_type: "");
		create intersection with: (location: {x_right_intersection, upper_border}, traffic_signal_type: "");

		// Middle of the road crossing
		create intersection with: (location: {x_left_intersection, y_between_roads}, is_traffic_signal: true, traffic_signal_type: "crossing");

		// Lower Horizontal lines
		create intersection with: (location: {x_left_intersection, y_lower_road}, traffic_signal_type: "");
		create intersection with: (location: {x_left_intersection, y_lower_road + 5}, is_traffic_signal: true, traffic_signal_type: "crossing");
		create intersection with: (location: {x_left_intersection + 5, y_lower_road}, is_traffic_signal: true, traffic_signal_type: "stop");
		create intersection with: (location: {x_right_intersection, y_lower_road}, traffic_signal_type: "");
		create intersection with: (location: {x_right_intersection, y_lower_road - 5}, is_traffic_signal: true, traffic_signal_type: "crossing");
		create intersection with: (location: {x_right_intersection, y_lower_road + 5}, is_traffic_signal: true, traffic_signal_type: "crossing");
		create intersection with: (location: {x_right_intersection - 5, y_lower_road}, is_traffic_signal: true, traffic_signal_type: "give_way");

		//create intersection with: (location: {x_right_intersection, y_middle_road}, is_traffic_signal: true, traffic_signal_type:"crossing");

		// Lowest Horizontal line
		create intersection with: (location: {x_left_intersection, lower_border}, traffic_signal_type: "");
		create intersection with: (location: {x_right_intersection, lower_border}, traffic_signal_type: "");

		//----------------------------------------------------------------------
		// Connect Roads
		//----------------------------------------------------------------------

		// Node 0
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[2]]));

		// Node 1
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[2]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[3]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[4]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[5]]));

		// Node 2
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[0]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[1]]));

		// Node 3
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[3], intersection[1]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[3], intersection[7]]));

		// Node 4
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[4], intersection[1]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[4], intersection[12]]));

		// Node 5
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[5], intersection[1]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[5], intersection[14]]));

		// Node 6
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[6], intersection[7]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[6], intersection[8]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[6], intersection[9]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[6], intersection[10]]));

		// Node 7
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[7], intersection[3]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[7], intersection[6]]));

		// Node 8 
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[8], intersection[6]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[8], intersection[11]]));

		// Node 9 
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[9], intersection[6]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[9], intersection[13]]));

		// Node 10
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[10], intersection[6]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[10], intersection[18]]));

		// Node 11
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[11], intersection[8]]));

		// Node 12
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[12], intersection[4]]));

		// Node 13
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[13], intersection[9]]));

		// Node 14
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[14], intersection[5]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[14], intersection[15]]));

		// Node 15
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[15], intersection[14]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[15], intersection[16]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[15], intersection[17]]));

		// Node 16
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[16], intersection[15]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[16], intersection[22]]));

		// Node 17
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[17], intersection[15]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[17], intersection[21]]));

		// Node 18
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[18], intersection[19]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[18], intersection[20]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[18], intersection[21]]));

		// Node 19
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[19], intersection[10]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[19], intersection[18]]));

		// Node 20
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[20], intersection[18]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[20], intersection[23]]));

		// Node 21
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[21], intersection[17]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[21], intersection[18]]));

		// Node 22
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[22], intersection[16]]));

		// Node 23
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[23], intersection[20]]));

		//----------------------------------------------------------------------
		// Create and Connect Foootways
		//----------------------------------------------------------------------

		// left border
		create footway_node with: (location: {left_border, y_above_middle_road}, list_connected_index: [2]);
		create footway_node with: (location: {left_border, y_under_middle_road}, list_connected_index: [3]);

		// left intersection
		create footway_node with: (location: {x_left_intersection - 5, y_above_middle_road}, list_connected_index: [0, 3, 4, 6]);
		create footway_node with: (location: {x_left_intersection - 5, y_under_middle_road}, list_connected_index: [1, 2, 5, 16]);
		create footway_node with: (location: {x_left_intersection + 5, y_above_middle_road}, list_connected_index: [2, 5, 7, 8]);
		create footway_node with: (location: {x_left_intersection + 5, y_under_middle_road}, list_connected_index: [3, 4, 9, 17]);

		// left upper
		create footway_node with: (location: {x_left_intersection - 5, upper_border}, list_connected_index: [2]);
		create footway_node with: (location: {x_left_intersection + 5, upper_border}, list_connected_index: [4]);

		// right intersection
		create footway_node with: (location: {x_right_intersection - 5, y_above_middle_road}, list_connected_index: [4, 9, 10, 12]);
		create footway_node with: (location: {x_right_intersection - 5, y_under_middle_road}, list_connected_index: [5, 8, 11, 22]);
		create footway_node with: (location: {x_right_intersection + 5, y_above_middle_road}, list_connected_index: [8, 11, 13, 14]);
		create footway_node with: (location: {x_right_intersection + 5, y_under_middle_road}, list_connected_index: [9, 10, 15, 24]);

		// right upper
		create footway_node with: (location: {size_environment / 2 - 5, upper_border}, list_connected_index: [8]);
		create footway_node with: (location: {size_environment / 2 + 5, upper_border}, list_connected_index: [10]);

		// right border
		create footway_node with: (location: {right_border, y_above_middle_road}, list_connected_index: [10]);
		create footway_node with: (location: {right_border, y_under_middle_road}, list_connected_index: [11]);

		// middle of the road
		create footway_node with: (location: {x_left_intersection - 5, y_between_roads}, list_connected_index: [3, 17, 18]);
		create footway_node with: (location: {x_left_intersection + 5, y_between_roads}, list_connected_index: [5, 16, 20]);

		// Lower Nodes

		// lower left intersection
		create footway_node with: (location: {x_left_intersection - 5, y_above_lower_road}, list_connected_index: [16, 19, 20]);
		create footway_node with: (location: {x_left_intersection - 5, y_under_lower_road}, list_connected_index: [18, 21, 26]);
		create footway_node with: (location: {x_left_intersection + 5, y_above_lower_road}, list_connected_index: [17, 18, 21, 22]);
		create footway_node with: (location: {x_left_intersection + 5, y_under_lower_road}, list_connected_index: [19, 20, 23, 27]);

		// lower right intersection
		create footway_node with: (location: {x_right_intersection - 5, y_above_lower_road}, list_connected_index: [9, 20, 23, 24]);
		create footway_node with: (location: {x_right_intersection - 5, y_under_lower_road}, list_connected_index: [21, 22, 25, 28]);
		create footway_node with: (location: {x_right_intersection + 5, y_above_lower_road}, list_connected_index: [11, 22, 25]);
		create footway_node with: (location: {x_right_intersection + 5, y_under_lower_road}, list_connected_index: [23, 24, 29]);

		// bottom left
		create footway_node with: (location: {x_left_intersection - 5, lower_border}, list_connected_index: [19]);
		create footway_node with: (location: {x_left_intersection + 5, lower_border}, list_connected_index: [21]);

		// bottom right
		create footway_node with: (location: {x_right_intersection - 5, lower_border}, list_connected_index: [23]);
		create footway_node with: (location: {x_right_intersection + 5, lower_border}, list_connected_index: [25]);

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);

		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection {
			do declare_spawn_nodes([intersection[0],intersection[11], intersection[12], intersection[13],intersection[22],intersection[23]]);
			do declare_end_nodes(spawn_nodes);
			do setup_env();
		}

		ask road {
			do setup_roads();
		}

		ask footway_edge {
			do setup_edges();
		}

		create car number: num_cars with: (location: one_of(road).location);
		create truck number: num_trucks with: (location: one_of(road).location);
		create bicycle number: num_bicycles with: (location: one_of(road).location);
		create pedestrian number: num_pedestrians with: (location: one_of(footway_edge).location);
	} }


