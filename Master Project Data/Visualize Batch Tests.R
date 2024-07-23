# Load necessary libraries
library(ggplot2)
library(dplyr)

mean_100_simulation <- function(path)  {
  data <- read.csv(path)
  
  mean_data <- data %>%
    group_by(cycle) %>%
    summarize(
      mean_car_avg_speed = mean(car_avg_speed),
      mean_traffic_density_per_km = mean(traffic_density_per_km),
      mean_traffic_flow = mean(traffic_flow_car),
      mean_vehicles_exiting = mean(num_cars_exiting)
      )
  
  print(mean_data)
  
  # Create a ggplot for mean car average speed
  avg_speed_plot <- ggplot(mean_data, aes(x = cycle, y = mean_car_avg_speed)) +
    geom_line() +
    labs(title = "Mean Car Average Speed Over Cycles",
         x = "Cycle",
         y = "Mean Car Average Speed") +
    theme_minimal()
  
  # Create a ggplot for mean traffic density per km
  avg_traffic_density_plot <- ggplot(mean_data, aes(x = cycle, y = mean_traffic_density_per_km)) +
    geom_line() +
    labs(title = "Mean Traffic Density Over Cycles",
         x = "Cycle",
         y = "Mean Traffic Density per km") +
    theme_minimal()
  
  # Create a ggplot for traffic flow
  avg_traffic_flow_plot <- ggplot(mean_data, aes(x = cycle, y = mean_traffic_flow)) +
    geom_line() +
    labs(title = "Mean Traffic Flow Over Cycles",
         x = "Cycle",
         y = "Mean Car Traffic Flow per Hour") +
    theme_minimal()
  
  # Create a ggplot for mean cars exiting
  avg_vehicles_exiting_plot <- ggplot(mean_data, aes(x = cycle, y = mean_vehicles_exiting)) +
    geom_line() +
    labs(title = "Mean Vehicles Exiting Over Cycles",
         x = "Cycle",
         y = "Mean Vehicles Exiting") +
    theme_minimal()
  
  print(avg_speed_plot)
  print(avg_traffic_density_plot)
  print(avg_traffic_flow_plot)
  print(avg_vehicles_exiting_plot)
}

mean_100_simulation("testing/batch/signalized/signalized_t_intersection_batch.csv")
mean_100_simulation("testing/batch/signalized/signalized_t_intersection_without_signals_batch.csv")

mean_100_simulation("testing/batch/signalized/signalized_one_street_.csv")
mean_100_simulation("testing/batch/signalized/signalized_one_street_without_signals_batch.csv")

mean_100_simulation("testing/batch/signalized/signalized_cross_intersection_batch.csv")
mean_100_simulation("testing/batch/signalized/signalized_cross_intersection_without_signals_batch.csv")


mean_100_simulation("testing/batch/street_signs/street_signs_stop_sign_batch.csv")
mean_100_simulation("testing/batch/street_signs/street_signs_give_way_batch.csv")
mean_100_simulation("testing/batch/street_signs/street_signs_t_without_signal_batch.csv")

mean_100_simulation("testing/batch/street_signs/street_signs_give_way_cross_intersection_batch.csv")
mean_100_simulation("testing/batch/street_signs/street_signs_stop_sign_cross_intersection_batch.csv")
mean_100_simulation("testing/batch/street_signs/street_signs_cross_intersection_without_signals_batch.csv")


mean_100_simulation("testing/batch/street_signs/street_signs_stop_sign_all_way_stop_batch.csv")
mean_100_simulation("testing/batch/street_signs/street_signs_stop_sign_all_way_stop_without_signals_batch.csv")


mean_100_simulation("testing/batch/unsignalized/unsignalized_use_crosswalk_batch.csv")
mean_100_simulation("testing/batch/unsignalized/unsignalized_use_crosswalk_without_signals_batch.csv")


