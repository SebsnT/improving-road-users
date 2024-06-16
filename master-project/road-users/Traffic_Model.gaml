/**
* Name: TrafficModel
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model TrafficModel

import "./models/city/Footway.gaml"
import "./models/city/Building.gaml"
import "./models/Vehicles.gaml"
import "./models/Pedestrian.gaml"
import "./utils/variables/global_vars.gaml"

global {
	int num_cars;
	int num_trucks;
	int num_bicycles;
	int num_pedestrians;
	string city;
	geometry shape <- envelope(ROADS_SHAPE_FILE);
	graph road_network;
	graph footway_network;
	list<intersection> non_deadend_nodes;

	// for speed charts 
	// multiply with 3.6 to convert to km/h
	list<float> car_speed_list -> {car collect (each.speed * 3.6)}; // for speed chart
	list<float> truck_speed_list -> {truck collect (each.speed * 3.6)}; // for speed chart
	list<float> bicycles_speed_list -> {bicycle collect (each.speed * 3.6)}; // for speed chart
	list<float> pedestrian_speed_list -> {pedestrian collect (each.speed * 3.6)}; // for speed chart

	// calculate average speed
	float car_avg_speed -> {mean(car_speed_list)}; // average speed stats
	float truck_avg_speed -> {mean(truck_speed_list)}; // average speed stats
	float bicycle_avg_speed -> {mean(bicycles_speed_list)}; // average speed stats
	float pedestrian_avg_speed -> {mean(pedestrian_speed_list)}; // average speed stats
	init {
		write "Creating Roads";
		create road from: ROADS_SHAPE_FILE with: [num_lanes::int(read("lanes"))] {
		// Create another road in the opposite direction
			create road {
				num_lanes <- myself.num_lanes;
				shape <- polyline(reverse(myself.shape.points));
				maxspeed <- myself.maxspeed;
				linked_road <- myself;
				myself.linked_road <- self;
			}

		}

		write "Creating Intersections";
		create intersection from: NODES_SHAPE_FILE with: [is_traffic_signal::(read("type") = "traffic_signals"), traffic_signal_type::(read("type"))] {
		}

		// Initialize the traffic lights
		write "Creating Footways";
		create footway from: FOOTWAY_SHAPE_FILE;
		write "Creating Buildings";
		create building from: BUILDING_SHAPE_FILE;
		write "Creating Vehicles";
		create car number: num_cars with: (location: one_of(road).location);
		create truck number: num_trucks with: (location: one_of(road).location);
		create bicycle number: num_bicycles with: (location: one_of(road).location);
		write "Creating Pedestrians";
		create pedestrian number: num_pedestrians with: (location: one_of(footway).location);
	} }

experiment city type: gui {

	action _init_ {
		create simulation with: [city::CITY, num_cars::NUM_CARS, num_trucks::NUM_TRUCKS, num_bicycles::NUM_BICYCLES, num_pedestrians::NUM_PEDESTRIANS];
		ask intersection {
			do setup_env();
		}

	}

	output synchronized: true {
		display map type: 2d background: #grey {

		// Environment
			species road aspect: base;
			species intersection aspect: base;
			species footway aspect: base;
			species building aspect: base;

			// Agents
			species car aspect: base;
			species truck aspect: base;
			species bicycle aspect: base;
			species pedestrian aspect: base;
		}

		/* 
		display car_speed_chart type: 2d {
      		chart "Average speed" type: series size: {1, 1} position: {0, 0} x_label: "Cycle" y_label: "Average speed km/h" {
        	data "Car" value: car_avg_speed color: #red;
        	data "Truck" value: truck_avg_speed color: #blue;
        	data "Bicycle" value: bicycle_avg_speed color: #yellow;
        	data "Pedestrian" value: pedestrian_avg_speed color: #green;
      	}
    }
*/

/*   	
    	monitor "Average car speed" value: car_avg_speed with_precision 2 color: #red;
    	monitor "Average truck speed" value: truck_avg_speed with_precision 2 color: #blue;
    	monitor "Average bicycle speed" value: bicycle_avg_speed with_precision 2 color: #yellow;
    	monitor "Average pedestrian speed" value: pedestrian_avg_speed with_precision 2 color: #green;

 		monitor "Number of cars" value: num_cars;
		monitor "Number of trucks" value: num_trucks;
		monitor "Number of bicycles" value: num_bicycles;
		monitor "Number of pedestrians" value: num_pedestrians;
*/
	}

}


