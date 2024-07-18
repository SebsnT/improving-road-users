/**
* Name: gobal_vars_testing
* Author: Sebastian
* Tags: 
*/
model gobal_vars_testing

global {
	int NUM_CARS_TESTING <- 50;
	int NUM_TRUCKS_TESTING <- 50;
	int NUM_BICYCLES_TESTING <- 50;
	int NUM_PEDESTRIANS_TESTING <- 50;
	
	int NUM_PEDESTRIANS_SIMPLE <- 200;

	// bools for showing testing information
 	bool show_intersection_numbers <- false;
	bool show_footway_nodes <- false;
	bool show_footway_edges_numbers <- false;
	bool show_footway_numbers <- false;
	bool show_road_numbers <- false;
	bool show_crossing_numbers <- false;

	// measure density or not
 	bool measure_density <- false;

	// can be deactivated to stop vehicles from despawning
 	bool despawn_vehicles <- true;

	// environment and simulation
	float step <- 0.5 #s;
	float size_environment <- 500 #m;

	// constants for building test environments
	float x_left_border <- 50.0;
	float x_right_border <- size_environment / 2 + 200;
	float x_middle <- size_environment / 2;
	float y_middle <- size_environment / 2;
	float y_above_middle <- size_environment / 2 - 5;
	float y_below_middle <- size_environment / 2 + 5;
	float y_bottom_border <- size_environment - 50;
	float y_top_border <- 50.0;

	// size of environment
	geometry shape <- square(size_environment);
}



