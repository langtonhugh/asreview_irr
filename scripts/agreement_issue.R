# Load libraries.
library(readr)
library(dplyr)

# Already loads in the data.
first_df <- read_csv("data/annika_data/asreview_dataset_all_B&F for de-implementation of low-value IPC measures - scoping review.csv")
secon_df <- read_csv("data/annika_data/M_asreview_dataset_all_B&F for de-implementation of low-value IPC measures - scoping review.csv")

# List of relevant in first.
first_relevant_vec <- first_df %>% 
  filter(included == 1) %>% 
  purrr::pluck("record_id")

# List of not reviewed in second.
secon_not_reviewed_vec <- secon_df %>% 
  filter(is.na(included)) %>% 
  purrr::pluck("record_id")

# What the matches?
first_df %>% 
  filter(included == 1,
         record_id %in%  secon_not_reviewed_vec) %>% 
  nrow()
  


