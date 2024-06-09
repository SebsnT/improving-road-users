/**
* Name: vehicle_vars
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/
model vehicle_vars

global {

// Number of agents used 
	int NUM_CARS <- 10;
	int NUM_TRUCKS <- 10;
	int NUM_BICYCLES <- 10;
	int NUM_PEDESTRIANS <- 10;

	// right or left side driving
	bool RIGHT_SIDE_DRIVING <- true;
	int LANE_WIDTH <- 1;

	// fuel type percentage
	//float petrol <- 0.5;
	//float diesel <- 0.5;

	// Min distances
	float MIN_SAFETY_DISTANCE <- 2 #m;
	float MIN_SECURITY_DISTANCE <- 2 #m;

	// Probabilites to respect norms
	float POLITENESS_FACTOR <- 0.95;
	float PROBA_RESPECT_PRIORITIES <- 0.95;
	list<float> PROBA_RESPECT_STOPS <- [0.95];
	float TIME_HEADWAY <- 1 #s;

	// Percentage that drivers are willing to drive over the speed limit (1.1 means 10 percent)
	float SPEED_COEFF <- 1.10;
	// -------------------------------------------------------
	//car
	int CAR_LANE_OCCUPIED <- 1;
	float CAR_MAXSPEED <- 70 #km / #h;

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
	float CAR_PROBA_BLOCK_NODE <- 1.0;
	// -------------------------------------------------------
	//bicycle
	int BICYCLES_LANE_OCCUPIED <- 1;
	float BICYCLE_LENGTH <- 1.75 #m;

	// min and max speed
	float BICYCLE_MIN_SPEED <- 10 #km / #h;
	float BICYCLE_MAX_SPEED <- 30 #km / #h;

	// acceleration
	float BICYCLE_MIN_ACCLERATION <- 0.8 #m / #s;
	float BICYCLE_MAX_ACCLERATION <- 1.2 #m / #s;

	// deceleration
	float BICYCLE_MIN_DECELERATION_RATE <- 1.5 #m / #s;
	float BICYCLE_MAX_DECELERATION_RATE <- 2.0 #m / #s;
	// -------------------------------------------------------
	//truck
	int TRUCK_LANE_OCCUPIED <- 1;
	float TRUCK_POWER_DRIVE_LENGTH <- 12.0 #m;
	float TRUCK_POWER_HEAVY_TRAILER <- 25.25 #m;
	float TRUCK_MAXSPEED <- 70 #km / #h;
	float TRUCK_ACCELERATION_RATE <- 1 #m / #s;
	float TRUCK_DECELERATION_RATE <- 0.875 #m / #s;
}
	

