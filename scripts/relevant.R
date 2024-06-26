# Load packages
library(readxl)
library(readr)
library(dplyr)
library(stringr)

# Load in the reviewed workbook, with a new variable indicating relevant or irrelevant.
google_reviewed_df <- read_xlsx("data/google_results_non_dup.xlsx")

# 61 relevant studies.
google_reviewed_df %>% 
  group_by(relevant) %>% 
  tally()

# Subset.
google_relevant_df <- google_reviewed_df %>% 
  filter(relevant == 1)

# Load in relevant asreview.
asr_relevant_df <- read_csv(file = "data/asreview_relevant.csv")

# Clean both for a row bind.
asr_relevant_clean_df <- asr_relevant_df %>% 
  select(record_id, primary_title, publication_year, alternate_title3, first_authors) %>% 
  rename(asr_goog_id = record_id, title = primary_title, year = publication_year, journal = alternate_title3, authors = first_authors) %>% 
  mutate(database = "asreview")

google_relevant_clean_df <- google_relevant_df %>% 
  select(google_id, google_title, google_year, google_source, google_authors) %>%
  rename_with(str_remove_all, pattern = "google_") %>% 
  rename(asr_goog_id = id,
         journal = source) %>% 
  mutate(database = "google")

# Row bind and try to standardise format a bit.
relevant_clean_df <- asr_relevant_clean_df %>% 
  bind_rows(google_relevant_clean_df) %>%
  mutate(journal = str_to_title(journal)) 

# How many?
nrow(relevant_clean_df) # 182

count(relevant_clean_df, database)


# Save. This is then 'Save As' an Excel workbook for manual data input for the full-text eligibility stage.
write_csv(x = relevant_clean_df, file = "data/asr_google_relevant.csv")