/**
* Name: RoadAgents
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model SimpleAgents

global {
	graph pedestrian_network;
	
	init {
		pedestrian_network <- as_edge_graph(footway_edge);
	}

}

species footway_node parent: graph_node edge_species: footway_edge{
	rgb color <- #black;
	// rgb label_color <- #white;
		 
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
		//draw number color: label_color;
	}
		
}
	
species footway_edge skills: [pedestrian_road] parent: base_edge {
	rgb color <- #red;
  		
	aspect base {	
		draw shape color: color;
	}
}
	
species pedestrian skills:[moving]{
		
	point target;
	rgb color <- #green;
	int staying_counter;
	
	
	reflex new_target when: target = nil {
	target <- any_location_in (one_of(footway_edge));
		
	}
	
	
	reflex move when: target != nil{
		do goto target: target on: pedestrian_network;
		if (location = target) {
			target <- nil;
		} 
	}
	
	//TODO calculate critical gap
	
	//TODO unmarked crossings
	 
	//TODO jaywalk
	/*
	 * get opposite edge
	 * make target opposite edge
	 * set heading 90 degrees
	 * move to target
	 * set target nil
	 */
	 
	 //TODO marked crossings (not important -> traffic lights)
	 
	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;	
	}
}
	


