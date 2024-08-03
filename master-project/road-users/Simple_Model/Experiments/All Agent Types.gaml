/**
* Name: AllAgentTypes
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model AllAgentTypes

import "../Base Experiment Model.gaml"

global {

	// Urban Basline
	int CARS_URBAN_BASELINE <- 200;
	int TRUCKS_URBAN_BASELINE <- 20;
	int BICYCLES_URBAN_BASELINE <- 40;
	int PEDESTRIANS_URBAN_BASELINE <- 300;

	// High Density
	int CARS_URBAN_HIGH_DENSITY <- 300;
	int TRUCKS_URBAN_HIGH_DENSITY <- 30;
	int BICYCLES_URBAN_HIGH_DENSITY <- 60;
	int PEDESTRIANS_URBAN_HIGH_DENSITY <- 400;

	// Suburban
	int CARS_SUBURBAN <- 50;
	int TRUCKS_SUBURBAN <- 5;
	int BICYCLES_SUBURBAN <- 20;
	int PEDESTRIANS_SUBURBAN <- 200;
	string experiment_name <- "";
	string variable <- "";
	string folder <- "";

	reflex save_cars_trucks_bicycles_batch when: cars_batch and trucks_batch and bicycles_batch {
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/batch/" + folder + experiment_name + variable + "_batch" + ".csv" format: "csv" rewrite: false;
	}

}

experiment all_equal type: gui parent: base_experiment {

	action _init_ {
		experiment_name <- "all_equal";
		create simulation with: [num_cars::NUM_CARS_TESTING, num_trucks::NUM_TRUCKS_TESTING, num_bicycles::NUM_BICYCLES_TESTING, num_pedestrians::NUM_PEDESTRIANS_SIMPLE];
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + folder + experiment_name + variable + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + folder + experiment_name + variable + ".csv" format: "csv" rewrite: false;
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

experiment urban_baseline type: gui parent: base_experiment {
		
	action _init_ {
		experiment_name <- "urban_baseline";
		create simulation with: [num_cars::CARS_URBAN_BASELINE, num_trucks::TRUCKS_URBAN_BASELINE, num_bicycles::BICYCLES_URBAN_BASELINE, num_pedestrians::PEDESTRIANS_URBAN_BASELINE];
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + folder + experiment_name + variable + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + folder + experiment_name + variable + ".csv" format: "csv" rewrite: false;
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

experiment urban_high_density type: gui parent: base_experiment {

	action _init_ {
		experiment_name <- "urban_high_density";
		create simulation with:
		[num_cars::CARS_URBAN_HIGH_DENSITY, num_trucks::TRUCKS_URBAN_HIGH_DENSITY, num_bicycles::BICYCLES_URBAN_HIGH_DENSITY, num_pedestrians::PEDESTRIANS_URBAN_HIGH_DENSITY];
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + folder + experiment_name + variable + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + folder + experiment_name + variable + ".csv" format: "csv" rewrite: false;
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

experiment suburban type: gui parent: base_experiment {

	action _init_ {
		experiment_name <- "suburban";
		create simulation with: [num_cars::CARS_SUBURBAN, num_trucks::TRUCKS_SUBURBAN, num_bicycles::BICYCLES_SUBURBAN, num_pedestrians::PEDESTRIANS_SUBURBAN];
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + folder + experiment_name + variable + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save
		[cycle, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow, num_cars_exiting, num_trucks_exiting, num_bicycles_exiting, num_all_exiting]
		to: "../../output/simple_model/" + folder + experiment_name + variable + ".csv" format: "csv" rewrite: false;
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

experiment all_equal_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Cars" var: num_cars <- NUM_CARS_TESTING;
	parameter "Number of Trucks" var: num_trucks <- NUM_TRUCKS_TESTING;
	parameter "Number of Bicycles" var: num_bicycles <- NUM_BICYCLES_TESTING;
	parameter "Number of Pedestrians" var: num_pedestrians <- NUM_PEDESTRIANS_SIMPLE;
	parameter "Cars Batch" var: cars_batch <- true;
	parameter "Trucks Batch" var: trucks_batch <- true;
	parameter "Bicycle Batch" var: bicycles_batch <- true;
	parameter "Experiment Name" var: experiment_name <- "all_equal";
	
	parameter "Without Variable" var: variable <- "";
	parameter "Without Variable Folder" var: folder <- "";
}

experiment urban_baseline_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Cars" var: num_cars <- CARS_URBAN_BASELINE;
	parameter "Number of Trucks" var: num_trucks <- TRUCKS_URBAN_BASELINE;
	parameter "Number of Bicycles" var: num_bicycles <- BICYCLES_URBAN_BASELINE;
	parameter "Number of Pedestrians" var: num_pedestrians <- PEDESTRIANS_URBAN_BASELINE;
	parameter "Cars Batch" var: cars_batch <- true;
	parameter "Trucks Batch" var: trucks_batch <- true;
	parameter "Bicycle Batch" var: bicycles_batch <- true;
	parameter "Experiment Name" var: experiment_name <- "urban_baseline";
	
	parameter "Without Variable" var: variable <- "";
	parameter "Without Variable Folder" var: folder <- "";
	
}

experiment urban_high_density_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Cars" var: num_cars <- CARS_URBAN_HIGH_DENSITY;
	parameter "Number of Trucks" var: num_trucks <- TRUCKS_URBAN_HIGH_DENSITY;
	parameter "Number of Bicycles" var: num_bicycles <- BICYCLES_URBAN_HIGH_DENSITY;
	parameter "Number of Pedestrians" var: num_pedestrians <- PEDESTRIANS_URBAN_HIGH_DENSITY;
	parameter "Cars Batch" var: cars_batch <- true;
	parameter "Trucks Batch" var: trucks_batch <- true;
	parameter "Bicycle Batch" var: bicycles_batch <- true;
	parameter "Experiment Name" var: experiment_name <- "urban_high_density";
	
	parameter "Without Variable" var: variable <- "";
	parameter "Without Variable Folder" var: folder <- "";
}

experiment suburban_batch autorun: true type: batch repeat: 100 parallel: false until: cycle >= 1000 {
	parameter "Number of Cars" var: num_cars <- CARS_SUBURBAN;
	parameter "Number of Trucks" var: num_trucks <- TRUCKS_SUBURBAN;
	parameter "Number of Bicycles" var: num_bicycles <- BICYCLES_SUBURBAN;
	parameter "Number of Pedestrians" var: num_pedestrians <- PEDESTRIANS_SUBURBAN;
	parameter "Cars Batch" var: cars_batch <- true;
	parameter "Trucks Batch" var: trucks_batch <- true;
	parameter "Bicycle Batch" var: bicycles_batch <- true;
	parameter "Experiment Name" var: experiment_name <- "suburban";
	
	parameter "Without Variable" var: variable <- "";
	parameter "Without Variable Folder" var: folder <- "";
}

