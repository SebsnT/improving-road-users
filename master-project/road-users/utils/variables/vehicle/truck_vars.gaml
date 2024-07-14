/**
* Name: truck_vars
* Author: Sebastian
* Tags: 
*/
model truck_vars

global {
	int TRUCK_LANE_OCCUPIED <- 2;
	float TRUCK_MAXSPEED <- 100 #km / #h;

	// length
	float TRUCK_POWER_DRIVE_LENGTH <- 12.0 #m;
	float TRUCK_POWER_HEAVY_TRAILER <- 25.25 #m;

	// average acceleration rate
 	float TRUCK_ACCELERATION_RATE <- 1 #m / #s;

	// deceleration
	float TRUCK_DECELERATION_RATE <- 0.875 #m / #s;
}

