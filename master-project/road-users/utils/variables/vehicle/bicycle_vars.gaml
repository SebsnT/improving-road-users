/**
* Name: bicycle_vars
* Author: Sebastian
* Tags: 
*/


model bicycle_vars

global {
	int BICYCLES_LANE_OCCUPIED <- 1;
	
	// length
	float BICYCLE_MIN_LENGTH <- 1.70 #m;
	float BICYCLE_MAX_LENGTH <- 1.80 #m;

	// min and max speed
	float BICYCLE_MIN_SPEED <- 10 #km / #h;
	float BICYCLE_MAX_SPEED <- 30 #km / #h;

	// acceleration
	float BICYCLE_MIN_ACCLERATION <- 0.8 #m / #s;
	float BICYCLE_MAX_ACCLERATION <- 1.2 #m / #s;

	// deceleration
	float BICYCLE_MIN_DECELERATION <- 1.5 #m / #s;
	float BICYCLE_MAX_DECELERATION <- 2.0 #m / #s;
}

