# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)


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

