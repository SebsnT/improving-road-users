/**
* Name: TrafficDensity
* Based on the internal empty template. 
* Author: PC
* Tags: 
*/
model TrafficDensity

import "../utils/variables/global_vars_testing.gaml"
import "../Simple_Model/Simple_Vehicles.gaml"
import "../Simple_Model/Simple_Pedestrians.gaml"

global {
	int num_cars;
	int num_trucks;
	int num_bicycles;
	float car_avg_speed -> {mean(car collect (each.speed)) * 3.6}; // average speed stats
	float truck_avg_speed -> {mean(truck collect (each.speed)) * 3.6}; // average speed stats
	float bicycle_avg_speed -> {mean(bicycle collect (each.speed)) * 3.6}; // average speed stats
	float traffic_densiy -> {mean(road collect (each.traffic_density))}; // average traffic density
	float size_environment <- 360 #m;
	
	// measure density of the road
	bool measure_density <- true;

	// vehicles should not despawn as to test density
	bool despawn_vehicles -> false;

	// set distances to zero to test if density can reach 100
	float MIN_SAFETY_DISTANCE <- 0.0 #m;
	float MIN_SECURITY_DISTANCE <- 0.0 #m;

	reflex stop_simulation when: length(car) = 0 and length(truck) = 0 and length(bicycle) = 0 {
		do pause;
	}

	init {

	// intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle}, traffic_signal_type: "");

		// roads
		create road with: (num_lanes: 1, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[1]]));

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);
		ask intersection {
			do declare_spawn_nodes([intersection[0]]);
			do declare_end_nodes([intersection[1]]);
			do setup_env();
		}

		ask road {
			do setup_roads();
		}

		create car number: num_cars with: (location: intersection[0].location);
		save [] to: "../data/testing/traffic_density_test.csv" format: "csv" rewrite: true;
	} }

experiment traffic_density type: gui {

	action _init_ {
		create simulation with: [num_cars::100];
	}

	output synchronized: true {
		display city type: 2d background: #grey axes: false {
			species road aspect: base;
			species intersection aspect: simple;
			species car aspect: base;
			species truck aspect: base;
			species bicycle aspect: base;
			species pedestrian aspect: base;
			species footway_node aspect: base;
			species footway_edge aspect: base;
		}

		display car_speed_chart type: 2d {
			graphics "my new layer" {
				write time color: #red;
			}

			chart "Traffic Density" type: series size: {1, 1} position: {0, 0} x_label: "Cycle" y_label: "Average speed km/h" {
				data "Traffic Density in percent" value: traffic_densiy * 100 color: #red;
			}

		}

		//monitor "Traffic_density" value: traffic_densiy with_precision 2 color: #red;
	}

	reflex save_result {
		save [time, traffic_densiy] to: "../data/testing/traffic_density_test.csv" format: "csv" rewrite: false;
	}

}