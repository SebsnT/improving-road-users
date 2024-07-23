# Load the dplyr package
library(dplyr)
library(zoo)
library(tidyr)
library(ggplot2)
library(readr)


# Read files --------------------------------------------------------------

only_cars <- read_csv("simple_model/batch/only_cars_batch.csv")
only_trucks <- read_csv("simple_model/batch/only_trucks_batch.csv")
only_bicycles <- read_csv("simple_model/batch/only_bicycles_batch.csv")

mixed_cars_trucks <- read_csv("simple_model/batch/mixed_cars_trucks_batch.csv")
mixed_cars_bicycles <- read_csv("simple_model/batch/mixed_cars_bicycles_batch.csv")
mixed_trucks_bicycles <- read_csv("simple_model/batch/mixed_trucks_bicycles_batch.csv")

all_equal <- read_csv("simple_model/batch/all_equal_batch.csv")
urban_baseline <- read_csv("simple_model/batch/urban_baseline_batch.csv")
urban_high_density <- read_csv("simple_model/batch/urban_high_density_batch.csv")
suburban <- read_csv("simple_model/batch/suburban_batch.csv")


# Rename columns ----------------------------------------------------------


# Single Agents ------------------------------------------------------------

only_cars <- only_cars %>% rename(all_avg_speed = car_avg_speed, traffic_flow = car_traffic_flow, num_vehicle_exiting = num_cars_exiting)
only_trucks <- only_trucks %>% rename(all_avg_speed = truck_avg_speed, traffic_flow = truck_traffic_flow, num_vehicle_exiting = num_trucks_exiting)
only_bicycles <- only_bicycles %>% rename(all_avg_speed = bicycle_avg_speed, traffic_flow = bicycle_traffic_flow, num_vehicle_exiting = num_bicycles_exiting)


# Mixed Agents ------------------------------------------------------------

mixed_cars_trucks <- mixed_cars_trucks %>% rename(all_avg_speed = car_truck_avg_speed, traffic_flow = car_truck_traffic_flow)
mixed_cars_bicycles <- mixed_cars_bicycles %>% rename(all_avg_speed = car_bicycle_avg_speed, traffic_flow = car_bicycle_traffic_flow)
mixed_trucks_bicycles <- mixed_trucks_bicycles %>% rename(all_avg_speed = truck_bicycle_avg_speed, traffic_flow = truck_bicycle_traffic_flow)

# Average data ------------------------------------------------------------
