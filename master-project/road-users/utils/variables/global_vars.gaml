/**
* Name: global_vars
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model global_vars

global {
	
	// environment and simulation
	float step <- 0.2#s;
	float size_environment <- 1#km;
	
	// declare name of shape file here
	string CITY <- "graz2";
	
	// shape file names
	shape_file NODES_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "nodes.shp");
	shape_file ROADS_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "roads.shp");
	shape_file FOOTWAY_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "footways.shp");
	shape_file BUILDING_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "buildings.shp");
	
	// size of environment
	geometry shape <- square(size_environment);
}


