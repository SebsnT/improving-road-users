/**
* Name: VehicleAdapter
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model VehicleAdapter

import "../models/Bicycle.gaml"
import "../models/Car.gaml"
import "../models/Pedestrian.gaml"
import "../models/Truck.gaml"

/* Insert your model definition here */

global
{
}


experiment Simple type: gui
{
	geometry shape <- square(100);
	list<bicycle> get_bicycle
	{
		return list(bicycle);
	}

	list<car> get_car
	{
		return list(car);
	}
	
	list<pedestrian> get_pedestrian
	{
		return list(pedestrian);
	}
	
	list<truck> get_truck
	{
		return list(truck);
	}

	//if we redefine the output, i.e, a blank output, the displays in parent experiment don't show.
	output
	{
	}

}