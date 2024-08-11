# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)
library(paletteer)



# Line Plot one variable --------------------------------------------------


# Function to create the line plot
plot_variable <- function(dfs, group_names, variable, average_function, title = "Line Plot of Variable", png_name="" ) {
  
  # Apply the averaging function to each dataframe
  averaged_dfs <- lapply(dfs, average_function)
  
  # Combine all dataframes into one, adding a group column
  combined_df <- bind_rows(
    lapply(seq_along(averaged_dfs), function(i) {
      averaged_dfs[[i]] %>% mutate(group = group_names[i])
    })
  )
  
  # Use a palette with high contrast colors
  variable_plot <- ggplot(combined_df, aes(x = cycle, y = .data[[variable]], color = group)) +
    geom_line() +
    scale_color_paletteer_d("ggthemes::Tableau_10") +  # High contrast, distinct colors
    theme_minimal() +
    labs(title = title,
         x = "Cycle",
         y = variable,
         color = "Dataframe") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(filename = file.path( paste("./images/", variable), paste0("scenarios_",png_name, variable, ".png")), plot = variable_plot, width = 8, height = 6, bg = "white")
}


# Num Vehicles Bar plot ---------------------------------------------------


plot_last_entry_num_vehicles <- function(dfs, group_names, png_title, title, average_function) {
  
  # Apply the averaging function to each dataframe
  averaged_dfs <- lapply(dfs, average_function)
  
  # Combine all dataframes into one, adding a group column
  combined_df <- bind_rows(
    lapply(seq_along(averaged_dfs), function(i) {
      averaged_dfs[[i]] %>% mutate(group = group_names[i])
    })
  )
  
  # Group by the 'group' column and calculate the last entry for each group
  last_entries <- combined_df %>%
    group_by(group) %>%
    summarize(last_num_all_exiting = last(num_all_exiting))
  
  # Sort the group factor by the number of vehicles exited
  last_entries <- last_entries %>%
    arrange(last_num_all_exiting) %>%
    mutate(group = factor(group, levels = group))
  
  # Create the plot
  num_vehicles_plot <- ggplot(last_entries, aes(x = group, y = last_num_all_exiting, fill = group)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(title = title,
         x = "Scenario",
         y = "Number of Vehicles Exited",
         fill = "Scenario") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Save the plot
  ggsave(filename = file.path("./images/num_vehicles_last_entry", paste0(png_title, ".png")),
         plot = num_vehicles_plot, width = 8, height = 6, bg = "white")
}

 
# Simple Models -----------------------------------------------------------


# Single Agent ------------------------------------------------------------

only_cars <- read_csv("simple_model/batch/only_cars_batch.csv") %>% rename_columns(., "one")
only_trucks <- read_csv("simple_model/batch/only_trucks_batch.csv") %>% rename_columns(., "one")
only_bicycles <- read_csv("simple_model/batch/only_bicycles_batch.csv") %>% rename_columns(., "one")

tail(average_data(only_bicycles))

# Mixed -------------------------------------------------------------------

mixed_cars_trucks <- read_csv("simple_model/batch/mixed_cars_trucks_batch.csv") %>% rename_columns(., "mixed")
mixed_cars_bicycles <- read_csv("simple_model/batch/mixed_cars_bicycles_batch.csv") %>% rename_columns(., "mixed")
mixed_trucks_bicycles <- read_csv("simple_model/batch/mixed_trucks_bicycles_batch.csv") %>% rename_columns(., "mixed")


# All ---------------------------------------------------------------------

all_equal <- read_csv("simple_model/batch/all_equal_batch.csv") %>% rename_columns(., "simple")
urban_baseline <- read_csv("simple_model/batch/urban_baseline_batch.csv") %>% rename_columns(., "simple")
urban_high_density <- read_csv("simple_model/batch/urban_high_density_batch.csv") %>% rename_columns(., "simple")
suburban <- read_csv("simple_model/batch/suburban_batch.csv") %>% rename_columns(., "simple")


# Four main scenarios -----------------------------------------------------


scenarios <- list(all_equal, urban_baseline, urban_high_density, suburban) 

group_names  <- c("All equal", "Urban Baseline", "Urban High Density", "Suburban")


# All scenarios -----------------------------------------------------------


all_scenarios <- list(all_equal, urban_baseline, urban_high_density, suburban, 
                      mixed_cars_trucks, mixed_cars_bicycles, mixed_trucks_bicycles, 
                      only_cars, only_trucks, only_bicycles ) 

all_group_names  <- c("All equal", "Urban Baseline", "Urban High Density", "Suburban", 
                      "Cars-Trucks","Cars-Bicycles","Trucks-Bicycles",
                      "Cars", "Trucks", "Bicycles")

# Last entry for num_vehicles exiting -------------------------------------

 
 plot_last_entry_num_vehicles(scenarios,group_names, "scenarios", "Average Number of Vehicles Exited", average_data)
 plot_last_entry_num_vehicles(all_scenarios,all_group_names, "all_scenarios", "Average Number of Vehicles Exited", average_data)

# Create plots for scenarios ----------------------------------------------
 

plot_variable(scenarios,group_names, "avg_speed_all", average_data, "Average Speed for Different Scenarios")
plot_variable(scenarios,group_names, "traffic_density_per_km", average_data, "Traffic Density for Different Scenarios")
plot_variable(scenarios,group_names, "num_all_exiting", average_data, "Number of Vehicles Exiting for Different Scenarios")
plot_variable(scenarios,group_names, "traffic_flow_all", average_data, "Traffic Flow for Different Scenarios")

plot_variable(all_scenarios,all_group_names, "avg_speed_all", average_data, "Average Speed for All Scenarios", "all_")
plot_variable(all_scenarios,all_group_names, "traffic_density_per_km", average_data, "Traffic Density for All Scenarios", "all_")
plot_variable(all_scenarios,all_group_names, "num_all_exiting", average_data, "Number of Vehicles Exiting for All Scenarios", "all_")
plot_variable(all_scenarios,all_group_names, "traffic_flow_all", average_data, "Traffic Flow for All Scenarios", "all_")


