/**
* Name: globalvars
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model global_vars

global {
	//bicycle
	float BICYCLE_LENGTH <- 1.9#m;
	float BICYCLE_WIDTH <- 0.7#m;
	float BICYCLE__MAXSPEED <- 11#m/#s;
	float BICYCLE__ACCELERATION_RATE <- 3.4#m/#s;
	float BICYCLE_E_DECELERATION_RATE <- 2.9#m/#s;
	
	//car
	float CAR_LENGTH <- 4.0#m;
	float CAR_WIDTH <- 2.0#m;
	float CAR_MAXSPEED <- 14 #m/#s;
	float CAR_ACCELERATION_RATE <- 3.4#m/#s;
	float CAR_DECELERATION_RATE <- 1.0#m/#s;
	
	//truck
	float TRUCK_LENGTH <- 4.0#m;
	float TRUCK_WIDTH <- 2.0#m;
	float TRUCK_MAXSPEED <- 14 #m/#s;
	float TRUCK_ACCELERATION_RATE <- 3.4#m/#s;
	float TRUCK_DECELERATION_RATE <- 1.0#m/#s;
	
	//pedestrian
	float PEDESTRIAN_LENGTH <- 4.0#m;
	float PEDESTRIAN_WIDTH <- 2.0#m;
	float PEDESTRIAN_MAXSPEED <- 14 #m/#s;
	float PEDESTRIAN_ACCELERATION_RATE <- 3.4#m/#s;
	float PEDESTRIAN_DECELERATION_RATE <- 1.0#m/#s;
	
	//driver
	float COLLISION_AVOIDANCE_DURATION <- 0.7#s;
	float REACTION_TIME <- 1.8#s;
	
}

