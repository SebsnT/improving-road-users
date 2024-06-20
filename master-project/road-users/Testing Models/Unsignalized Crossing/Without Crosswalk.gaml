/**
* Name: Crosswalk
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model WithoutCrosswalk

import "../../utils/variables/global_vars_testing.gaml"
import "../../Simple_Model/Simple_Vehicles.gaml"
import "../../Simple_Model/Simple_Pedestrians.gaml"

global {
	int num_cars;
	float car_avg_speed -> {mean(car collect (each.speed * 3.6))}; // average speed stats
	float traffic_density_per_km -> {sum(road collect (each.traffic_density_per_km))};
	float traffic_flow_car -> traffic_density_per_km * car_avg_speed;
	bool measure_density <- true;

	init {

	// intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_middle, y_middle}, is_traffic_signal: true, traffic_signal_type: "");
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
	} }

experiment unsignalized_cross_road type: gui {

	action _init_ {
		create simulation with: [num_cars::20];
		save [time, car_avg_speed] to: "../output/testing/" + self.name + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save [time, car_avg_speed] to: "../output/testing/" + self.name + ".csv" format: "csv" rewrite: false;
	}

	output synchronized: true {
		display city type: 2d background: #grey axes: false {
			species road aspect: base;
			species intersection aspect: simple;
			species car aspect: base;
			species footway_node aspect: base;
			species footway_edge aspect: base;
		}

		display car_speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Cycle" y_label: "Average speed km/h" {
				data "Car" value: car_avg_speed color: #red marker: false;
			}

		}

		display density_per_km type: 2d {
			chart "Traffic Density Per Km" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per km" {
				data "Vehicles" value: traffic_density_per_km color: #purple marker: false;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: traffic_flow_car color: #orange marker: false;
			}

		}

	}

}

