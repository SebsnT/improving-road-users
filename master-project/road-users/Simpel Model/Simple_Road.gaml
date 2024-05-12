/**
* Name: Simpel_Road
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Simpel_Road

import "../utils/variables/road_vars.gaml"

global {
	
	list<intersection> end_nodes;
	list<intersection> spawn_nodes;
	
	// bool to show number of objects
	bool show_road_numbers;
	bool show_intersection_numbers;
	
	// bool to keep track of number of objects
	int number_of_road <- 0;
	int number_of_intersection <-0;
}



species road skills: [road_skill] {
	rgb color <- #white;
	rgb label_color <- #red;
	
	string oneway;
	string number;
	
	init {
		number <- string(number_of_road);
		number_of_road <- number_of_road + 1; 
	}

	aspect base {
		draw shape color: color end_arrow: 1;
		if(show_road_numbers) {
			draw number color:label_color font:font("Helvetica", 15 , #plain);
		}
	}
}



species intersection skills: [intersection_skill] {
	rgb color;
	rgb label_color <- #black;
	font label_font <- font("Helvetica", 20 , #plain);
	string number;
	
	bool is_traffic_signal;
	bool is_connected_to_traffic_signal <- false;
	string traffic_signal_type;
	
	float time_to_change <- TRAFFIC_LIGHT_INTERVAL;
	float counter <- rnd(time_to_change);
	
	list<road> ways1;
	list<road> ways2;
	
	bool is_green;
	rgb traffic_light_color;
	rgb opposite_color;
	
	list<intersection> connected_nodes;
	
	list<intersection> adjacent_street_signs;
	
	list<road> adjacent_street_signs_roads;
	
	intersection connected_to_traffic_signal;
	
	
	init {
		number <- string(number_of_intersection);
		number_of_intersection <- number_of_intersection + 1; 
	}


	action initialize {
		if (traffic_signal_type = "traffic_signals") {
			do compute_crossing;
			stop << [];
			if (flip(0.5)) {
				do to_green;
			} else {
				do to_red;
			}
		}
		
	}
	
	action block_roads_in {
		stop <- stop + roads_in;
	}
	
	action unblock_road {
		stop <- [];
	}
	
	/* 
	action initialize_connected_nodes {
		
		loop c over: connected_nodes {
			//c.color <- #green;
		}
		
		
		loop s over:stop[0] {
			intersection stop_intersection <- intersection(road(s).source_node);
			stop_intersection.color <-  self.traffic_light_color;
		}
	}
	*/
	
	// creates points used for reference of stopping before intersection
	action get_connected_intersections {
			
			// loop over all roads
			loop r over:roads_in + roads_out {
				intersection source_node <- intersection(road(r).source_node);
				intersection target_node <- intersection(road(r).target_node);
				
				if(!(connected_nodes contains source_node) and source_node != self){
					connected_nodes <- connected_nodes + source_node;
					source_node.connected_to_traffic_signal <- self;
					source_node.is_connected_to_traffic_signal <- true;
				} 
				
				 if(!(connected_nodes contains target_node) and target_node != self){
					connected_nodes <- connected_nodes + target_node;
					target_node.connected_to_traffic_signal <- self;
					target_node.is_connected_to_traffic_signal <- true;
				}
			}
		
	}
	
	action set_adjacent_street_signs {
		loop i over:connected_nodes {
			string type_of_intersection <- intersection(i).traffic_signal_type;
			if(type_of_intersection = "give_way" or type_of_intersection = "stop"){
				adjacent_street_signs <- adjacent_street_signs + intersection(i);
			}
		}
	}
	
	action set_adjacent_street_signs_roads {
		loop i over: adjacent_street_signs {
				loop j over: (intersection(i).roads_in  + intersection(i).roads_out) {
					if not (adjacent_street_signs_roads contains road(j)) and (road(j).target_node = self or road(j).source_node = self){
						adjacent_street_signs_roads <- adjacent_street_signs_roads + road(j);
					}
				}
			}
	}
	
	action set_priority_roads {
		do get_connected_intersections();
		do set_adjacent_street_signs();
		do set_adjacent_street_signs_roads();
		
		if(adjacent_street_signs != []){	
			loop r over: roads_in + roads_out{
				if not (adjacent_street_signs_roads contains road(r)){
					priority_roads <- priority_roads + road(r);
				}

			}
		}
	}
	
	
	
	action declare_end_nodes (list<intersection> nodes){
		end_nodes <- nodes;
	}
	
	action declare_spawn_nodes (list<intersection> nodes){
		spawn_nodes <- nodes;
	}

	action compute_crossing {
		if (length(roads_in) >= 2) {
			road rd0 <- road(roads_in[0]);
			list<point> pts <- rd0.shape.points;
			float ref_angle <- last(pts) direction_to rd0.location;
			loop rd over: roads_in {
				list<point> pts2 <- road(rd).shape.points;
				float angle_dest <- last(pts2) direction_to rd.location;
				float ang <- abs(angle_dest - ref_angle);
				if (ang > 45 and ang < 135) or (ang > 225 and ang < 315) {
					ways2 << road(rd);
				}
			}
		}

		loop rd over: roads_in {
			if not (rd in ways2) {
				ways1 << road(rd);
			}
		}
	}
	
	
	action to_green {
		stop[0] <- ways2;
		traffic_light_color <- #green;
		opposite_color <- #red;
		is_green <- true;
	}

	action to_red {
		stop[0] <- ways1;
		traffic_light_color <- #red;
		opposite_color <- #green;
		is_green <- false;
	}

	reflex dynamic_node when: traffic_signal_type = "traffic_signals"{
		counter <- counter + step;
		if (counter >= time_to_change) {
			counter <- 0.0;
			stop[0] <-empty(stop[0])? roads_in : [];
			if is_green {
				do to_red;
			} else {
				do to_green;
			}
		}
	}
	
	reflex related_node when: connected_to_traffic_signal != nil  {
		//color <- intersection(connected_to_traffic_signal).traffic_light_color;
	}
	
	reflex cross_road {
		
	}
	
	 //TODO crossing reflex
	 
	 
	 //TODO give_way reflex
	 
	 
	 //TODO stop reflex
	 

	aspect base {
		if (is_traffic_signal) {
			draw circle(1) color: traffic_light_color;			
		
			//draw circle(1) color: color_fire;
		} else {
			draw circle(1) color: color;
		}
		
		switch traffic_signal_type { 
        	//match "crossing" {draw circle(1) color:#black;}
        	match "give_way" {draw triangle(3) color:#red;} 
        	match "stop" {draw hexagon(3) color:#red;} 
        	match "bus_stop" {draw circle(1) color:#white;} 
			match "" {draw circle(1) color:#white;} 
		}
	}
	
	aspect simple {
		if (is_traffic_signal and traffic_signal_type ="traffic_signals") {
			
			// left
			draw circle(1) color: traffic_light_color at:{location.x - 8, location.y + 3};
			
			//right
			draw circle(1) color: traffic_light_color at:{location.x + 8, location.y - 3};	
			
			
			// bottom
			draw circle(1) color: opposite_color at:{location.x + 3, location.y + 8};
			
			// top
			draw circle(1) color: opposite_color at:{location.x - 3, location.y - 8};	
			
			if(show_intersection_numbers) {
				draw number color: label_color font:label_font ;
			}
		} else {
			draw circle(1) color: color;
			if(show_intersection_numbers) {
				draw number color: label_color font:label_font;
			}
		}
		
		switch traffic_signal_type { 
        	//match "crossing" {draw circle(1) color:#black;}
        	match "give_way" {draw triangle(3) color:#red;} 
        	match "stop" {draw hexagon(3) color:#red;} 
        	match "bus_stop" {draw circle(1) color:#white;} 
			match "" {draw circle(1) color:#white;} 
		}
	}
}




