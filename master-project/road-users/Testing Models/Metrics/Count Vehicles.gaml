/**
* Name: StraightRoad
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model StraightRoad

import "../../utils/variables/global_vars_testing.gaml"
import "../../models/Vehicles.gaml"
import "../../models/Pedestrian.gaml"

global {
	int num_cars;
	int num_trucks;
	int num_bicycles;
	float size_environment <- 500 #m;

	init {

	// intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_left_border, y_middle + 10}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle + 10}, traffic_signal_type: "");
		create intersection with: (location: {x_left_border, y_middle + 20}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle + 20}, traffic_signal_type: "");

		// roads
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[1]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[3]]));
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[4], intersection[5]]));

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);
		ask intersection {
			do declare_end_nodes([intersection[1], intersection[3], intersection[5]]);
			do declare_spawn_nodes([intersection[0], intersection[2], intersection[4]]);
			do setup_env();
		}

		create car number: num_cars with: (location: intersection[0].location);
		create truck number: num_trucks with: (location: intersection[2].location);
		create bicycle number: num_bicycles with: (location: intersection[4].location);
	} }

experiment count_vehicles type: gui {

	action _init_ {
		create simulation with: [num_cars::1, num_trucks::1, num_bicycles::1];
		//save [] to: "../../output/metrics/average_speed_test.csv" format: "csv" rewrite: true;
	}

	reflex save {
		//save [cycle] to: "../../output/metrics/average_speed_test.csv" format: "csv" rewrite: false;
	}

	output synchronized: true {
		display city type: 2d background: #grey axes: false {
			species road aspect: base;
			species intersection aspect: simple;
			species car aspect: base;
			species truck aspect: base;
			species bicycle aspect: base;
		}

		display Vehicle_Entry type: 2d {
			chart "Count Entering Vehicles" type: histogram size: {1, 1} position: {0, 0} x_label: "Seconds" y_label: "Absolute Vehicle Count" {
			}

		}

		display Vehicle_Exit type: 2d {
			chart "Absolute Number of vehicles exited" type: histogram size: {1, 1} position: {0, 0} x_label: "Types of Vehicles" y_label: "Number of Vehicles exited" {
				data "Cars" value: num_cars_exiting color: #red;
				data "Trucks" value: num_trucks_exiting color: #blue;
				data "Bicycles" value: num_bicycles_exiting color: #yellow;
			}

		}

	}

}