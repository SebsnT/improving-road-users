/**
* Name: pedestrianvars
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model pedestrian_vars

global {

	//pedestrian
 	float PEDESTRIAN_LENGTH <- 0.5 #m;
	float PEDESTRIAN_WIDTH <- 0.5 #m;
	
	// time pedestrians wait before crossing
	float MIN_CROSSING_WAITING_TIME <- 0.0;
	float MAX_CROSSING_WAITING_TIME <- 20.0;
}

