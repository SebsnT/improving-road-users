/**
* Name: BaseTestingModel
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model BaseTestingModel

import "../utils/variables/global_vars_testing.gaml"
import "../models/Pedestrian.gaml"

global {
	int num_cars;
	int num_pedestrians;
	float car_avg_speed -> {mean(car collect (each.speed * 3.6))}; // average speed stats
 	float traffic_density_per_km -> {sum(road collect (each.traffic_density_per_km))};
	float traffic_flow_car -> traffic_density_per_km * car_avg_speed;
	bool measure_density <- true;
	string experiment_name <- "";

	reflex stop when: cycle = 1000 {
		do pause;
	}

	init {
		ask road {
			do setup_roads();
		}

		ask footway_edge {
			do setup_edges();
		}

	}

}

experiment testing_experiment type: gui {
	parameter "Number of Cars" var: num_cars <- NUM_CARS_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- num_pedestrians;

	action _init_ {
		create simulation with: [num_cars::NUM_CARS, num_pedestrians::num_pedestrians];
		save [time, car_avg_speed, traffic_density_per_km, traffic_flow_car] to: "../../output/testing/" + experiment_name + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save [time, car_avg_speed, traffic_density_per_km, traffic_flow_car] to: "../../output/testing/" + experiment_name + ".csv" format: "csv" rewrite: false;
	}

	output synchronized: true {
		display city type: 2d background: #grey axes: false {
			species road aspect: base;
			species intersection aspect: simple;
			species car aspect: base;
			species pedestrian aspect: base;
			species footway_node aspect: base;
			species footway_edge aspect: base;
		}

		display car_speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Average speed km/h" {
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