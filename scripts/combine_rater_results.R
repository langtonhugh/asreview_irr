# Load packages.
library(dplyr)

# Load data.
first_df <- read.csv("asreview_dataset_citizen-satisfaction-with-police-contact-after-citizen-initiated-contact-a-scoping-review-.csv", sep = ",", na.strings = "")
secon_df <- read.csv("asreview_dataset_all_literature-review-citizen-satisfaction-with-police_2nd_reviewer.csv", sep = ";", na.strings = "")

# Remove the notes col.
secon_df <- secon_df %>% 
  select(-exported_notes_1) %>% 
  mutate(rater_id = 2) %>% 
  rename(record_id = `ï..record_id`)

# Create rater id for the first rater.
first_df <- first_df %>% 
  mutate(rater_id = 1)

# Bind together.
first_secon_review_df <- bind_rows(first_df, secon_df) %>% 
  mutate(included_new = if_else(is.na(included), 1000, included))

# Create summary table.
compare_df <- first_secon_review_df %>% 
  group_by(record_id, title) %>% 
  summarise(agreement_number = sum(included_new))

# Check counts.
table(compare_df$agreement_number)
