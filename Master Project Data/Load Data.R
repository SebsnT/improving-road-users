library(readr)

dir_all <- "parameter_results_new"


# load all csvs -----------------------------------------------------------

load_data <- function(dir) {
  
  parameter_dirs <- list.dirs(dir, full.names = TRUE, recursive = FALSE)
  
  all_datasets <- list()
  
  for (parameter_dir in parameter_dirs) {
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