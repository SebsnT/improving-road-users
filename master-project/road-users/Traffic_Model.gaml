/**
* Name: TrafficModel
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/




model TrafficModel

import "./models/city/CityAdapter.gaml"

import "./models/vehicles/VehicleAdapter.gaml"



/* Insert your model definition here */

global {
	
	string city <- "graz";
	
	int num_cars <- 100;
	
	shape_file nodes_shape_file <- shape_file("includes/" + city + "_nodes.shp");
	shape_file roads_shape_file <- shape_file("includes/" + city + "_roads.shp");
	
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
		
		
		create car number: num_cars with: (location: one_of(intersection).location);
	}

}

experiment city type: gui {
	output synchronized: true {
		display map type: 3d background: #gray {
			species road aspect: base;
			species car aspect: base;		}
	}
}


