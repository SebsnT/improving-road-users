/**
* Name: AllAgentTypes
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model AllAgentTypes

import "../Base Experiment Model.gaml"

global {
	string cars_trucks_bicycles_experiment_name <- "cars_trucks_bicycles";

	reflex save_cars_trucks_batch when: cars_batch and trucks_batch and bicycles_batch {
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/batch/" + cars_trucks_bicycles_experiment_name + "_batch" format: "csv" rewrite: false;
	}

}

experiment cars_trucks_bicycles type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::NUM_CARS_TESTING, num_trucks::NUM_TRUCKS_TESTING, num_bicycles::NUM_BICYCLES_TESTING, num_pedestrians::NUM_PEDESTRIANS_TESTING];
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + cars_trucks_bicycles_experiment_name format: "csv" rewrite: true;
	}

	reflex save_result {
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + cars_trucks_bicycles_experiment_name format: "csv" rewrite: false;
	}

	output synchronized: true {
		display speed_chart type: 2d {
			chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Average speed km/h" {
				data "Car" value: car_avg_speed color: #red marker: false;
				data "Truck" value: truck_avg_speed color: #blue marker: false;
				data "Bicycle" value: bicycle_avg_speed color: #yellow marker: false;
				data "Overall" value: all_avg_speed color: #orange marker: false;
			}

		}

		display traffic_flow type: 2d {
			chart "Traffic Flow" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per Hour" {
				data "Vehicles per Hour" value: all_traffic_flow color: #orange marker: false;
			}

		}

	}

}

experiment cars_trucks_bicycles_batch autorun: true type: batch repeat: 2 parallel: false until: cycle >= 1000 {
	parameter "Number of Cars" var: num_cars <- NUM_CARS_TESTING;
	parameter "Number of Trucks" var: num_trucks <- NUM_TRUCKS_TESTING;
	parameter "Number of Bicycles" var: num_bicycles <- NUM_BICYCLES_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- NUM_PEDESTRIANS_TESTING;
	parameter "Cars Batch" var: cars_batch <- true;
	parameter "Trucks Batch" var: trucks_batch <- true;
	parameter "Bicycle Batch" var: bicycles_batch <- true;
}

