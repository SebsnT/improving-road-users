/**
* Name: SingleAgentType
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model SingleAgentType

import "../Base Experiment Model.gaml"

global {
	string cars_experiment_name <- "only_cars";
	string trucks_experiment_name <- "only_trucks";
	string bicycles_experiment_name <- "only_bicycles";

	reflex save_cars_batch when: cars_batch {
		save [cycle, car_avg_speed, traffic_density_per_km, car_traffic_flow, num_cars_exiting] to: "../../output/simple_model/batch/" + cars_experiment_name + "_batch" + ".csv" format: "csv"
		rewrite: false;
	}

	reflex save_trucks_batch when: trucks_batch {
		save [cycle, truck_avg_speed, traffic_density_per_km, truck_traffic_flow, num_trucks_exiting] to: "../../output/simple_model/batch/" + trucks_experiment_name + "_batch" + ".csv" format:
		"csv" rewrite: false;
	}

	reflex save_biycles_batch when: bicycles_batch {
		save [cycle, bicycle_avg_speed, traffic_density_per_km, bicycle_traffic_flow, num_bicycles_exiting] to: "../../output/simple_model/batch/" + bicycles_experiment_name + "_batch" + ".csv" format:
		"csv" rewrite: false;
	}

}

experiment only_cars_gui type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::NUM_CARS_TESTING, num_pedestrians::NUM_PEDESTRIANS_SIMPLE];
		save [cycle, car_avg_speed, traffic_density_per_km, car_traffic_flow, num_cars_exiting] to: "../../output/simple_model/" + cars_experiment_name + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result when: !cars_batch {
		save [cycle, car_avg_speed, traffic_density_per_km, car_traffic_flow, num_cars_exiting] to: "../../output/simple_model/" + cars_experiment_name + ".csv" format: "csv" rewrite: false;
	}

	output synchronized: true {
		display speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Average speed km/h" {
				data "Car" value: car_avg_speed color: #red marker: false;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: car_traffic_flow color: #orange marker: false;
			}

		}

	}

}

experiment only_trucks_gui type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_trucks::NUM_TRUCKS_TESTING, num_pedestrians::NUM_PEDESTRIANS_SIMPLE];
		save [cycle, truck_avg_speed, traffic_density_per_km, truck_traffic_flow, num_trucks_exiting] to: "../../output/simple_model/" + trucks_experiment_name + ".csv" format: "csv" rewrite:
		true;
	}

	reflex save_result {
		save [cycle, truck_avg_speed, traffic_density_per_km, truck_traffic_flow, num_trucks_exiting] to: "../../output/simple_model/" + trucks_experiment_name + ".csv" format: "csv" rewrite:
		false;
	}

	output synchronized: true {
		display speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Average speed km/h" {
				data "Truck" value: truck_avg_speed color: #blue marker: false;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: truck_traffic_flow color: #orange marker: false;
			}

		}

	}

}

experiment only_bicycles_gui type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_bicycles::NUM_BICYCLES_TESTING, num_pedestrians::NUM_PEDESTRIANS_SIMPLE];
		save [cycle, bicycle_avg_speed, traffic_density_per_km, bicycle_traffic_flow, num_bicycles_exiting] to: "../../output/simple_model/" + bicycles_experiment_name + ".csv" format: "csv"
		rewrite: true;
	}

	reflex save_result {
		save [cycle, bicycle_avg_speed, traffic_density_per_km, bicycle_traffic_flow, num_bicycles_exiting] to: "../../output/simple_model/" + bicycles_experiment_name + ".csv" format: "csv"
		rewrite: false;
	}

	output synchronized: true {
		display speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Average speed km/h" {
				data "Bicycle" value: bicycle_avg_speed color: #yellow marker: false;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: bicycle_traffic_flow color: #orange marker: false;
			}

		}

	}

}

experiment only_cars_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Cars" var: num_cars <- NUM_CARS_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- NUM_PEDESTRIANS_SIMPLE;
	parameter "Is Batch" var: cars_batch <- true;
}

experiment only_trucks_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Trucks" var: num_trucks <- NUM_TRUCKS_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- NUM_PEDESTRIANS_SIMPLE;
	parameter "Is Batch" var: trucks_batch <- true;
}

experiment only_bicycles_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Bicycles" var: num_bicycles <- NUM_BICYCLES_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- NUM_PEDESTRIANS_SIMPLE;
	parameter "Is Batch" var: bicycles_batch <- true;
}

