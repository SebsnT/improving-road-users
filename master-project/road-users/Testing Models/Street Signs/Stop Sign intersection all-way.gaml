/**
* Name: StopSignCrossIntersection
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model CrossIntersection

import "../Base Testing Model.gaml"

global {
	string experiment_name <- "street_signs_all_way_stop";

	init {

		// Middle Intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle}, is_traffic_signal: true, traffic_signal_type: "");
		create intersection with: (location: {x_right_border, y_middle}, traffic_signal_type: "");

		// 	Top and bottom intersection	
		create intersection with: (location: {x_middle, y_top_border}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_bottom_border}, traffic_signal_type: "");

		// Intersections around crossing streets
		create intersection with: (location: {x_middle - 5, y_middle}, traffic_signal_type: "stop");
		create intersection with: (location: {x_middle + 5, y_middle}, traffic_signal_type: "stop");
		create intersection with: (location: {x_middle, y_middle - 5}, traffic_signal_type: "stop");
		create intersection with: (location: {x_middle, y_middle + 5}, traffic_signal_type: "stop");

		// horizontal drive
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[5]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[5]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[6]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[7]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[8]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[6]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[3], intersection[7]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[4], intersection[8]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[5], intersection[0]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[5], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[6], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[6], intersection[2]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[7], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[7], intersection[3]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[8], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[8], intersection[4]]));

		// vertical drive

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);

		//for traffic light, initialize their counter value (synchronization of traffic lights)
		ask intersection {
			do declare_spawn_nodes([intersection[0], intersection[2], intersection[3], intersection[4]]);
			do declare_end_nodes([intersection[0], intersection[2], intersection[3], intersection[4]]);
			do setup_env();
		}

		ask road {
			do setup_roads();
		}

		create car number: num_cars with: (location: one_of(spawn_nodes).location);
	} }