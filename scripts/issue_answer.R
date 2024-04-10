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
  # pluck("record_id")
  pluck("primary_title")

# Here, note that ASReview updated their default column names late-2021. Choose the relevant select() option for your data.
disagree1_df <- secon_rec_df %>% 
  filter(included == 1, primary_title %in% first_irrelevant_vec) %>% 
  # select(record_id, authors, year, title, abstract) # For newer projects.
  select(record_id, first_authors, publication_year, primary_title, notes_abstract) # For older projects.

first_dis <- nrow(disagree1_df) # 6

# Disagreement 2: second coder says irrelevant, first coder says relevant.

secon_irrelevant_vec <- secon_rec_df %>% 
  filter(included == 0) %>% 
  # pluck("record_id")
  pluck("primary_title")

# Here, note that ASReview updated their default column names late-2021. Choose the relevant select() option for your data.
disagree2_df <- first_rec_df %>% 
  filter(included == 1, primary_title %in% secon_irrelevant_vec) %>% 
  # select(record_id, authors, year, title, abstract) # For newer projects.
  select(record_id, first_authors, publication_year, primary_title, notes_abstract) # For older projects.

secon_dis <- nrow(disagree2_df) # 39

# Sort and create vectors for Kappa.
first_vec <- first_rec_df %>% 
  # arrange(record_id) %>% 
  arrange(primary_title) %>%
  pluck("included")

secon_vec <- secon_rec_df %>% 
  # arrange(record_id) %>% 
  arrange(primary_title) %>%
  pluck("included")

# Create array for Kappa.
full_array <- cbind(first_vec, secon_vec)

# Further disgareement statistics.

# Identify those which each reviewer did not even look at.
first_dist_vec <- first_rec_df %>% 
  filter(included == 3) %>% 
  # pluck("record_id")
  pluck("primary_title")

secon_dist_vec <- secon_rec_df %>% 
  filter(included == 3) %>% 
  # pluck("record_id")
  pluck("primary_title")

# Identify those relevant by one rather, and unreviewed by the other.
first_dist_df <- first_rec_df %>% 
  filter(included == 1) %>% 
  mutate(missed = if_else(record_id %in% secon_dist_vec,
                          "missed",
                          "not missed"))

secon_dist_df <- secon_rec_df %>% 
  filter(included == 1) %>% 
  mutate(missed = if_else(record_id %in% secon_dist_vec,
                          "missed",
                          "not missed"))

# How many studies did one rather say *relevcant* and the other reviewer
# not even review?
missed1 <- nrow(first_dist_df) - table(first_dist_df$missed)[[1]]
missed2 <- nrow(secon_dist_df) - table(secon_dist_df$missed)[[1]]

# Table.
tibble(
  ` ` = c("n uploaded", 
          "n reviewed",
          "% reviewed",
          "n flagged relevant",
          "n flagged irrelevant",
          "% flagged relevant",
          "n unreviewed",
          "n total irrelevant",
          "% total relevant",
          "n relevant v. irrelevant",
          "n relevant v. unreviewed"),
  `rater 1` = c(nrow(first_df),
                first_total,
                first_prev,
                first_rele,
                first_irre,
                first_pfrel,
                first_unrev,
                first_trele,
                first_ptrel,
                first_dis,
                missed1),
  `rater 2` = c(nrow(secon_df),
                secon_total,
                secon_prev,
                secon_rele,
                secon_irre,
                secon_pfrel,
                secon_unrev,
                secon_trele,
                secon_ptrel,
                secon_dis,
                missed2)
)

# Kappa.
agree(full_array)
kappa2(full_array)
