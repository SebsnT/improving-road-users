model OSMdata_to_shapefile

global {
// set to false to only render view
	bool save_results <- true;

	// name of OSM file
	string osm_file_name <- "graz2";

	// OSM file to read from
	string read_file <- "./includes/osm/" + osm_file_name + ".osm";

	// Files that will be writte to
	string write_roads_file <- "./includes/" + osm_file_name + "/" + "roads.shp";
	string write_nodes_file <- "./includes/" + osm_file_name + "/" + "nodes.shp";
	string write_footways_file <- "./includes/" + osm_file_name + "/" + "footways.shp";
	string write_buildings_file <- "./includes/" + osm_file_name + "/" + "buildings.shp";

	//map used to filter the object to build from the OSM file according to attributes. for an exhaustive list, see: http://wiki.openstreetmap.org/wiki/Map_Features
	map filtering <- map(["highway"::["primary", "secondary", "tertiary", "living_street", "residential", "unclassified", "footway", "crossing"], "building"::["yes"]]);

	//OSM file to load
	file<geometry> osmfile <- file<geometry>(osm_file("./includes/osm/" + osm_file_name + ".osm", filtering));
	geometry shape <- envelope(osmfile);
	map<point, intersection> nodes_map;

	// corrects the finished agents
	action correct_results {
		ask road {
			point ptF <- first(shape.points);
			if (not (ptF in nodes_map.keys)) {
				create intersection with: [location::ptF] {
					nodes_map[location] <- self;
				}

			}

			point ptL <- last(shape.points);
			if (not (ptL in nodes_map.keys)) {
				create intersection with: [location::ptL] {
					nodes_map[location] <- self;
				}

			}

		}

		write "Supplementary node agents created";
		ask intersection {
			if (empty(road overlapping (self))) {
				do die;
			}

		}

		write "Intersections filtered";
	}

	action save_results {
		if (save_results) {
			save road to: write_roads_file attributes: ["lanes"::self.lanes, "maxspeed"::maxspeed, "oneway"::oneway];
			save intersection to: write_nodes_file attributes: ["type"::type, "crossing"::crossing];
			save footway to: write_footways_file attributes: ["type"::type, "footway"::footway];
			save building to: write_buildings_file attributes: ["type"::type];
			write "Shapefiles were saved";
		}

		write "Saving Shapefiles was skipped";
	}

	init {
		write "OSM file loaded: " + length(osmfile) + " geometries";

		//from the OSM file, creation of the selected agents
		loop geom over: osmfile {
			if (shape covers geom) {
			// strings to get 
				string building_str <- string(geom get ("building"));
				string highway_str <- string(geom get ("highway"));
				if (length(geom.points) = 1 and highway_str != nil) {
					create intersection with: [shape::geom, type:: highway_str, crossing::string(geom get ("crossing"))] {
						nodes_map[location] <- self;
					}

				} else {
					if (building_str = "yes") {
						create building with: [shape::geom, type:: building_str];
					} else if (highway_str = "footway") {
						create footway with: [shape::geom, type:: highway_str];
					} else {
						string lanes_str <- string(geom get ("lanes"));
						int lanes_val;

						// set value of lanves_val
						if (empty(lanes_str)) {
							lanes_val <- 1;
						} else {
							lanes_val <- ((length(lanes_str) > 1) ? int(first(lanes_str)) : int(lanes_str));
						}

						create road with: [shape::geom, type:: highway_str, oneway::string(geom get ("oneway")), maxspeed::float(geom get ("maxspeed")), lanes::lanes_val] {
							if lanes < 1 {
							//default value for the lanes attribute
								lanes <- 1;
							}

							if maxspeed = 0 {
							//default value for the maxspeed attribute
								maxspeed <- 50.0;
							}

						}

					}

				}

			}

		}

		write "Agents created";
		do correct_results();
		do save_results();
	}

}

experiment fromOSMtoShapefiles type: gui {
	output {
		display map type: 3d {
			graphics "world" {
				draw world.shape.contour;
			}

			species footway aspect: base_line refresh: false;
			species road aspect: base_line refresh: false;
			species intersection aspect: base refresh: false;
			species building aspect: base refresh: false;
		}

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
		draw square(3) color: #red;
	}

}

species footway {
	rgb color <- #red;
	string type;

	aspect base_line {
		draw shape color: color;
	}

}

species building {
	rgb color <- #black;
	string type;

	aspect base {
		draw shape color: color;
	}

}


