/**
* Name: TrafficDensity
* Based on the internal empty template. 
* Author: PC
* Tags: 
*/
model TrafficDensity

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
	float traffic_densiy_percentage -> {mean(road collect (each.traffic_density_percentage))}; // average traffic density
	float traffic_density_per_km -> {sum(road collect (each.traffic_density_per_km))};
	float size_environment <- 1060 #m;

	// measure density of the road
	bool measure_density <- true;

	// vehicles should not despawn as to test density
	bool despawn_vehicles -> false;

	// set distances to zero to test if density can reach 100
	float MIN_SAFETY_DISTANCE <- 0.0 #m;
	float MIN_SECURITY_DISTANCE <- 0.0 #m;

	init {

	// intersections
		create intersection with: (location: {x_left_border, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle}, traffic_signal_type: "");
		create intersection with: (location: {x_left_border, y_middle - 10}, traffic_signal_type: "");
		create intersection with: (location: {size_environment - 10, y_middle - 10}, traffic_signal_type: "");

		// roads
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[0], intersection[1]]));
		create road with: (num_lanes: NUM_LANES, maxspeed: 50 #km / #h, shape: line([intersection[2], intersection[3]]));

		//build the graph from the roads and intersections
		graph road_network <- as_driving_graph(road, intersection);
		ask intersection {
			do declare_spawn_nodes([intersection[0], intersection[2]]);
			do declare_end_nodes([intersection[1], intersection[3]]);
			do setup_env();
		}

		ask road {
			do setup_roads();
		}

		create car number: num_cars with: (location: one_of(spawn_nodes).location);
	} }

experiment traffic_density_experiment type: gui {

	action _init_ {
		create simulation with: [num_cars::200];
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

		display density_percentage type: 2d {
			chart "Traffic Density Percentage" type: series size: {1, 1} position: {0, 0} x_label: "Seconds" y_label: "Density in percent (%)" {
				data "Traffic Density in percent" value: traffic_densiy_percentage * 100 color: #red;
			}

		}

		display density_per_km type: 2d {
			chart "Traffic Density Per Km" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Density per km" {
				data "Vehicles" value: traffic_density_per_km color: #blue;
			}

		}

	}

}