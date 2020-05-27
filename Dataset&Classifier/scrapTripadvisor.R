# Untuk nyoba scraping data review pada website tripadvisor sebelum diterapkan pada shiny
# Penerapan pada shiny dapat dilihat di ../HotelReview/helper/scrapeHotelReview.R

# Import library
library(rvest)

# Ambil nama hotel dan url nta
baseUrl <- "https://www.tripadvisor.com"
hotelsUrl <- "/Hotels-g294230-Yogyakarta_Region_Java-Hotels.html"
url <- paste(baseUrl, hotelsUrl, sep = "")
webpage <- read_html(url)

hotelName <- webpage %>% html_nodes('[data-clicksource="HotelName"]') %>% html_text()
hotelReviewURL <- webpage %>% html_nodes('[data-clicksource="ReviewCount"]') %>% html_attr('href')

hotels <- data.frame(name = hotelName, link = hotelReviewURL, stringsAsFactors = FALSE)

view(hotels)

# set direktori untuk simpan data
setwd("D:/KULIAH/SEMESTER_8/3_Rabu/Prak. Data Science/ProjectAkhir/HotelReview/data")
# simpan data
saveRDS(hotels, "hotels.rds")





# Cara ngambil semua review dari hotel pertama (diterapkan di shinynya)
hotels$name[1]
reviewUrl <- paste(baseUrl, hotels$link[1], sep = "")
reviewPage <- read_html(reviewUrl)

review <- reviewPage %>%
  html_nodes('.location-review-review-list-parts-ExpandableReview__reviewText--gOmRC') %>%
  html_text()

reviewer <- reviewPage %>%
  html_nodes('.social-member-event-MemberEventOnObjectBlock__member--35-jC') %>%
  html_text()

reviews <- character()
reviewers <- character()
reviews <- c(reviews, review)
reviewers <- c(reviewers, reviewer)

nextPage <- reviewPage %>%
  html_nodes('.next') %>%
  html_attr('href')


view(datareview)

while (!is.na(nextPage)) {
  reviewUrl <- paste(baseUrl, nextPage, sep = "")
  reviewPage <- read_html(reviewUrl)
  
  review <- reviewPage %>%
    html_nodes('.location-review-review-list-parts-ExpandableReview__reviewText--gOmRC') %>%
    html_text()
  
  reviewer <- reviewPage %>%
    html_nodes('.social-member-event-MemberEventOnObjectBlock__member--35-jC') %>%
    html_text()
  
  reviews <- c(reviews, review)
  reviewers <- c(reviewers, reviewer)
  
  nextPage <- reviewPage %>%
    html_nodes('.next') %>%
    html_attr('href')
}
datareview <- data.frame(reviews, reviewers, stringsAsFactors = FALSE)

length(reviews)
View(reviews)