/**
* Name: RoadAgents
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model RoadAgents

import "../models/city/Road.gaml"


global {

}

species footway_node parent: graph_node edge_species: footway_edge{
		 rgb color <- #black;
		 rgb label_color <- #white;
		 
		 geometry shape <- circle (1);
		 list<int> list_connected_index;
		 string number;
		 
		 bool related_to(footway_node other){
        	if (list_connected_index contains (footway_node index_of other)) {
	    		return true;
			}
        	return false;
    	}
  		
		aspect base {	
			draw shape color: color;
			draw number color: label_color;
		}
		
	}
	
	species footway_edge skills: [pedestrian_road] parent: base_edge {
		 rgb color <- #red;
		 int number;
  		
		aspect base {	
			draw shape color: color;
		}
	}
	


