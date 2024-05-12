/**
* Name: gobal_vars_testing
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model gobal_vars_testing

global {
	// show numbers of objects
	bool show_intersection_numbers <- true;
	bool show_road_numbers <- true;
	bool show_footway_numbers <- true;
	bool show_crossing_numbers <- true;

	// show the circles that represent footway nodes
	bool show_footway_nodes <- false;
	
	// environment and simulation
	float step <- 0.2#s;
	float size_environment <- 300#m;
			
	// constants for building test environments
	float x_left_border <- 50.0;
	float x_right_border <- size_environment/2 + 100;
	float x_middle <- size_environment/2 ;
		
	float y_middle <- size_environment/2;
	float y_above_middle <- size_environment/2 - 5;
	float y_below_middle <- size_environment/2 + 5;
	
	float y_bottom_border <- size_environment - 50;
	float y_top_border  <- 50.0;
	
	// size of environment
	geometry shape <- square(size_environment);
}



