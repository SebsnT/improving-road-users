/**
* Name: TrafficModel
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/




model TrafficModel

import "./adapters/CityAdapter.gaml"

import "./adapters/VehicleAdapter.gaml"



/* Insert your model definition here */

global {
	
	string city <- "graz2";
	
	int num_cars <- 100;

	int num_trucks <- 10;
	
	int num_bicycles <- 100;
	
	
	float traffic_light_interval parameter: 'Traffic light interval' init: 60#s;
	
	shape_file nodes_shape_file <- shape_file("includes/" + city + "_nodes.shp");
	shape_file roads_shape_file <- shape_file("includes/" + city + "_roads.shp");
	shape_file footway_shape_file <- shape_file("includes/" + city + "_footways.shp");
	
	geometry shape <- envelope(roads_shape_file);
	graph road_network;
	init {
		create intersection from: nodes_shape_file;
		
			
		create road from: roads_shape_file {
			// Create another road in the opposite direction
			create road {
				num_lanes <- myself.num_lanes;
				shape <- polyline(reverse(myself.shape.points));
				maxspeed <- myself.maxspeed;
				linked_road <- myself;
				myself.linked_road <- self;
			}
		}
		
		road_network <- as_driving_graph(road, intersection);
		
		//create footway from: footway_shape_file {}
		
		
		create car number: num_cars with: (location: one_of(intersection).location);
		create truck number: num_trucks with: (location: one_of(road).location);
		create bicycle number: num_bicycles with: (location: one_of(road).location);
	}

}

experiment city type: gui {
	output synchronized: true {
		display map type: 2d background: #gray {
			species road aspect: base;
			species car aspect: base;
			species truck aspect: base;
			species bicycle aspect: base;		
			}
	}
}


