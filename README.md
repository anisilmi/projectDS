# projectDS
Shiny App for Sentiment Analysis of Hotel Reviews on TripAdvisor using Naive Bayes

```
projectDS
├───Dataset&Classifier
│       hotel-reviews.rar
│       naivebayes.R
│       scrapTripadvisor.R
│
└───HotelReview
    │   .Rhistory
    │   app.R
    │   HotelReview.Rproj
    │
    ├───data
    │       features.rds
    │       hotels.rds
    │       NaiveBayesClassifier.rda
    │
    └───helper
            featureExtraction.R
            scrapeHotelReview.R
```

Untuk Shiny App, terdapat pada directory `./HotelReview`.

Untuk pre-developing Shiny App, dibuat terlebih dahulu `model` dan `classiifier` nya dengan `script` yang terdapat pada `./Dataset&Classifier`.
> Extract terlebih dahulu dataset `hotel-reviews.rar` sebelum menjalankan `naivebayes.R`
