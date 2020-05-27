library(rvest)

baseUrl <- "https://www.tripadvisor.com"

get_hotel_reviews <- function(hotelUrl) {
  withProgress(message = 'Scrape Tripadvisor', value = 0, {
    
    reviewPage <- read_html(paste(baseUrl, hotelUrl, sep = ""))
    
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
    
    
    while (!is.na(nextPage) & length(reviews) < 500) {
      incProgress(1/100, detail = paste("jumlah review : ", length(reviews)))
      
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
    
    data.frame(Nama = reviewers, Review = reviews, stringsAsFactors = FALSE)
  })
}