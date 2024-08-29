# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)
library(paletteer)

# Simple Models -----------------------------------------------------------


# Single Agent ------------------------------------------------------------

only_cars <-
  read_csv("simple_model/batch/only_cars_batch.csv") %>% rename_columns(., "one")
only_trucks <-
  read_csv("simple_model/batch/only_trucks_batch.csv") %>% rename_columns(., "one")
only_bicycles <-
  read_csv("simple_model/batch/only_bicycles_batch.csv") %>% rename_columns(., "one")

# Mixed -------------------------------------------------------------------

mixed_cars_trucks <-
  read_csv("simple_model/batch/mixed_cars_trucks_batch.csv") %>% rename_columns(., "mixed")
mixed_cars_bicycles <-
  read_csv("simple_model/batch/mixed_cars_bicycles_batch.csv") %>% rename_columns(., "mixed")
mixed_trucks_bicycles <-
  read_csv("simple_model/batch/mixed_trucks_bicycles_batch.csv") %>% rename_columns(., "mixed")


# All ---------------------------------------------------------------------

all_equal <-
  read_csv("simple_model/batch/all_equal_batch.csv") %>% rename_columns(., "simple")
urban_baseline <-
  read_csv("simple_model/batch/urban_baseline_batch.csv") %>% rename_columns(., "simple")
urban_high_density <-
  read_csv("simple_model/batch/urban_high_density_batch.csv") %>% rename_columns(., "simple")
suburban <-
  read_csv("simple_model/batch/suburban_batch.csv") %>% rename_columns(., "simple")


# Four main scenarios -----------------------------------------------------

scenarios <-
  list(all_equal, urban_baseline, urban_high_density, suburban)

group_names  <-
  c("All equal", "Urban Baseline", "Urban High Density", "Suburban")


# All scenarios -----------------------------------------------------------


all_scenarios <-
  list(
    all_equal,
    urban_baseline,
    urban_high_density,
    suburban,
    mixed_cars_trucks,
    mixed_cars_bicycles,
    mixed_trucks_bicycles,
    only_cars,
    only_trucks,
    only_bicycles
  )

all_group_names  <-
  c(
    "All equal",
    "Urban Baseline",
    "Urban High Density",
    "Suburban",
    "Cars-Trucks",
    "Cars-Bicycles",
    "Trucks-Bicycles",
    "Cars",
    "Trucks",
    "Bicycles"
  )

# Last entry for num_vehicles exiting -------------------------------------


plot_last_entry_num_vehicles(
  scenarios,
  group_names,
  "scenarios",
  "Average Number of Vehicles Exited",
  average_data
  )

plot_last_entry_num_vehicles(
  all_scenarios,
  all_group_names,
  "all_scenarios",
  "Average Number of Vehicles Exited",
  average_data
)

# Create plots for scenarios ----------------------------------------------


plot_variable(
  dfs = scenarios,
  group_names = group_names,
  variable = "avg_speed_all",
  average_function = average_data,
  title = "Average Speed for Different Scenarios"
)

plot_variable(
  dfs = scenarios,
  group_names = group_names,
  variable = "traffic_density_per_km",
  average_data,
  "Traffic Density for Different Scenarios"
)

plot_variable(
  dfs = scenarios,
  group_names = group_names,
  variable = "num_all_exiting",
  average_data,
  "Number of Vehicles Exiting for Different Scenarios"
)

plot_variable(
  dfs = scenarios,
  group_names = group_names,
  variable = "traffic_flow_all",
  average_data,
  "Traffic Flow for Different Scenarios"
)

plot_variable(
  dfs = all_scenarios,
  group_names = all_group_names,
  variable ="avg_speed_all",
  average_data,
  "Average Speed for All Scenarios",
  "all_"
)

plot_variable(
  dfs = all_scenarios,
  group_names = all_group_names,
  variable = "traffic_density_per_km",
  average_data,
  "Traffic Density for All Scenarios",
  "all_"
)

plot_variable(
  dfs = all_scenarios,
  group_names = all_group_names,
  variable = "num_all_exiting",
  average_data,
  "Number of Vehicles Exiting for All Scenarios",
  "all_"
)

plot_variable(
  dfs = all_scenarios,
  group_names = all_group_names,
  variable = "traffic_flow_all",
  average_data,
  "Traffic Flow for All Scenarios",
  "all_"
)


# Visualize Parameter -----------------------------------------------------

parameter_group_names  <-
  c("All_equal",
    "Suburban",
    "Urban_Baseline",
    "Urban_High_Density")

# List of parameters and their values
parameters <- list(
  min_safety_distance = c("0.5", "1.0"),
  min_security_distance = c("0.5", "1.0"),
  politeness_factor = c("0.5", "0.8"),
  proba_respect_priorities = c("0.8", "1.0"),
  proba_respect_stops = c("0.8", "1.0"),
  time_headway = c("1.5", "3.0")
)

# List of configurations
configurations <- list(
  list(dataset_key_suffix = "all", plot_variable_name = "all_avg_speed"),
  list(dataset_key_suffix = "mixed", plot_variable_name = "car_truck_avg_speed"),
  list(dataset_key_suffix = "one", plot_variable_name = "car_avg_speed")
)

# Loop over each parameter
for (param_name in names(parameters)) {
  param_values <- parameters[[param_name]]
  
  # Loop over each configuration
  for (config in configurations) {
    dataset_key <- paste(param_name, config$dataset_key_suffix, sep = "_")
    
    process_and_plot(
      parameter = param_name,
      group_names = group_names,
      parameter_values = param_values,
      dataset_key = dataset_key,
      plot_variable_name = config$plot_variable_name,
      average_data = average_data
    )
  }
}