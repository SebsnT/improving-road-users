/**
* Name: globalvars
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model global_vars

global {
	
	// environment and simulation
	float step <- 0.2#s;
	float traffic_light_interval parameter: 'Traffic light interval' init: 30#s;
	float lane_width <- 1.0;
	float size_environment <- 1#km;
	
	// declare name of shape file here
	string CITY <- "graz2";
	
	// shape file names
	shape_file NODES_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "nodes.shp");
	shape_file ROADS_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "roads.shp");
	shape_file FOOTWAY_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "footways.shp");
	shape_file BUILDING_SHAPE_FILE <- shape_file("../includes/" + CITY + "/" + "buildings.shp");
	
	int NUM_CARS <- 10;
	int NUM_TRUCKS <- 10;
	int NUM_BICYCLES <- 10;
	int NUM_PEDESTRIANS <- 10;
	
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
	float CAR_PROBA_BLOCK_NODE <- 1.0; 
	
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


