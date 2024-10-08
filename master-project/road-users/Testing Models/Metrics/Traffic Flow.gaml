/**
* Name: TrafficFlow
* Author: PC
* Tags: 
*/
model TrafficFlow

import "../../utils/variables/global_vars_testing.gaml"
import "../../models/Vehicles.gaml"
import "../../models/Pedestrian.gaml"

global {
	int num_cars;
	int num_trucks;
	int num_bicycles;
	float car_avg_speed -> {mean(car collect (each.speed)) * 3.6}; // average speed stats
	float truck_avg_speed -> {mean(truck collect (each.speed)) * 3.6}; // average speed stats
	float bicycle_avg_speed -> {mean(bicycle collect (each.speed)) * 3.6}; // average speed stats
	float all_avg_speed -> mean([car_avg_speed, truck_avg_speed, bicycle_avg_speed]);
	float traffic_density_per_km -> {sum(road collect (each.traffic_density_per_km))};
	float traffic_flow -> traffic_density_per_km * all_avg_speed;
	float size_environment <- 360 #m;

	// measure density of the road
	bool measure_density <- true;

	reflex stop_simulation when: length(car) = 0 and length(truck) = 0 and length(bicycle) = 0 {
		do pause;
	}

	init {

	// intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_left_border, y_middle + 10}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle + 10}, traffic_signal_type: "");
		create intersection with: (location: {x_left_border, y_middle + 20}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle + 20}, traffic_signal_type: "");

		// roads
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[1]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[3]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[4], intersection[5]]));

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);
		ask intersection {
			do declare_spawn_nodes([]);
			do declare_end_nodes([intersection[1], intersection[3], intersection[5]]);
			do setup_env();
		}

		ask road {
			do setup_roads();
		}

		create car number: num_cars with: (location: intersection[0].location);
		create truck number: num_trucks with: (location: intersection[2].location);
		create bicycle number: num_bicycles with: (location: intersection[4].location);
	} }

experiment straight_road type: gui {

	action _init_ {
		create simulation with: [num_cars::1, num_trucks::1, num_bicycles::1];
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
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Seconds" y_label: "Average speed km/h" {
				data "Car" value: car_avg_speed color: #red;
				data "Truck" value: truck_avg_speed color: #blue;
				data "Bicycle" value: bicycle_avg_speed color: #yellow;
				data "All Average Speed" value: all_avg_speed color: #orange;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: traffic_flow color: #blue;
			}

		}

	}

}