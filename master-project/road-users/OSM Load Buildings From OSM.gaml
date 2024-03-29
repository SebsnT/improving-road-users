
model OSMloadBuilding


global
{
	
	string city <- "graz2";
	
	string write_buildings_file <-"./includes/"+ city +"/" + "buildings.shp";

	map filtering <- map([ "building"::["yes"]]);
	//OSM file to load
	file<geometry> osmfile;

	//compute the size of the environment from the envelope of the OSM file
	geometry shape <- envelope(osmfile);
	
	init
	{
	//possibility to load all of the attibutes of the OSM data: for an exhaustive list, see: http://wiki.openstreetmap.org/wiki/Map_Features
		create osm_agent from: osmfile with: [building_str::string(read("building"))];

		//from the created generic agents, creation of the selected agents
		ask osm_agent
		{
			if (length(shape.points) = 1 )
			{
				//create node_agent with: [shape::shape, type:: highway_str];
			} else
			{
				if (building_str != nil)
				{
					create building with: [shape::shape, type::building_str];
				}

			}
			do die;
		}

		save building to: write_buildings_file  attributes:["type"::type];
	}

}

species osm_agent
{
	string building_str;
}


species building {
	rgb color <- #beige;
	string type;
	aspect base { 
		draw shape color: color; 
	}
}

experiment "Load OSM" type: gui
{
	parameter "File:" var: osmfile <- file<geometry> (osm_file("./includes/osm/" + city + ".osm", filtering));
	output
	{
		display map type: 3d
		{
			species building refresh: false;
		}

	}

}

