# Helper functions --------------------------------------------------------

visualize_comparison <- function(df_combined) {
  # Plot the differences for Average Speed
  p1 <- ggplot(df_combined, aes(x = Time, y = Average_Speed_Diff)) +
    geom_line(color = "red") +
    geom_point(color = "red") +
    labs(title = "Differences in Average Speed", x = "Time", y = "Difference in Average Speed") +
    theme_minimal()
  
  # Plot the differences for Traffic Density
  p2 <- ggplot(df_combined, aes(x = Time, y = Traffic_Density_Diff)) +
    geom_line(color = "blue") +
    geom_point(color = "blue") +
    labs(title = "Differences in Traffic Density", x = "Time", y = "Difference in Traffic Density") +
    theme_minimal()
  
  # Plot the differences for Traffic Flow
  p3 <- ggplot(df_combined, aes(x = Time, y = Traffic_Flow_Diff)) +
    geom_line(color = "green") +
    geom_point(color = "green") +
    labs(title = "Differences in Traffic Flow", x = "Time", y = "Difference in Traffic Flow") +
    theme_minimal()
  
  # Plot the differences for Vehicle Exits
  p4 <- ggplot(df_combined, aes(x = Time, y = Vehicle_Exits_Diff)) +
    geom_line(color = "purple") +
    geom_point(color = "purple") +
    labs(title = "Differences in Vehicle Exits", x = "Time", y = "Difference in Vehicle Exits") +
    theme_minimal()
  
  # Display the plots
  print(p1)
  print(p2)
  print(p3)
  print(p4)
}

average_data <- function(df) {
  mean_data <- df %>%
    group_by(cycle) %>%
    summarize(
      mean_car_avg_speed = mean(car_avg_speed),
      mean_traffic_density_per_km = mean(traffic_density_per_km),
      mean_traffic_flow = mean(traffic_flow_car),
      mean_vehicles_exiting = mean(num_cars_exiting)
    )
  return(mean_data)
}

apply_dtw <- function(df1,df2) {
  
  data <- dtw(df1,df2, keep = TRUE)
  
  
  print(paste("DTW: ", data$distance))
  
}

apply_var <- function(df,dataset) {
  cat(dataset,"Variance Average Speed:",var(df$Mean_Average_Speed), "\n")
  cat(dataset,"Variance Average Density:",var(df$Mean_Traffic_Density), "\n")
  cat(dataset,"Variance Average Flow:",var(df$Mean_Traffic_Flow), "\n")
  cat(dataset,"Variance Average Exits:",var(df$Mean_Vehicle_Exits), "\n")
  cat("=================\n")
}

apply_sd <- function(df,dataset) {
  cat(dataset,"Standard Deviation Average Speed:",sd(df$Mean_Average_Speed), "\n")
  cat(dataset,"Standard Deviation Average Density:",sd(df$Mean_Traffic_Density), "\n")
  cat(dataset,"Standard Deviation Average Flow:",sd(df$Mean_Traffic_Flow), "\n")
  cat(dataset,"Standard Deviation Average Exits:",sd(df$Mean_Vehicle_Exits), "\n")
  cat("=================\n")
}

# Function to print t-test results
print_t_test_results <- function(result, metric_name) {
  cat("T-test results for", metric_name, ":\n")
  cat("\nInterpretation:\n")
  if (result$p.value < 0.05) {
    cat("Statistically significant difference in", metric_name, " (p-value =", result$p.value, ").\n")
  } else {
    cat("No statistically significant difference in", metric_name, " (p-value =", result$p.value, ").\n")
  }
  cat("t-value:", result$statistic, "\n")
  cat("Degrees of Freedom:", result$parameter, "\n\n")
  cat("Confidence Interval:", result$conf.int, "\n")
  cat("Mean of Group 1:", result$estimate[1], "\n")
  cat("Mean of Group 2:", result$estimate[2], "\n\n")
}

apply_t_test <- function(df1,df2) {
  t_test_avg_speed <- t.test(df1$mean_car_avg_speed, df2$mean_car_avg_speed)
  t_test_traffic_density <- t.test(df1$mean_traffic_density_per_km, df2$mean_traffic_density_per_km)
  t_test_traffic_flow <- t.test(df1$mean_traffic_flow, df2$mean_traffic_flow)
  t_test_num_exiting <- t.test(df1$mean_vehicles_exiting, df2$mean_vehicles_exiting)
  
  
  print_t_test_results(t_test_avg_speed, "Car Average Speed")
  print_t_test_results(t_test_traffic_density, "Traffic Density per km")
  print_t_test_results(t_test_traffic_flow, "Traffic Flow Car")
  print_t_test_results(t_test_num_exiting, "Number of Cars Exiting")
}

compare_files <- function(df1, df2) {
  
  df1 <- average_data(df1)
  df2 <- average_data(df2)
  
  # DTW
  cat("==== DTW ====\n")
  apply_dtw(df1,df2)
  
  # T Tests
  cat("==== T Tests ====\n")
  apply_t_test(df1,df2)
  
  # Rename Columns
  column_names <- c("Cycle", "Mean_Average_Speed", "Mean_Traffic_Density", "Mean_Traffic_Flow", "Mean_Vehicle_Exits")
  colnames(df1) <- column_names
  colnames(df2) <- column_names
  
  df1_subset <- df1[ , -1]
  df2_subset <- df2[ , -1]
  
  # Check if the dimensions of the two subsets are the same
  if(!all(dim(df1_subset) == dim(df2_subset))) {
    stop("The dimensions of the data frames (excluding the first column) do not match.")
  }
  
  # RMSE
  rmse_avg_speed <- rmse(df1_subset$Mean_Average_Speed, df2_subset$Mean_Average_Speed)
  rmse_traffic_density <- rmse(df1_subset$Mean_Traffic_Density, df2_subset$Mean_Traffic_Density)
  rmse_traffic_flow <- rmse(df1_subset$Mean_Traffic_Flow, df2_subset$Mean_Traffic_Flow)
  rmse_vehicle_exits <- rmse(df1_subset$Mean_Vehicle_Exits, df2_subset$Mean_Vehicle_Exits)
  
  # Variance with
  variance_df1 <- var(df1_subset$Mean_Average_Speed)
  variance_df2 <- var(df2_subset)
  
  cat("==== Variances ====\n")
  apply_var(df1,"With")
  apply_var(df2, "Without")
  
  cat("==== Standard Deviation ====\n")
  apply_sd(df1,"With")
  apply_sd(df2, "Without")
  
  cat("==== RMSE ====\n")
  print(list(
    RMSE_Avg_Speed = rmse_avg_speed,
    RMSE_Traffic_Density = rmse_traffic_density,
    RMSE_Traffic_Flow = rmse_traffic_flow,
    RMSE_Vehicle_Exits = rmse_vehicle_exits
  ))
  
  df_combined <- data.frame(
    Time = df1$Cycle,
    Average_Speed_Diff = df1$Mean_Average_Speed - df2$Mean_Average_Speed,
    Traffic_Density_Diff = df1$Mean_Traffic_Density - df2$Mean_Traffic_Density,
    Traffic_Flow_Diff = df1$Mean_Traffic_Flow - df2$Mean_Traffic_Flow,
    Traffic_Flow_Diff = df1$Mean_Traffic_Flow - df2$Mean_Traffic_Flow
  )
}