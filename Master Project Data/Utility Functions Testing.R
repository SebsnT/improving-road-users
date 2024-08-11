library(readr)
library(Metrics)
library(ggplot2)
library(reshape2)
library(dplyr)
library(tidyverse)
library(dtw)
library(xtable) # for converting data frame to LaTeX table


# Helper functions --------------------------------------------------------


# Utility functions  ------------------------------------------------------------

average_data <- function(df) {
  mean_data <- df %>%
    group_by(cycle) %>%
    summarize(across(everything(), \(x) mean(x, na.rm = TRUE)))
  return(mean_data)
}

# Check for common columns

find_common_cols <- function(df1, df2) {
  return(intersect(
    names(df1 %>% select(-1) %>% select(where(is.numeric))),
    names(df2 %>% select(-1) %>% select(where(is.numeric)))
  ))
}

# Rename specific columns
rename_columns <- function(df, folder_name) {
  
  if(folder_name == "testing") {
    df <- df %>%
      rename(
        avg_speed = car_avg_speed,
        num_all_exiting = num_cars_exiting,
        traffic_flow = traffic_flow_car
      )
    return(df)
  }
  
  if(folder_name == "simple" || folder_name == "all") {
    df <- df %>%
      rename(
        avg_speed_all = all_avg_speed,
        avg_speed_bicycle = bicycle_avg_speed,
        avg_speed_car = car_avg_speed,
        avg_speed_truck = truck_avg_speed,
        traffic_flow_all = all_traffic_flow
      )
    return(df)
  }
  
  if(folder_name == "one"){
    
    if("car_avg_speed" %in% colnames(df)) {
      df <- df %>% rename(avg_speed_all = car_avg_speed,
                          traffic_flow_all = car_traffic_flow,
                          num_all_exiting = num_cars_exiting)
    }
    
    if("truck_avg_speed" %in% colnames(df)) {
      df <- df %>% rename(avg_speed_all = truck_avg_speed,
                          traffic_flow_all = truck_traffic_flow,
                          num_all_exiting = num_trucks_exiting)
    }
    
    if("bicycle_avg_speed" %in% colnames(df)) {
      df <- df %>% rename(avg_speed_all = bicycle_avg_speed,
                          traffic_flow_all = bicycle_traffic_flow,
                          num_all_exiting = num_bicycles_exiting)
    }
    
    
    return(df)
  }
  
  if(folder_name == "mixed"){
    
    if("car_avg_speed" %in% colnames(df) && "truck_avg_speed" %in% colnames(df)) {
      df <- df %>% rename(avg_speed_car = car_avg_speed,
                          avg_speed_truck = truck_avg_speed,
                          avg_speed_all = car_truck_avg_speed,
                          traffic_flow_all = car_truck_traffic_flow)
    }
    
    if("car_avg_speed" %in% colnames(df) && "bicycle_avg_speed" %in% colnames(df)) {
      df <- df %>% rename(avg_speed_car = car_avg_speed,
                          avg_speed_bicycle = bicycle_avg_speed,
                          avg_speed_all = car_bicycle_avg_speed,
                          traffic_flow_all = car_bicycle_traffic_flow)
    }
    
    if("truck_avg_speed" %in% colnames(df) && "bicycle_avg_speed" %in% colnames(df)) {
      df <- df %>% rename(avg_speed_bicycles = bicycle_avg_speed,
                          avg_speed_trucks = truck_avg_speed,
                          avg_speed_all = truck_bicycle_avg_speed,
                          traffic_flow_all = truck_bicycle_traffic_flow)
    }
    return(df)
  }
  return(df)
}

# Normalize the data using Z-score standardization
z_normalize <- function(x) {
  return((x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE))
}


# DTW ---------------------------------------------------------------------

apply_dtw <- function(df1, df2) {
  
  # cat("==== DTW ====\n")
  
  # Identify common numeric columns
  common_cols <- find_common_cols(df1, df2)
  
  if (length(common_cols) == 0) {
    stop("No common numeric columns found for DTW calculation.")
  }
  
  z_normalize <- function(x) {
    return((x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE))
  }
  
  # Initialize a list to store DTW results
  dtw_results <- list()
  
  for (col in common_cols) {
    # Normalize the columns
    norm_df1_col <- z_normalize(df1[[col]])
    norm_df2_col <- z_normalize(df2[[col]])
    
    dtw_result <- dtw(norm_df1_col, norm_df2_col, keep = TRUE)
    dtw_results[[col]] <- dtw_result$distance
  }
  
  
  # Print results
  # for (col in names(dtw_results)) {
  #   print(paste("DTW for", col, ": ", dtw_results[[col]]))
  # }
  
  dtw_results_df <-
    data.frame(Metric = names(dtw_results),
               DTW = unlist(dtw_results))
  
  return(dtw_results_df)
}


# Variance ----------------------------------------------------------------

# Function to calculate variance difference for common numeric columns
compare_var <- function(df1, df2) {
  
  # cat("==== Variances ====\n")
  
  # Identify common numeric columns
  common_cols <- find_common_cols(df1, df2)
  
  if (length(common_cols) == 0) {
    stop("No common numeric columns found for variance calculation.")
  }
  
  # Initialize a list to store variance differences
  var_differences <- list()
  
  # Calculate variance differences for each common column
  for (col in common_cols) {
    var_diff <- abs(var(df1[[col]]) - var(df2[[col]]))
    var_differences[[col]] <- var_diff
  }
  
  # Print results
  # for (col in names(var_differences)) {
  #   cat("Variance Difference for", col, ":", var_differences[[col]], "\n")
  # }
  # cat("=================\n")
  
  var_differences_df <-
    data.frame(Metric = names(var_differences),
               Variance_Diff = unlist(var_differences))
  return(var_differences_df)
}


# Standard Deviation ------------------------------------------------------

# Function to calculate standard deviation differences for common numeric columns
compare_sd <- function(df1, df2) {
  
  # cat("==== Standard Deviation ====\n")
  
  # Identify common numeric columns
  common_cols <- find_common_cols(df1, df2)
  
  if (length(common_cols) == 0) {
    stop("No common numeric columns found for standard deviation calculation.")
  }
  
  # Initialize a list to store standard deviation differences
  sd_differences <- list()
  
  # Calculate standard deviation differences for each common column
  for (col in common_cols) {
    sd_diff <- abs(sd(df1[[col]]) - sd(df2[[col]]))
    sd_differences[[col]] <- sd_diff
  }
  
  # Print results
  # for (col in names(sd_differences)) {
  #   cat("Standard Deviation Difference for",
  #       col,
  #       ":",
  #       sd_differences[[col]],
  #       "\n")
  # }
  # cat("=================\n")
  
  sd_differences_df <-
    data.frame(Metric = names(sd_differences),
               SD_Diff = unlist(sd_differences))
  return(sd_differences_df)
}


# T-Test ------------------------------------------------------------------

# Function to print t-test results
print_t_test_results <- function(result, metric_name) {
  cat("T-test results for", metric_name, ":\n")
  cat("\nInterpretation:\n")
  if (result$p.value < 0.05) {
    cat(
      "Statistically significant difference in",
      metric_name,
      " (p-value =",
      result$p.value,
      ").\n"
    )
  } else {
    cat(
      "No statistically significant difference in",
      metric_name,
      " (p-value =",
      result$p.value,
      ").\n"
    )
  }
  cat("t-value:", result$statistic, "\n")
  cat("Degrees of Freedom:", result$parameter, "\n\n")
  cat("Confidence Interval:", result$conf.int, "\n")
  cat("Mean of Group 1:", result$estimate[1], "\n")
  cat("Mean of Group 2:", result$estimate[2], "\n\n")
  cat("=================\n")
}

apply_t_test <- function(df1, df2) {
  
  # cat("==== T Tests ====\n")
  
  # Identify common numeric columns
  common_cols <- find_common_cols(df1, df2)
  
  # Ensure common columns are in both dataframes
  common_cols <- intersect(common_cols, names(df1))
  
  if (length(common_cols) == 0) {
    stop("No common numeric columns found for t-test.")
  }
  
  t_test_results <- list()
  
  # Perform t-tests and print results
  for (col in common_cols) {
    if (length(df1[[col]]) > 1 & length(df2[[col]]) > 1) {
      
      t_test_result <- t.test(df1[[col]], df2[[col]])
      t_test_result <- t.test(df1[[col]], df2[[col]])
      
      t_test_results[[col]] <- list(
        p.value = t_test_result$p.value,
        t.value = t_test_result$statistic,
        Mean1 = t_test_result$estimate[1],
        Mean2 = t_test_result$estimate[2]
      )
      
    } else {
      cat("Not enough data in", col, "for t-test.\n")
    }
  }
  
  
  t_test_results_df <- do.call(rbind, lapply(t_test_results, as.data.frame))
  t_test_results_df$Metric <- rownames(t_test_results_df)
  return(t_test_results_df)
}


# RMSE --------------------------------------------------------------------

# Function to calculate RMSE for all common numeric columns
calculate_rmse <- function(df1, df2) {
  
  # Identify common numeric columns
  common_cols <- find_common_cols(df1, df2)
  
  if (length(common_cols) == 0) {
    stop("No common numeric columns found for RMSE calculation.")
  }
  
  # Initialize a list to store RMSE results
  rmse_results <- list()
  
  # Calculate RMSE for each common column
  for (col in common_cols) {
    if (length(df1[[col]]) > 1 & length(df2[[col]]) > 1) {
      rmse_value <- rmse(df1[[col]], df2[[col]])
      rmse_results[[col]] <- rmse_value
    } else {
      warning("Not enough data in", col, "for RMSE calculation.")
    }
  }
  
  rmse_results_df <-
    data.frame(Metric = names(rmse_results),
               RMSE = unlist(rmse_results))
  return(rmse_results_df)
}


# Compare Function --------------------------------------------------------

compare_parameters <- function(ref_dfs, dataframes, folder, file_name, ref_names, param_names) {
  # List to hold all results
  all_final_results <- list()
  
  # Check if the length of ref_names matches the length of ref_dfs
  if (length(ref_dfs) != length(ref_names)) {
    stop("The length of ref_names must match the length of ref_dfs.")
  }
  
  # Loop through each reference dataframe and its corresponding pairs
  for (i in 1:length(ref_dfs)) {
    ref_df <- ref_dfs[[i]]
    df1 <- dataframes[[2 * i - 1]]
    df2 <- dataframes[[2 * i]]
    
    # Average data
    df1 <- average_data(df1)
    df2 <- average_data(df2)
    ref_df <- average_data(ref_df)
    
    # Rename columns
    df1 <- rename_columns(df1, folder)
    df2 <- rename_columns(df2, folder)
    ref_df <- rename_columns(ref_df, folder)
    
    # DTW
    dtw_results_1 <- apply_dtw(df1, ref_df)
    dtw_results_2 <- apply_dtw(df2, ref_df)
    
    t_test_results_1 <- apply_t_test(df1, ref_df)
    t_test_results_2 <- apply_t_test(df2, ref_df)
    
    df1_subset <- df1[, -1]
    df2_subset <- df2[, -1]
    ref_df_subset <- ref_df[, -1]
    
    # Check if the dimensions of the data frames (excluding the first column) match the reference
    if (!all(dim(df1_subset) == dim(ref_df_subset))) {
      stop("The dimensions of df1 and the reference data frame (excluding the first column) do not match.")
    }
    if (!all(dim(df2_subset) == dim(ref_df_subset))) {
      stop("The dimensions of df2 and the reference data frame (excluding the first column) do not match.")
    }
    
    # RMSE
    rmse_results_1 <- calculate_rmse(df1, ref_df)
    rmse_results_2 <- calculate_rmse(df2, ref_df)
    
    # Gather all results for each comparison
    all_results_1 <- list(t_test_results_1, dtw_results_1, rmse_results_1)
    all_results_2 <- list(t_test_results_2, dtw_results_2, rmse_results_2)
    
    # Sort by metric
    final_results_1 <- Reduce(function(x, y) merge(x, y, by = "Metric", all = TRUE), Filter(Negate(is.null), all_results_1))
    final_results_2 <- Reduce(function(x, y) merge(x, y, by = "Metric", all = TRUE), Filter(Negate(is.null), all_results_2))
    
    # Extract parameter names for naming
    param_name_1 <- param_names[2 * i - 1]
    param_name_2 <- param_names[2 * i]
    
    # Add to all final results with names from ref_names
    all_final_results[[paste0( ref_names[i], "_", file_name,"_", param_name_1)]] <- final_results_1
    all_final_results[[paste0( ref_names[i], "_", file_name,"_", param_name_2)]] <- final_results_2
  }
  
  # Combine all final results into one data frame
  combined_final_results <- do.call(rbind, lapply(names(all_final_results), function(name) {
    result <- all_final_results[[name]]
    result$Comparison <- name
    return(result)
  }))
  
  # Write results to csv
  write.csv(
    combined_final_results,
    file = paste0("csv_results/", folder, "/", file_name, "_comparison_results.csv"),
    row.names = FALSE
  )
  
  # Print LaTeX table
  print(
    xtable(combined_final_results),
    type = "latex",
    include.rownames = FALSE,
    file = paste0("latex_tables/", folder, "/", file_name, "_comparison_results.tex")
  )
}

