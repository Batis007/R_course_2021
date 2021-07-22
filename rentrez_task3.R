
#Task3
library(rentrez)
#Tutorial https://cran.r-project.org/web/packages/rentrez/vignettes/rentrez_tutorial.html

search_year <- function(year, term){
  query <- paste(term, "AND (", year, "[PDAT])")
  entrez_search(db="pubmed", term=query, retmax=0)$count
}

year <- 2008:2020
papers <- sapply(year, search_year, term="Diplodia", USE.NAMES=FALSE)

plot(year, papers, type='b', main="The Rise of Diplodia")


#Extract the title and date of publication of each paper

diplodia_search <- entrez_search(db = "pubmed",
                              term = "Diplodia",
                              retmax = 236
                              )
diplodia_search
multi_summs <- entrez_summary(db="pubmed", id=diplodia_search$ids)

date_and_title <-
  extract_from_esummary(multi_summs, c("pubdate",  "title"))
new_data_title <- as.data.frame(date_and_title)
new_data_title <- as.data.frame(t(new_data_title))


#term ="Diplodia"
#query <- paste(term, "AND (", year, "[PDAT])")
#query

