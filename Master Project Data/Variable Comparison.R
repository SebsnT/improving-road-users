library(readr)

dir_all <- "parameter_results_new"


# load all csvs -----------------------------------------------------------

load_data <- function(dir) {
  # List all immediate subdirectories (these correspond to <parameter> directories)
  parameter_dirs <- list.dirs(dir, full.names = TRUE, recursive = FALSE)
  
  print(parameter_dirs)
  
  all_datasets <- list()
  
  for (parameter_dir in parameter_dirs) {
    # Now look for "one", "mixed", and "all" subdirectories within each <parameter> directory
    type_dirs <- list.dirs(parameter_dir, full.names = TRUE, recursive = FALSE)
    
    for (type_dir in type_dirs) {
      csv_files <- list.files(path = type_dir, pattern = "\\.csv$", full.names = TRUE)
      
      datasets_in_type_dir <- lapply(csv_files, read.csv)
      names(datasets_in_type_dir) <- basename(csv_files)
      
      # Use the parameter name and type as keys in the all_datasets list
      parameter_name <- basename(parameter_dir)
      type_name <- basename(type_dir)
      all_datasets[[paste(parameter_name, type_name, sep = "_")]] <- datasets_in_type_dir
    }
  }
  
  return(all_datasets)
}

all_datasets <- load_data(dir_all)



# Read ref csvs -----------------------------------------------------------

# Only cars
only_cars <- read_csv("simple_model/batch/only_cars_200_batch.csv")

# Mixed
mixed_cars_truck <- read_csv("simple_model/batch/mixed_cars_trucks_200_20_batch.csv")

# Reference Datasets
all_equal <- read_csv("simple_model/batch/all_equal_batch.csv")
suburban <- read_csv("simple_model/batch/suburban_batch.csv")
urban_baseline <- read_csv("simple_model/batch/urban_baseline_batch.csv")
urban_high_density <- read_csv("simple_model/batch/urban_high_density_batch.csv")

# Compare variables -------------------------------------------------------

min_safety_distance_values <- c("0.5","1.0")
min_security_distance_values <- c("0.5","1.0")
politeness_factor_values <- c("0.5","0.8")
proba_respect_priorities_values <- c("0.8","1.0")
proba_respect_stops_values <- c("0.8","1.0")
time_headway_values <- c("1.5","3.0")

# Only Car  ---------------------------------------------------------------

compare_parameters(list(only_cars),all_datasets[["min_safety_distance_one"]],"one","min_safety_distance",c("only_cars"), min_safety_distance_values)
compare_parameters(list(only_cars),all_datasets[["min_security_distance_one"]],"one","min_security_distance",c("only_cars"), min_security_distance_values)
compare_parameters(list(only_cars),all_datasets[["politeness_factor_one"]],"one","politeness_factor",c("only_cars"), politeness_factor_values)
compare_parameters(list(only_cars),all_datasets[["proba_respect_priorities_one"]],"one","proba_respect_priorities",c("only_cars"), proba_respect_priorities_values)
compare_parameters(list(only_cars),all_datasets[["proba_respect_stops_one"]],"one","proba_respect_stops",c("only_cars"),proba_respect_stops_values)
compare_parameters(list(only_cars),all_datasets[["time_headway_one"]],"one","time_headway",c("only_cars"),time_headway_values)


# Cars and Trucks ---------------------------------------------------------

compare_parameters(list(mixed_cars_truck),all_datasets[["min_safety_distance_mixed"]],"mixed","min_safety_distance",c("mixed_cars_truck"), min_safety_distance_values)
compare_parameters(list(mixed_cars_truck),all_datasets[["min_security_distance_mixed"]],"mixed","min_security_distance",c("mixed_cars_truck"), min_security_distance_values)
compare_parameters(list(mixed_cars_truck),all_datasets[["politeness_factor_mixed"]],"mixed","politeness_factor",c("mixed_cars_truck"), politeness_factor_values)
compare_parameters(list(mixed_cars_truck),all_datasets[["proba_respect_priorities_mixed"]],"mixed","proba_respect_priorities",c("mixed_cars_truck"), proba_respect_priorities_values)
compare_parameters(list(mixed_cars_truck),all_datasets[["proba_respect_stops_mixed"]],"mixed","proba_respect_stops",c("mixed_cars_truck"), proba_respect_stops_values)
compare_parameters(list(mixed_cars_truck),all_datasets[["time_headway_mixed"]],"mixed","time_headway",c("mixed_cars_truck"), time_headway_values)


# All agents
ref_list <- list(all_equal,suburban,urban_baseline,urban_high_density)

ref_names <- c("all_equal", "suburban", "urban_baseline", "urban_high_density")

compare_parameters(ref_list,all_datasets[["min_safety_distance_all"]],"all","min_safety_distance", ref_names, min_safety_distance_values)
compare_parameters(ref_list,all_datasets[["min_security_distance_all"]],"all","min_security_distance", ref_names,min_security_distance_values)
compare_parameters(ref_list, all_datasets[["politeness_factor_all"]],"all","politeness_factor", ref_names, politeness_factor_values)
compare_parameters(ref_list,all_datasets[["proba_respect_priorities_all"]],"all","proba_respect_priorities", ref_names, proba_respect_priorities_values)
compare_parameters(ref_list,all_datasets[["proba_respect_stops_all"]],"all","proba_respect_stops", ref_names, proba_respect_stops_values)
compare_parameters(ref_list,all_datasets[["time_headway_all"]],"all","time_headway", ref_names, time_headway_values)
