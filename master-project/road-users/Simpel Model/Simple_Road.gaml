/**
* Name: Simpel_Road
* Based on the internal empty template. 
* Author: Sebastian
* Tags: 
*/


model Simpel_Road

global {
	list<intersection> non_deadend_nodes;
	
	list<intersection> end_nodes;
	list<intersection> spawn_nodes;
	
	bool show_numbers;
}

species road skills: [road_skill] {
	rgb color <- #white;
	string oneway;
	string number;

	aspect base {
		draw shape color: color end_arrow: 1;
		if(show_numbers) {
			draw number color:#red;
		}
	}
}

species intersection skills: [intersection_skill] {
	rgb color;
	string number;
	
	bool is_traffic_signal;
	string traffic_signal_type;
	
	float distance_from_center;
	float time_to_change <- 30#s;
	float counter <- rnd(time_to_change);
	
	list<road> ways1;
	list<road> ways2;
	
	bool is_green;
	rgb traffic_light_color;
	rgb opposite_color;
	
	

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

	reflex dynamic_node when: traffic_signal_type = "traffic_signals" {
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
        	match "crossing" {draw circle(1) color:#black;}
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
			
			if(show_numbers) {
				draw number color: #red;
			}
		} else {
			draw circle(1) color: color;
			if(show_numbers) {
				draw number color: #red;
			}
		}
		
		switch traffic_signal_type { 
        	match "crossing" {draw circle(1) color:#black;}
        	match "give_way" {draw triangle(3) color:#red;} 
        	match "stop" {draw hexagon(3) color:#red;} 
        	match "bus_stop" {draw circle(1) color:#white;} 
			match "" {draw circle(1) color:#white;} 
		}
	}


}




