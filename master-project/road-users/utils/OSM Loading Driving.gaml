
model OSMdata_to_shapefile 
 
global{
	
	string city <- "graz";
	
	string read_file <- "./includes/osm/" + city + ".osm";
	
	string write_roads_file <-"./includes/"+ city +"/" +"roads.shp";
	string write_nodes_file <-"./includes/"+ city +"/" + "nodes.shp";
	string write_footways_file <-"./includes/"+ city +"/" + "footways.shp";
	
	//map used to filter the object to build from the OSM file according to attributes. for an exhaustive list, see: http://wiki.openstreetmap.org/wiki/Map_Features
	map filtering <- map(["highway"::["primary", "secondary", "tertiary", "living_street","residential", "unclassified", "footway","crossing"]]);
	
	//OSM file to load
	file<geometry> osmfile <-  file<geometry>(osm_file(read_file, filtering));
	
	
	geometry shape <- envelope(osmfile);
	
	graph the_graph; 
	map<point, intersection> nodes_map;
	
	init {
		write "OSM file loaded: " + length(osmfile) + " geometries";

		//from the OSM file, creation of the selected agents
		loop geom over: osmfile {

			if (shape covers geom) {
				string highway_str <- string(geom get ("highway"));
				
				if (length(geom.points) = 1 ) {
					if ( highway_str != nil ) {
						string crossing <- string(geom get ("crossing"));
						// write highway_str;

						create intersection with: [shape ::geom, type:: highway_str, crossing::crossing] {
							nodes_map[location] <- self;
						}
		
					}
				} else {
					if(highway_str = "footway"){
						create footway with: [shape ::geom, type:: highway_str];
					} else {
					
					string oneway <- string(geom get ("oneway"));
					float maxspeed_val <- float(geom get ("maxspeed"));
					string lanes_str <- string(geom get ("lanes"));
					
					int lanes_val <- empty(lanes_str) ? 1 : ((length(lanes_str) > 1) ? int(first(lanes_str)) : int(lanes_str));
					create road with: [shape ::geom, type:: highway_str, oneway::oneway, maxspeed::maxspeed_val, lanes::lanes_val] {
						if lanes < 1 {lanes <- 1;} //default value for the lanes attribute
						if maxspeed = 0 {maxspeed <- 50.0;} //default value for the maxspeed attribute
						}
					
					}
		
				}	
			}
		}

		
	
		write "Road and node agents created";
		
		ask road {
			point ptF <- first(shape.points);
			if (not(ptF in nodes_map.keys)) {
				create intersection with:[location::ptF] {
					nodes_map[location] <- self;
				}	
			}
			point ptL <- last(shape.points);
			if (not(ptL in nodes_map.keys)) {
				create intersection with:[location::ptL] {
					nodes_map[location] <- self;
				}
			}
		}
			
		write "Supplementary node agents created";
		ask intersection {
			if (empty (road overlapping (self))) {
				do die;
			}
		}
		
		write "node agents filtered";
		
		//Save all the road agents inside the file with the path written, using the with: facet to make a link between attributes and columns of the resulting shapefiles. 
		save road to: write_roads_file attributes:["lanes"::self.lanes, "maxspeed"::maxspeed, "oneway"::oneway] ;
		save intersection to: write_nodes_file attributes:["type"::type, "crossing"::crossing];
		save footway to: write_footways_file  attributes:["type"::type, "footway"::footway];
		write "road and node and footway shapefile saved";
	}
}
	

species road {
	rgb color <- #black;
	string type;
	string oneway;
	float maxspeed;
	int lanes;
	aspect base_line {
		draw shape color: color; 
	}
	
} 
	
species intersection {
	string type;
	string crossing;
	aspect base { 
		draw square(3) color: #red ;
	}
} 

species footway {
	rgb color <- #red;
	string type;
	aspect base_line { 
		draw shape color: color; 
	}
}

species building_agent
{
	string building_str;
}


experiment fromOSMtoShapefiles type: gui {
	output {
		display map type: 3d {
			graphics "world" {
				draw world.shape.contour;
			}
			species footway aspect: base_line refresh: false;
			species road aspect: base_line  refresh: false  ;
			species intersection aspect: base refresh: false ;
		}
	}
}
