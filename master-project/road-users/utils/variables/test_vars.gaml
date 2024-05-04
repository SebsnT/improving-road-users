/**
* Name: testmodelsvars
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model testmodelsvars

global {
	// environment and simulation
	float step <- 0.2#s;
	float traffic_light_interval parameter: 'Traffic light interval' init: 30#s;
	float lane_width <- 1.0;
	float size_environment <- 300#m;
	
	//car
	float CAR_LENGTH <- 4.0#m;
	float CAR_WIDTH <- 2.0#m;
	float CAR_MAXSPEED <- 14 #m/#s;
	float CAR_ACCELERATION_RATE <- 3.4#m/#s;
	float CAR_DECELERATION_RATE <- 1.0#m/#s;
	float CAR_PROBA_BLOCK_NODE <- 1.0;
	
	//pedestrian
	float PEDESTRIAN_LENGTH <- 4.0#m;
	float PEDESTRIAN_WIDTH <- 2.0#m;
	float PEDESTRIAN_MAXSPEED <- 14 #m/#s;
	float PEDESTRIAN_ACCELERATION_RATE <- 3.4#m/#s;
	float PEDESTRIAN_DECELERATION_RATE <- 1.0#m/#s;
	
	//driver
	float COLLISION_AVOIDANCE_DURATION <- 0.7#s;
	float REACTION_TIME <- 1.8#s;
	
		
	// constants for building environment	
	float x_left_border <- 50.0;
	float x_right_border <- size_environment/2 + 100;
	float x_middle <- size_environment/2 ;
		
	float y_road <- size_environment/2;
	float y_above_road <- size_environment/2 - 5;
	float y_below_road <- size_environment/2 + 5;
	
	// size of environment
	geometry shape <- square(size_environment);
}



