ASReview material for a scoping review.

The .Rmd file will automatically produce a summary report (.html) on the level of agreement between two raters.

Step 1: Download and save the .csv outputs from ASReview into the 'data' folder.  
Step 2: Open up the asreview_irr.Rproj in RStdudio.  
Step 3: Open report_example.Rmd and change the .csv file names accordingly, so it loads in your data.  
Step 4: Knit the report.  

A number of descriptives are produced in the report, including the number of abstracts reviewed, the number flagged as relevant, the number left unreviewed, the Kappa statistic, and the number of abstracts for which researchers A and B disagreed (e.g., A said relevant, B said irrelevant). In the final case, tables are produced which detail the specific literature involved.

The report also identifies the number of cases in which there was disagreement 'implicitly'. This is when one researcher rates an abstract as relevant, but the other researcher never reviews that abstract. Ideally, this number is zero for both raters.
The report is a work in progress. I would appreciate any checks, feedback, comparisons to your own findings, and suggestions for other features the report could include.

Thanks to Roos Jansen, Amy Nivette, Amina op de Weegh, Stijn Ruiter, and the ASReview team for feedback on improving this report.
