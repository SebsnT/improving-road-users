/**
* Name: CrossIntersection
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model CrossIntersection

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

experiment singalized_cross_intersection type: gui {

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

		display speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Seconds" y_label: "Average speed km/h" {
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