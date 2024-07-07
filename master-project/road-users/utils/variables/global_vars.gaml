/**
* Name: global_vars
* Author: Sebastian
* Tags: 
*/


model global_vars

global {
	
	// show numbers of objects
	bool show_intersection_numbers <- false;
	bool show_road_numbers <- false;
	bool show_footway_numbers <- false;
	bool show_crossing_numbers <- false;
	bool measure_density <- false;
	bool despawn_vehicles <- true;

	// show the circles that represent footway nodes
	bool show_footway_nodes <- false;
	
	// environment and simulation
	float step <- 0.5#s;
	float size_environment <- 1#km;
	
	// declare name of shape file here
	string CITY <- "map";
	
	// shape file names
	shape_file NODES_SHAPE_FILE <- shape_file("../includes/"  + CITY + "/" + "nodes.shp");
	shape_file ROADS_SHAPE_FILE <- shape_file("../includes/"  + CITY + "/" + "roads.shp");
	shape_file FOOTWAY_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "footways.shp");
	shape_file BUILDING_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "buildings.shp");
	
	// size of environment
	geometry shape <- square(size_environment);
}


