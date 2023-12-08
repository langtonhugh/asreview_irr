# Load packages.
library(dplyr)
library(readr)

# Load data.
# first_df <- read.csv("asreview_dataset_citizen-satisfaction-with-police-contact-after-citizen-initiated-contact-a-scoping-review-.csv", sep = ",", na.strings = "")
# secon_df <- read.csv("asreview_dataset_all_literature-review-citizen-satisfaction-with-police_2nd_reviewer.csv", sep = ";", na.strings = "")
first_df <- read_csv("data/asreview_result_spatial-and-temporal-patterning-of-emergency-reactive-police-demand.csv")
secon_df <- read_csv("data/asreview_result_spatial-and-temporal-patterning-of-emergency-reactive-police-demand-2nd-coder.csv")


# Remove the notes col
secon_df <- secon_df %>% 
  # select(-exported_notes_1) %>%      # add if needed.
  mutate(rater_id = 2) 
  # rename(record_id = `ï..record_id`) # add if needed.

# Create rater id for the first rater.
first_df <- first_df %>% 
  mutate(rater_id = 1)

# Bind together.
first_secon_review_df <- bind_rows(first_df, secon_df) %>% 
  mutate(included_new = if_else(is.na(included), 1000, included))

# Create summary table.
compare_df <- first_secon_review_df %>% 
  # group_by(record_id, title) %>%       # add if needed. 
  group_by(record_id, primary_title) %>% # comment out if needed.
  summarise(agreement_number = sum(included_new)) %>% 
  ungroup()

# Check counts.


# Summary table.
table2_summary_df <- count(compare_df, agreement_number) %>%
  mutate(stat = ifelse(agreement_number == 0   , "Both rated irrelevant"                      , NA),
         stat = ifelse(agreement_number == 1   , "One rated relevant, other irrelevant"       , stat),
         stat = ifelse(agreement_number == 2   , "Both rated relevant"                        , stat),
         stat = ifelse(agreement_number == 1000, "One rated irrelevant, other left unreviewed", stat),
         stat = ifelse(agreement_number == 1001, "One rated relevant, other left unreviewed"  , stat),
         stat = ifelse(agreement_number == 2000, "Both left unreviewed"                       , stat)) %>% 
  select(stat, n) %>% 
  rename(Description = stat)



