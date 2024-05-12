/**
* Name: Simple_Pedestrians
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Simple_Pedestrians

import "./Simple_Road.gaml"

import "../utils/variables/pedestrian_vars.gaml"


global {
	graph pedestrian_network;
	
	bool show_footway_nodes;
	
	int number_of_footway <-0;
	
	init {
		pedestrian_network <- as_edge_graph(footway_edge);
	}

}
	
species pedestrian skills:[moving]{
	rgb color <- #green;
	
	point target;
	int staying_counter;
	bool is_crossing;
	
	init {
		speed <- WALKING_SPEED;
	}
	
	reflex new_target when: target = nil {
		target <- any_location_in (one_of(footway_edge));	
	}
	
	// TODO implement that pedestrian stops shortly before crossing
	
	
	// cross road with higher speed
	reflex cross_road when: footway_edge(current_edge) != nil and footway_edge(current_edge).intersects_with_crossing != nil and is_crossing = false {
	 	is_crossing <- true;
	 	do set_speed_for_crossing();
	}
	
	// reset speed once road is_crossed
	reflex reset_speed when: footway_edge(current_edge) != nil and footway_edge(current_edge).intersects_with_crossing = nil and is_crossing = true{
		is_crossing <- false;
		do set_speed_for_walking();
	}
	
	
	// setters
	action set_speed_for_crossing {
	 	speed <- CROSSING_SPEED;
	}
	
	action set_speed_for_walking {
	 	speed <- WALKING_SPEED;
	}
	
	/* 
	reflex block_edge {
		if(current_edge != nil){
			if not(footway_edge(current_edge).agents_on contains self ){
				footway_edge(current_edge).agents_on <- footway_edge(current_edge).agents_on + self;
			}
		}
	}
	*/
	
	reflex move when: target != nil{
		do wander on: pedestrian_network;
		if (location = target) {
			target <- nil;
		}
	}
	 
	action jaywalk {
	/*
	 * get opposite edge
	 * make target opposite edge
	 * set heading 90 degrees
	 * move to target
	 * set target nil
	 */
	}
	
	
	//TODO calculate critical gap
	
	
	 
	aspect base {
		draw triangle(1.0) color: color rotate: heading + 90 border: #black;	
	}
}

species footway_node parent: graph_node edge_species: footway_edge{
	rgb color <- #blue;
	rgb label_color <- #white;

		 
	geometry shape <- circle (1);
	list<int> list_connected_index;
	string number;
	
	init {
		number <- string(number_of_footway);
		number_of_footway <- number_of_footway + 1; 
	}
		 
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
		
		if (show_footway_nodes) {
			draw number color: label_color;
		}
	}	
}
	
species footway_edge skills: [pedestrian_road] parent: base_edge {
	rgb color <- #black;
	
	rgb occupied_color <- #red;
	
	bool is_occupied <- false;
	intersection intersects_with_crossing;
	
	reflex update_agents_on {
		agents_on <- pedestrian where (each.current_edge = self);
	}
	
	reflex block_node {
		if(agents_on != []){
			is_occupied <- true;
			
			if(intersects_with_crossing != nil){
				ask intersection(intersects_with_crossing){
					do block_roads_in();
				}
			}
			
		} else {
			is_occupied <- false;
			if(intersects_with_crossing != nil){
				ask intersection(intersects_with_crossing){
					do unblock_road();
				}
			}
		}
	}
	 
	
	
	aspect base {
		if(is_occupied){
			draw shape color: occupied_color;
		} else {
			draw shape color: color;
		}
	}
}
	


