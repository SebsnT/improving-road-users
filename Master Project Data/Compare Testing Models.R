library(readr)
library(Metrics)
library(ggplot2)
library(reshape2)
library(dplyr)
library(tidyverse)
library(dtw)

# Read files --------------------------------------------------------------


# signalized --------------------------------------------------------------
  
  singalized_cross_intersection <- read_csv("testing/batch/signalized/signalized_cross_intersection_batch.csv")
  singalized_cross_intersection_without_signals <- read_csv("testing/batch/signalized/signalized_cross_intersection_without_signals_batch.csv")
  
  signalized_one_street <- read_csv("testing/batch/signalized/signalized_one_street_batch.csv")
  signalized_one_street_without_signals <- read_csv("testing/batch/signalized/signalized_one_street_without_signals_batch.csv")
  
  singalized_t_intersection <- read_csv("testing/batch/signalized/signalized_t_intersection_batch.csv")
  singalized_t_intersection_without_signals <- read_csv("testing/batch/signalized/signalized_t_intersection_without_signals_batch.csv")
  
  # street signs ------------------------------------------------------------
  
  street_signs_t_without_signal <- read_csv("testing/batch/street_signs/street_signs_t_without_signal_batch.csv")
  street_signs_give_way <- read_csv("testing/batch/street_signs/street_signs_give_way_batch.csv")
  street_signs_stop_sign <- read_csv("testing/batch/street_signs/street_signs_stop_sign_batch.csv")
  
  street_signs_cross_intersection_without_signals <- read_csv("testing/batch/street_signs/street_signs_cross_intersection_without_signals_batch.csv")
  street_signs_give_way_cross_intersection <- read_csv("testing/batch/street_signs/street_signs_give_way_cross_intersection_batch.csv")
  street_signs_stop_sign_cross_intersection <- read_csv("testing/batch/street_signs/street_signs_stop_sign_cross_intersection_batch.csv")
  
  street_signs_stop_sign_all_way_stop <- read_csv("testing/batch/street_signs/street_signs_stop_sign_all_way_stop_batch.csv")
  street_signs_stop_sign_all_way_stop_without_signals <- read_csv("testing/batch/street_signs/street_signs_stop_sign_all_way_stop_without_signals_batch.csv")
  
  # unsignalized ------------------------------------------------------------
  
  unsignalized_use_crosswalk_without_signals <- read_csv("testing/batch/unsignalized/unsignalized_use_crosswalk_without_signals_batch.csv")
  unsignalized_use_crosswalk <- read_csv("testing/batch/unsignalized/unsignalized_use_crosswalk_batch.csv")

# Compare files -----------------------------------------------------------

# Signalized
compare_files(singalized_cross_intersection_without_signals,singalized_cross_intersection)

compare_files(signalized_one_street_without_signals,signalized_one_street)

compare_files(singalized_t_intersection_without_signals,singalized_t_intersection)

# Street Signs

# Give Way
compare_files(street_signs_t_without_signal,street_signs_give_way)

compare_files(street_signs_cross_intersection_without_signals, street_signs_give_way_cross_intersection)

# Stop Signs
compare_files(street_signs_t_without_signal, street_signs_stop_sign)

compare_files(street_signs_cross_intersection_without_signals,street_signs_stop_sign_cross_intersection)

# All way stop
compare_files(street_signs_stop_sign_all_way_stop_without_signals,street_signs_stop_sign_all_way_stop)

# Crosswalk
compare_files(unsignalized_use_crosswalk_without_signals,unsignalized_use_crosswalk)


