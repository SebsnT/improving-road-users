/**
* Name: TrafficModel
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/




model TrafficModel

import "./adapters/CityAdapter.gaml"
import "./adapters/VehicleAdapter.gaml"


global {
	
	string city <- "graz2";
	
	int num_cars <- 100;
	int num_trucks <- 10;
	int num_bicycles <- 100;
	int num_pedestrians <- 100;
	
	float traffic_light_interval parameter: 'Traffic light interval' init: 30#s;
	float step <- 0.2#s;
	
	shape_file nodes_shape_file <- shape_file("includes/" + city + "/" + "nodes.shp");
	shape_file roads_shape_file <- shape_file("includes/" + city + "/" + "roads.shp");
	shape_file footway_shape_file <- shape_file("includes/" + city + "/" + "footways.shp");
	
	geometry shape <- envelope(roads_shape_file);
	graph road_network;
	list<intersection> non_deadend_nodes;
	init {
		
		write "Creating Roads";
		
		create road from: roads_shape_file with: [num_lanes::int(read("lanes"))] {
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
		
		create intersection from: nodes_shape_file 
			with: [is_traffic_signal::(read("type") = "traffic_signals"), traffic_signal_type::(read("type"))] {
			time_to_change <- traffic_light_interval;
		}
		
		
		

		// Create a graph representing the road network, with road lengths as weights
		map edge_weights <- road as_map (each::each.shape.perimeter);
		road_network <- as_driving_graph(road, intersection) with_weights edge_weights;
		
		
		
		
		// Initialize the traffic lights
		ask intersection {
			do initialize;
		}
		
		write "Creating Footways";
	
		create footway from: footway_shape_file;
		
		
		write "Creating Vehicles";
			
		create car number: num_cars with: (location: one_of(road).location);
		create truck number: num_trucks with: (location: one_of(road).location);
		create bicycle number: num_bicycles with: (location: one_of(road).location);
		
		write "Creating Pedestrians";
		create pedestrian number: num_pedestrians with: (location: one_of(footway).location);
	}

}

experiment city type: gui {
	output synchronized: true {
		display map type: 2d background: #grey {
			
			// Environment
			species road aspect: base;
			species intersection aspect: base;
			species footway aspect: base;
			
			// Agents
			species car aspect: base;
			species truck aspect: base;
			species bicycle aspect: base;	
			species pedestrian aspect: base;
			}
	}
}


