/**
* Name: SimpleFootways
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model SimpleFootways

global {
	bool show_numbers;
	bool show_footway_nodes;
}

species footway_node parent: graph_node edge_species: footway_edge{
	rgb color <- #blue;
	rgb label_color <- #white;

		 
	geometry shape <- circle (1);
	list<int> list_connected_index;
	string label;
		 
	bool related_to(footway_node other){
        if (list_connected_index contains (footway_node index_of other)) {
	    	return true;
		}
        return false;
    }
  		
	aspect base {
		
		if(show_footway_nodes) {
			draw shape color: #blue;
		}	
		
		if (show_numbers) {
			draw label color: label_color;
		}
	}
		
}
	
species footway_edge skills: [pedestrian_road] parent: base_edge {
	rgb color <- #black;
	bool is_crossing <- false;
  		
	aspect base {
		
		if(is_crossing){
			draw shape color: #red;
		} else {
			draw shape color: color;
		}
	}
}