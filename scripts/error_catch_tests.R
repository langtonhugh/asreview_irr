# Code testing to check whether the .csv files match.

# Load libraries.
library(readr)
library(dplyr)

# Load them. This is done with file.choose() in the report itself.
first_df <- read_csv("data/asreview_result_spatial-and-temporal-patterning-of-emergency-reactive-police-demand.csv")
secon_df <- read_csv("data/asreview_result_spatial-and-temporal-patterning-of-emergency-reactive-police-demand-2nd-coder.csv")

# If you want the check to simulate a non-match, run this.
secon_df <- secon_df %>% 
  bind_rows(
    sample_n(first_df, 10)
  )

# Run the check.

if (
  FALSE %in% table(sort(first_df$primary_title) == sort(secon_df$primary_title)) == FALSE
) {
  print("Basic check indicates that .csv files match. Proceeding with building the report.")
} else {
  user_answer <- readline("The numbers are no equal. Continue? y/n: ")
  
  if (
    user_answer == "y"
  ) {
    print("You've chosen to continue building the report.")
  }
  
  else {
    knitr::knit_exit()
    print("This should cancel the knit. ")
  }
  
}
