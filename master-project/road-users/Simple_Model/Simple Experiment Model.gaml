/**
* Name: SimpleExperiments
* Author: Sebastian
* Tags: 
*/
model SimpleExperiments

import "../utils/variables/global_vars_testing.gaml"
import "../models/Vehicles.gaml"
import "../models/Pedestrian.gaml"

global {
	int num_cars;
	int num_trucks;
	int num_bicycles;
	int num_pedestrians;

	// measure density of the road
 bool measure_density <- true;
	bool despawn_vehicles <- false;

	// for speed charts 
 // calculate average speed
 // multiply with 3.6 to convert to km/h
 // Single agent average speeds
 float car_avg_speed -> {mean(car collect
	(each.speed * 3.6))}; // average speed stats
 float truck_avg_speed -> {mean(truck collect (each.speed * 3.6))}; // average speed stats
 float bicycle_avg_speed -> {mean(bicycle
	collect (each.speed * 3.6))}; // average speed stats
 float pedestrian_avg_speed -> {mean(pedestrian collect (each.speed * 3.6))}; // average speed stats

	// Mixed agents average speed
 float car_truck_avg_speed -> mean([car_avg_speed, truck_avg_speed]);
	float car_bicycle_avg_speed -> mean([car_avg_speed, bicycle_avg_speed]);
	float all_avg_speed -> mean([car_avg_speed, truck_avg_speed, bicycle_avg_speed]);

	// Traffic density
 float traffic_densiy_percentage -> {mean(road collect (each.traffic_density_percentage))}; // average traffic density
 float
	traffic_density_per_km -> {sum(road collect (each.traffic_density_per_km))};

	// Traffic flow
 float car_traffic_flow -> traffic_density_per_km * car_avg_speed;
	float car_truck_traffic_flow -> traffic_density_per_km * car_truck_avg_speed;
	float car_bicycle_traffic_flow -> traffic_density_per_km * car_bicycle_avg_speed;
	float all_traffic_flow -> traffic_density_per_km * all_avg_speed;

	reflex stop when: cycle = 1000 {
		do pause;
	}

}

experiment base_experiment type: gui {
	int experiment_number <- 0;
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

		display density_per_km type: 2d {
			chart "Traffic Density Per Km" type: series size: {1, 1} position: {0, 0} x_label: "Time in Seconds" y_label: "Vehicles per km" {
				data "Vehicles" value: traffic_density_per_km color: #purple marker: false;
			}

		}

	}

}

experiment only_cars type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::50];
		save [time, car_avg_speed, traffic_density_per_km, car_traffic_flow] to: "../output/simple_model/" + self.name + ".csv" format: "csv" rewrite: true;
	}

	reflex save_result {
		save [time, car_avg_speed, traffic_density_per_km, car_traffic_flow] to: "../output/simple_model/" + self.name + ".csv" format: "csv" rewrite: false;
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

experiment cars_trucks type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::30, num_trucks::30];
		save [time, car_avg_speed, truck_avg_speed, car_truck_avg_speed, traffic_density_per_km, car_truck_traffic_flow] to: "../output/simple_model/" + self.name + ".csv" format:
		"csv" rewrite: true;
	}

	reflex save_result {
		save [time, car_avg_speed, truck_avg_speed, car_truck_avg_speed, traffic_density_per_km, car_truck_traffic_flow] to: "../output/simple_model/" + self.name + ".csv" format:
		"csv" rewrite: false;
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
		create simulation with: [num_cars::30, num_trucks::30, num_bicycles::30];
		save [time, car_avg_speed, bicycle_avg_speed, car_bicycle_avg_speed, traffic_density_per_km, car_bicycle_traffic_flow] to: "../output/simple_model/" + self.name + ".csv"
		format: "csv" rewrite: true;
	}

	reflex save_result {
		save [time, car_avg_speed, bicycle_avg_speed, car_bicycle_avg_speed, traffic_density_per_km, car_bicycle_traffic_flow] to: "../output/simple_model/" + self.name + ".csv"
		format: "csv" rewrite: false;
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

experiment cars_trucks_bicycles type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::30, num_trucks::30, num_bicycles::30];
		save [time, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow] to: "../output/simple_model/" + self.name + ".csv"
		format: "csv" rewrite: true;
	}

	reflex save_result {
		save [time, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow] to: "../output/simple_model/" + self.name + ".csv"
		format: "csv" rewrite: false;
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

experiment all_agents type: gui parent: base_experiment {

	action _init_ {
		create simulation with: [num_cars::30, num_trucks::30, num_bicycles::30, num_pedestrians::100];
		save [time, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow] to: "../output/simple_model/" + self.name + ".csv"
		format: "csv" rewrite: true;
	}

	reflex save_result {
		save [time, car_avg_speed, truck_avg_speed, bicycle_avg_speed, all_avg_speed, traffic_density_per_km, all_traffic_flow] to: "../output/simple_model/" + self.name + ".csv"
		format: "csv" rewrite: false;
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
