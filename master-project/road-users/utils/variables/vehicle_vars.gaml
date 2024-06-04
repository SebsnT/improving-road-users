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
	
	// Min distances
	float MIN_SAFETY_DISTANCE <- 2 #m;
	float MIN_SECURITY_DISTANCE <- 2#m;
	
	// Probabilites to respect norms
	float POLITENESS_FACTOR <- 0.95;
	float PROBA_RESPECT_PRIORITIES <- 0.95;
	list<float> PROBA_RESPECT_STOPS <- [0.95];
	float TIME_HEADWAY <- 1#s;
	
	// Percentage that drivers are willing to drive over the speed limit (1.1 means 10 percent)
	float SPEED_COEFF <- 1.10;
	
	//car
	int CAR_LANE_OCCUPIED <- 1;
	float CAR_LENGTH <- 4.5 #m;
	float CAR_MAXSPEED <- 70 #km/#h;
	float CAR_ACCELERATION_RATE <- 2.55 #m/#s;
	float CAR_DECELERATION_RATE <- 4.2 #m/#s;
	float CAR_PROBA_BLOCK_NODE <- 1.0; 
	
	//bicycle
	int BICYCLES_LANE_OCCUPIED <- 1;
	float BICYCLE_LENGTH <- 1.73 #m;
	float BICYCLE_MAXSPEED <- 25 #km/#h;
	float BICYCLE_ACCELERATION_RATE <- 0.5 #m/#s;
	float BICYCLE_DECELERATION_RATE <- 5.0 #m/#s;
	
	//truck
	int TRUCK_LANE_OCCUPIED <- 1;
	float TRUCK_LENGTH <- 13.0 #m;
	float TRUCK_MAXSPEED <- 70 #km/#h;
	float TRUCK_ACCELERATION_RATE <- 1 #m/#s;
	float TRUCK_DECELERATION_RATE <- 0.875 #m/#s;
}

//car
	

