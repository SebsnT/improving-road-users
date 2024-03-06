/**
* Name: Intersection
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Intersection

species intersection skills: [intersection_skill] {
	bool is_traffic_signal;
	float time_to_change <- 30#s;
}


