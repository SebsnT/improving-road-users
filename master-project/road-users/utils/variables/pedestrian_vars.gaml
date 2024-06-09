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
	float WALKING_SPEED <- gauss(4, 1) #km / #h;
	float CROSSING_SPEED <- WALKING_SPEED * 1.1 #km / #h;
}

