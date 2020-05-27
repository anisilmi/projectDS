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

Untuk Shiny App, terdapat pada directory [HotelReview.](./HotelReview)

Untuk pre-developing Shiny App, dibuat lebih dahulu `model` dan `classiifier` nya dengan `script` yang terdapat pada [Dataset&Classifier](./Dataset&Classifier).
> Extract terlebih dahulu dataset `hotel-reviews.rar` sebelum menjalankan `naivebayes.R`


## Dataset
Dataset yang digunakan didapatkan dari website [Kaggle](https://www.kaggle.com/harmanpreet93/hotelreviews).
