# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)



# Plot functions ----------------------------------------------------------

# Plot metrics with and without signals
plot_metrics <- function(df1, df2, group1_name = "With Signals", group2_name = "Without Signals", title) {
  
  df1 <- average_data(df1)
  df2 <- average_data(df2)
  
  df1 <- rename_columns(df1, "testing")
  df2 <- rename_columns(df2, "testing")
  
  # Add group identifiers
  df1 <- df1 %>% mutate(group = group1_name)
  df2 <- df2 %>% mutate(group = group2_name)
  
  # Combine dataframes into one
  combined_df <- bind_rows(df1, df2)
  
  
  # Extract the last entry of 'num_cars_exiting' for each group
  last_entries <- combined_df %>%
    group_by(group) %>%
    summarize(last_num_vehicles_exiting = last(num_vehicles_exiting))
  
  # Create the bar plot
  num_vehicles_plot <- ggplot(last_entries, aes(x = group, y = last_num_vehicles_exiting, fill = group)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = round(last_num_vehicles_exiting)), vjust = -0.3, color = "black", size = 3.5) +
    theme_minimal() +
    labs(title = paste("Number of Vehicles Exiting for", title),
         x = "Group",
         y = "Number of Vehicles Exiting",
         fill = "Group")
  
  avg_speed_plot <- ggplot(combined_df, aes(x = cycle, y = avg_speed, color = group)) +
    geom_line() +
    theme_minimal() +
    labs(title = paste("Average Speed Comparison of", title),
         x = "Cycle",
         y = "Average Speed",
         color = "Dataframe")
  
  ggsave(filename = file.path("./images/average_speed", paste(title, "avg_speed.png")), plot = avg_speed_plot, width = 8, height = 6, bg = "white")
  ggsave(filename = file.path("./images/num_vehicles", paste(title, "num_vehicles.png")), plot = num_vehicles_plot, width = 8, height = 6, bg = "white")
  
}


# Testing Models ----------------------------------------------------------

# signalized --------------------------------------------------------------

signalized_cross_intersection <- read_csv("testing/batch/signalized/signalized_cross_intersection_batch.csv")
signalized_cross_intersection_without_signals <- read_csv("testing/batch/signalized/signalized_cross_intersection_without_signals_batch.csv")

signalized_one_street <- read_csv("testing/batch/signalized/signalized_one_street_batch.csv")
signalized_one_street_without_signals <- read_csv("testing/batch/signalized/signalized_one_street_without_signals_batch.csv")

signalized_t_intersection <- read_csv("testing/batch/signalized/signalized_t_intersection_batch.csv")
signalized_t_intersection_without_signals <- read_csv("testing/batch/signalized/signalized_t_intersection_without_signals_batch.csv")

# street signs ------------------------------------------------------------

street_signs_give_way <- read_csv("testing/batch/street_signs/street_signs_give_way_batch.csv")
street_signs_stop_sign <- read_csv("testing/batch/street_signs/street_signs_stop_sign_batch.csv")
street_signs_t_without_signal <- read_csv("testing/batch/street_signs/street_signs_t_without_signal_batch.csv")

street_signs_give_way_cross_intersection <- read_csv("testing/batch/street_signs/street_signs_give_way_cross_intersection_batch.csv")
street_signs_stop_sign_cross_intersection <- read_csv("testing/batch/street_signs/street_signs_stop_sign_cross_intersection_batch.csv")
street_signs_cross_intersection_without_signals <- read_csv("testing/batch/street_signs/street_signs_cross_intersection_without_signals_batch.csv")

street_signs_stop_sign_all_way_stop <- read_csv("testing/batch/street_signs/street_signs_stop_sign_all_way_stop_batch.csv")
street_signs_stop_sign_all_way_stop_without_signals <- read_csv("testing/batch/street_signs/street_signs_stop_sign_all_way_stop_without_signals_batch.csv")

# unsignalized ------------------------------------------------------------

unsignalized_use_crosswalk <- read_csv("testing/batch/unsignalized/unsignalized_use_crosswalk_batch.csv")
unsignalized_use_crosswalk_without_signals <- read_csv("testing/batch/unsignalized/unsignalized_use_crosswalk_without_signals_batch.csv")


# Bar Plots ---------------------------------------------------------------

# Signalized

plot_metrics(signalized_cross_intersection, signalized_cross_intersection_without_signals, title = "Signalized Cross Intersection")
plot_metrics(signalized_one_street, signalized_one_street_without_signals, title = "Signalized One Street" )
plot_metrics(signalized_t_intersection, signalized_t_intersection_without_signals, title = "Signalized T-Intersection" )

# Street Signs

plot_metrics(street_signs_give_way, street_signs_t_without_signal, title = "Street Signs Give Way" )
plot_metrics(street_signs_stop_sign, street_signs_t_without_signal, title = "Street Signs Stop Sign" )
plot_metrics(street_signs_give_way_cross_intersection, street_signs_cross_intersection_without_signals, title = "Street Signs Give Way Cross Intersection" )
plot_metrics(street_signs_stop_sign_cross_intersection, street_signs_cross_intersection_without_signals, title = "Street Signs Stop Sign Cross Intersection" )
plot_metrics(street_signs_stop_sign_all_way_stop, street_signs_stop_sign_all_way_stop_without_signals, title = "Street Signs Stop Sign All-Way-Stop" )

# Crosswalk

plot_metrics(unsignalized_use_crosswalk, unsignalized_use_crosswalk_without_signals, title = "Unsignalized Crosswalk" )