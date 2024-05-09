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
	
	// Min distances
	float MIN_SAFETY_DISTANCE <- 1.5 #m;
	float MIN_SECURITY_DISTANCE <- 1.5#m;
	
	// Probabilites to respect norms
	float PROBA_RESPECT_PRIORITIES <- 1.0;
	list<float> PROBA_RESPECT_STOPS <- [1.0,1.0,1.0,1.0,1.0,1.0,1.0];
	
	// Percentage 
	float SPEED_COEFF <- 1.1;
	
	//car
	int CAR_LANE_OCCUPIED <- 1;
	float CAR_LENGTH <- 4.0#m;
	float CAR_MAXSPEED <- 100 #km/#h;
	float CAR_ACCELERATION_RATE <- 3.4 #km/#h;
	float CAR_DECELERATION_RATE <- 1.0 #km/#h;
	float CAR_PROBA_BLOCK_NODE <- 1.0; 
	
	//bicycle
	int BICYCLES_LANE_OCCUPIED <- 1;
	float BICYCLE_LENGTH <- 1.9 #m;
	float BICYCLE_MAXSPEED <- 25 #km/#h;
	float BICYCLE_ACCELERATION_RATE <- 3.4 #km/#h;
	float BICYCLE_DECELERATION_RATE <- 2.9 #km/#h;
	
	//truck
	int TRUCK_LANE_OCCUPIED <- 1;
	float TRUCK_LENGTH <- 4.0 #m;
	float TRUCK_WIDTH <- 2.0 #m;
	float TRUCK_MAXSPEED <- 100 #km/#h;
	float TRUCK_ACCELERATION_RATE <- 3.4 #km/#h;
	float TRUCK_DECELERATION_RATE <- 1.0 #km/#h;
}

//car
	

