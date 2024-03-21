/**
* Name: CityAdapter
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model CityAdapter

import "../models/Road.gaml"
import "../models/Intersection.gaml"
import "../models/Footway.gaml"

global
{
	graph road_network;
	init{
		road_network <- as_driving_graph(road, intersection);
	}
	
}


experiment Simple type: gui
{
	geometry shape <- square(100);
	list<intersection> get_intersection
	{
		return list(intersection);
	}

	list<road> get_road
	{
		return list(road);
	}
	
	list<footway> get_footway
	{
		return list(footway);
	}

	output
	{
	}

}
