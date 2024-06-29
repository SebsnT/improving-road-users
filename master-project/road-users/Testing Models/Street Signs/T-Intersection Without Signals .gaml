/**
* Name: Giveway
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model TIntersection

import "../../utils/variables/global_vars_testing.gaml"
import "../../Simple_Model/Simple_Vehicles.gaml"
import "../../Simple_Model/Simple_Pedestrians.gaml"
import "../Base Testing Model.gaml"

global {
	string experiment_name <- "street_signs_t_without_signal";

	init {
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_right_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle + 5}, is_traffic_signal: true, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle + 100}, traffic_signal_type: "");

		// roads
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[2]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[4], intersection[3]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[3], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[1], intersection[3]]));

		//build the graph from the roads and intersections
 graph road_network <- as_driving_graph(road, intersection);
		ask intersection {
			do declare_spawn_nodes([intersection[0], intersection[4]]);
			do declare_end_nodes([intersection[2]]);
			do setup_env();
		}

		ask road {
			do setup_roads();
		}

		create car number: num_cars with: (location: one_of(spawn_nodes).location);
	} }



