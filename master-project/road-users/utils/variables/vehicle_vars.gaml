/**
* Name: vehicle_vars
* Author: Sebastian
* Tags: 
*/
model vehicle_vars

import "./vehicle/bicycle_vars.gaml"
import "./vehicle/car_vars.gaml"
import "./vehicle/truck_vars.gaml"

global {

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
	list<float> PROBA_RESPECT_STOPS <- [0.95,0.95,0.95,0.95,0.95];
	float TIME_HEADWAY <- 3 #s;

	// Percentage that drivers are willing to drive over the speed limit (1.1 means 10 percent)
	float MAX_SPEED_COEFF <- 1.10;
	float MIN_SPEED_COEFF <- 0.90;

	
}
	

