/**
* Name: SimpleExperiments
* Author: Sebastian
* Tags: 
*/
model SimpleExperiments

import "./Simpel_Model.gaml"


global {
	
	bool cars_batch <- false;
	bool trucks_batch <- false;
	bool bicycles_batch <- false;

	// --------------------------
	// Traffic density
	// --------------------------
	float traffic_densiy_percentage -> {mean(road collect (each.traffic_density_percentage))};
	float traffic_density_per_km -> {sum(road collect (each.traffic_density_per_km))};

	// --------------------------
	// Average Speed
	// multiply with 3.6 to convert to km/h
	// --------------------------

	// Single agent average speeds
	float car_avg_speed -> {mean(car collect (each.speed * 3.6))}; // average speed stats
	float truck_avg_speed -> {mean(truck collect (each.speed * 3.6))}; // average speed stats
	float bicycle_avg_speed -> {mean(bicycle collect (each.speed * 3.6))}; // average speed stats
	float pedestrian_avg_speed -> {mean(pedestrian collect (each.speed * 3.6))}; // average speed stats

	// Mixed agents average speed
	float car_truck_avg_speed -> mean([car_avg_speed, truck_avg_speed]);
	float car_bicycle_avg_speed -> mean([car_avg_speed, bicycle_avg_speed]);
	float truck_bicycle_avg_speed -> mean([truck_avg_speed, bicycle_avg_speed]);

	// All agents average speed
	float all_avg_speed -> mean([car_avg_speed, truck_avg_speed, bicycle_avg_speed]);

	// --------------------------
	// Traffic flow
	// --------------------------

	// Single traffic flow
	float car_traffic_flow -> traffic_density_per_km * car_avg_speed;
	float truck_traffic_flow -> traffic_density_per_km * truck_avg_speed;
	float bicycle_traffic_flow -> traffic_density_per_km * bicycle_avg_speed;

	// Mixed traffic flow
	float car_truck_traffic_flow -> traffic_density_per_km * car_truck_avg_speed;
	float car_bicycle_traffic_flow -> traffic_density_per_km * car_bicycle_avg_speed;
	float truck_bicycle_traffic_flow -> traffic_density_per_km * truck_bicycle_avg_speed;

	// All traffic flow
	float all_traffic_flow -> traffic_density_per_km * all_avg_speed;

	reflex stop when: cycle = 1000 {
		do pause;
	}

}

experiment base_experiment type: gui virtual:true {
	
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

		display Vehicle_Exit type: 2d {
			chart "Absolute Number of vehicles exited" type: histogram size: {1, 1} position: {0, 0} x_label: "Types of Vehicles" y_label: "Number of Vehicles exited" {
				data "Cars" value: num_cars_exiting color: #red;
				data "Trucks" value: num_trucks_exiting color: #blue;
				data "Bicycles" value: num_bicycles_exiting color: #yellow;
				data "All" value: num_all_exiting color: #orange;
			}

		}

	}

}




