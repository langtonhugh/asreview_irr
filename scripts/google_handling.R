# Load packages.
library(readr)
library(dplyr)
library(janitor)
library(stringr)

# Useful function/
`%nin%` <- Negate(`%in%`)

# Load studies used in ASReview, cleaned up in asreview_handling.r script.
asreview_clean_df <- read_csv("data/asreview_clean.csv")

# Load Google search results.
google_df <- read_csv("data/google_results.csv")

# How many?
nrow(google_df)
nrow(asreview_clean_df)

# Simplify google for easier comaprison.
google_df <- google_df %>% 
  mutate(id = 1:nrow(.)) %>% 
  clean_names() %>% 
  select(id, title, year, source, abstract, authors) %>% 
  rename_with(~ paste0("google_", .x))

# Names.
names(asreview_clean_df)
names(google_df)  

# Basic but *safe* deletion of duplicate studies between ASReview relevant and google.
# Vector of titles and simplify to avoid differences over punctuation/capitals.
asreview_clean_vec <- asreview_clean_df$asr_primary_title
asreview_clean_simple_vec <- asreview_clean_vec %>% 
  str_to_lower() %>% 
  str_replace_all("[[:punct:]]", "")

# Filter these out from google. First, simplify as above, then filter.
google_sub_df <- google_df %>% 
  mutate(google_title_simple = str_to_lower(google_title),
         google_title_simple = str_replace_all(google_title_simple, "[[:punct:]]", "")) %>% 
  filter(google_title_simple %nin% asreview_clean_simple_vec) %>% 
  arrange(google_id) 

# How many deleted? These are studies found in both google and asreview (identified so far).
nrow(google_df) - nrow(google_sub_df) # 180 studies

# Save raw data as csv for review in Excel (800 to review).
# We then 'save as' an Excel workbook for review, leaving this csv untouched.
write_csv(x = google_sub_df, file = "data/google_results_non_dup.csv")