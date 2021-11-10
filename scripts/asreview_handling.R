# Load packages.
library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(irr)
library(kableExtra)

# Load data.
first_df <- read_csv("data/asreview_result_spatial-and-temporal-patterning-of-emergency-reactive-police-demand.csv")
secon_df <- read_csv("data/asreview_result_spatial-and-temporal-patterning-of-emergency-reactive-police-demand-2nd-coder.csv")

# Total reviewed.
first_total <- table(first_df$included)[[2]] + table(first_df$included)[[1]]
secon_total <- table(secon_df$included)[[2]] + table(secon_df$included)[[1]]

# Relevant flags.
first_rele <- table(first_df$included)[[2]]
first_irre <- table(first_df$included)[[1]]

# Irrelevant flags.
secon_rele <- table(secon_df$included)[[2]]
secon_irre <- table(secon_df$included)[[1]]

# Not reviewed
first_unrev <- sum(is.na(first_df$included))
secon_unrev <- sum(is.na(secon_df$included))

# % reviewed.
first_prev <- round(100*first_total/nrow(first_df), 2)
secon_prev <- round(100*secon_total/nrow(secon_df), 2)

# Total irrelevant.
first_trele <- first_irre + first_unrev
secon_trele <- secon_irre + secon_unrev

# % total relevant.
first_ptrel <- round(100*first_rele/nrow(first_df), 2)
secon_ptrel <- round(100*secon_rele/nrow(secon_df), 2)

# % flagged relevant.
first_pfrel <- round(100*first_rele/first_total, 2)
secon_pfrel <- round(100*secon_rele/secon_total, 2)

# Recode 'not rated' as irrelevant in each data frame.
first_rec_df <- first_df %>%
  mutate(included = if_else(is.na(included), true = 0, false = included))

secon_rec_df <- secon_df %>%
  mutate(included = if_else(is.na(included), true = 0, false = included))


# Disagreements 1: first coder says irrelevant, second coder says relevant.

first_irrelevant_vec <- first_rec_df %>% 
  filter(included == 0) %>% 
  pluck("record_id")

disagree1_df <- secon_rec_df %>% 
  filter(included == 1, record_id %in% first_irrelevant_vec) %>% 
  select(record_id, first_authors, publication_year, primary_title, , notes_abstract)

first_dis <- nrow(disagree1_df) # 6

# Disagreement 2: second coder says irrelevant, first coder says relevant.

secon_irrelevant_vec <- secon_rec_df %>% 
  filter(included == 0) %>% 
  pluck("record_id")

disagree2_df <- first_rec_df %>% 
  filter(included == 1, record_id %in% secon_irrelevant_vec) %>% 
  select(record_id, first_authors, publication_year, primary_title, , notes_abstract)

secon_dis <- nrow(disagree2_df) # 39

# Sort and create vectors for Kappa.
first_vec <- first_rec_df %>% 
  arrange(record_id) %>% 
  pluck("included")

secon_vec <- secon_rec_df %>% 
  arrange(record_id) %>% 
  pluck("included")

# Create array for Kappa.
full_array <- cbind(first_vec, secon_vec)

# Agreement.
agree(full_array)

# Kappa.
kappa2(full_array)

# Creating data frame of everything 'relevant' (rater 1 and 2).
relevant_df <- first_rec_df %>% 
  bind_rows(secon_rec_df) %>% 
  filter(included == 1) %>% 
  distinct(record_id, .keep_all = TRUE) %>% 
  mutate(publication_year = str_remove_all(publication_year, "///|//")) 

# Save.
write_csv(x = relevant_df, file = "data/asreview_relevant.csv")

# Creating data frame of everything for handling and comparison with the google results.
# It does not matter whether we use first or second coder df for this.
asreview_clean_df <- first_rec_df %>% 
  select(record_id, primary_title, publication_year, place_published, notes_abstract, first_authors) %>% 
  rename_with(~ paste0("asr_", .x))

# Save.
write_csv(x = asreview_clean_df, file = "data/asreview_clean.csv")
