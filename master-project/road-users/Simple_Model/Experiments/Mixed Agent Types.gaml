/**
* Name: MixedAgentTypes
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model MixedAgentTypes

import "../Base Experiment Model.gaml"

global {
	string cars_trucks_experiment_name <- "mixed_cars_trucks";
	string cars_bicycles_experiment_name <- "mixed_cars_bicycles";
	string trucks_bicycles_experiment_name <- "mixed_trucks_bicycles";

	// Configure variables for testing
	string variable_value <- "";
	string variable <- "";

	reflex save_cars_trucks_batch when: cars_batch and trucks_batch and length(variable) = 0 {
		save [cycle, car_avg_speed, truck_avg_speed, car_truck_avg_speed, traffic_density_per_km, car_truck_traffic_flow, num_cars_exiting, num_trucks_exiting, num_all_exiting] to:
		"../../output/simple_model/batch/" + cars_trucks_experiment_name + "_batch" + ".csv" format: "csv" rewrite: false;
	}

	reflex save_cars_bicycles_batch when: cars_batch and bicycles_batch and length(variable) = 0 {
		save [cycle, car_avg_speed, bicycle_avg_speed, car_bicycle_avg_speed, traffic_density_per_km, car_bicycle_traffic_flow, num_cars_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/batch/" + cars_bicycles_experiment_name + "_batch" + ".csv" format: "csv" rewrite: false;
	}

	reflex save_trucks_bicycles_batch when: trucks_batch and bicycles_batch and length(variable) = 0 {
		save
		[cycle, truck_avg_speed, bicycle_avg_speed, truck_bicycle_avg_speed, traffic_density_per_km, truck_bicycle_traffic_flow, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/batch/" + trucks_bicycles_experiment_name + "_batch" + ".csv" format: "csv" rewrite: false;
	}

	// Reflexes for parameters
	reflex save_cars_trucks_batch_paramter when: cars_batch and trucks_batch and length(variable) > 0 {
		save [cycle, car_avg_speed, truck_avg_speed, car_truck_avg_speed, traffic_density_per_km, car_truck_traffic_flow, num_cars_exiting, num_trucks_exiting, num_all_exiting] to:
		"../../output/simple_model/batch/" + variable + "/" + cars_trucks_experiment_name + "_" + variable + "_" + variable_value + "_batch" + ".csv" format: "csv" rewrite: false;
	}

	reflex save_cars_bicycles_batch_paramter when: cars_batch and bicycles_batch and length(variable) > 0 {
		save [cycle, car_avg_speed, bicycle_avg_speed, car_bicycle_avg_speed, traffic_density_per_km, car_bicycle_traffic_flow, num_cars_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/batch/" + variable + "/" + cars_bicycles_experiment_name + "_" + variable + "_" + variable_value + "_batch" + ".csv" format: "csv" rewrite:
		false;
	}

	reflex save_trucks_bicycles_batch_paramter when: trucks_batch and bicycles_batch and length(variable) > 0 {
		save
		[cycle, truck_avg_speed, bicycle_avg_speed, truck_bicycle_avg_speed, traffic_density_per_km, truck_bicycle_traffic_flow, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/batch/" + variable + "/" + trucks_bicycles_experiment_name + "_" + variable + "_" + variable_value + "_batch" + ".csv" format: "csv" rewrite:
		false;
	}

}

experiment cars_trucks type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::NUM_CARS_TESTING, num_trucks::NUM_TRUCKS_TESTING, num_pedestrians::NUM_PEDESTRIANS_SIMPLE];
		save [cycle, car_avg_speed, truck_avg_speed, car_truck_avg_speed, traffic_density_per_km, car_truck_traffic_flow, num_cars_exiting, num_trucks_exiting, num_all_exiting] to:
		"../../output/simple_model/" + cars_trucks_experiment_name + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save [cycle, car_avg_speed, truck_avg_speed, car_truck_avg_speed, traffic_density_per_km, car_truck_traffic_flow, num_cars_exiting, num_trucks_exiting, num_all_exiting] to:
		"../../output/simple_model/" + cars_trucks_experiment_name + ".csv" format: "csv" rewrite: false;
	}

	output synchronized: true {
		display speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Average speed km/h" {
				data "Car" value: car_avg_speed color: #red marker: false;
				data "Truck" value: truck_avg_speed color: #blue marker: false;
				data "Overall" value: car_truck_avg_speed color: #orange marker: false;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: car_truck_traffic_flow color: #orange marker: false;
			}

		}

	}

}

experiment cars_bicycles type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::NUM_CARS_TESTING, num_trucks::NUM_TRUCKS_TESTING, num_bicycles::NUM_BICYCLES_TESTING, num_pedestrians::NUM_PEDESTRIANS_SIMPLE];
		save [cycle, car_avg_speed, bicycle_avg_speed, car_bicycle_avg_speed, traffic_density_per_km, car_bicycle_traffic_flow, num_cars_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + cars_bicycles_experiment_name + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save [cycle, car_avg_speed, bicycle_avg_speed, car_bicycle_avg_speed, traffic_density_per_km, car_bicycle_traffic_flow, num_cars_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + cars_bicycles_experiment_name + ".csv" format: "csv" rewrite: false;
	}

	output synchronized: true {
		display speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Average speed km/h" {
				data "Car" value: car_avg_speed color: #red marker: false;
				data "Bicycle" value: bicycle_avg_speed color: #yellow marker: false;
				data "Overall" value: car_bicycle_avg_speed color: #orange marker: false;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: car_bicycle_traffic_flow color: #orange marker: false;
			}

		}

	}

}

experiment trucks_bicycles type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::NUM_CARS_TESTING, num_trucks::NUM_TRUCKS_TESTING, num_bicycles::NUM_BICYCLES_TESTING, num_pedestrians::NUM_PEDESTRIANS_SIMPLE];
		save
		[cycle, truck_avg_speed, bicycle_avg_speed, truck_bicycle_avg_speed, traffic_density_per_km, truck_bicycle_traffic_flow, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + trucks_bicycles_experiment_name + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save
		[cycle, truck_avg_speed, bicycle_avg_speed, truck_bicycle_avg_speed, traffic_density_per_km, truck_bicycle_traffic_flow, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + trucks_bicycles_experiment_name + ".csv" format: "csv" rewrite: false;
	}

	output synchronized: true {
		display speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Average speed km/h" {
				data "Truck" value: truck_avg_speed color: #blue marker: false;
				data "Bicycle" value: bicycle_avg_speed color: #yellow marker: false;
				data "Overall" value: truck_bicycle_avg_speed color: #orange marker: false;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: truck_bicycle_traffic_flow color: #orange marker: false;
			}

		}

	}

}

experiment cars_trucks_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Cars" var: num_cars <- NUM_CARS_TESTING;
	parameter "Number of Trucks" var: num_trucks <- NUM_TRUCKS_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- NUM_PEDESTRIANS_SIMPLE;
	parameter "Cars Batch" var: cars_batch <- true;
	parameter "Trucks Batch" var: trucks_batch <- true;
}

experiment cars_bicycles_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Cars" var: num_cars <- NUM_CARS_TESTING;
	parameter "Number of Bicycles" var: num_bicycles <- NUM_BICYCLES_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- NUM_PEDESTRIANS_SIMPLE;
	parameter "Cars Batch" var: cars_batch <- true;
	parameter "Bicycles Batch" var: bicycles_batch <- true;
}

experiment trucks_bicycles_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Trucks" var: num_trucks <- NUM_TRUCKS_TESTING;
	parameter "Number of Bicycles" var: num_bicycles <- NUM_BICYCLES_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- NUM_PEDESTRIANS_SIMPLE;
	parameter "Trucks Batch" var: trucks_batch <- true;
	parameter "Bicycle Batch" var: bicycles_batch <- true;
}

