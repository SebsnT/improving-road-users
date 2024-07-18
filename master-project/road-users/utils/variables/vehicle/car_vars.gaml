/**
* Name: car_vars
* Author: Sebastian
* Tags: 
*/
model car_vars

global {
	int CAR_LANE_OCCUPIED <- 2;
	float CAR_MAXSPEED <- 100 #km / #h;

	// length
 	float CAR_MIN_LENGTH <- 4.0 #m;
	float CAR_MAX_LENGTH <- 5.0 #m;

	// average acceleration rate
 	float CAR_ACCELERATION_RATE <- 2.55 #m / #s;

	// acceleration for petrol and diesel cars 
	float CAR_ACCELERATION_PETROL <- 2.23 #m / #s;
	float CAR_ACCELERATION_DIESEL <- 2.87 #m / #s;

	// deceleration for petrol and diesel cars 
 	float CAR_DECELERATION_PETROL <- 3.88 #m / #s;
	float CAR_DECELERATION_DIESEL <- 4.53 #m / #s;

	// average deceleration
 	float CAR_DECELERATION_RATE <- 4.2 #m / #s;
}

