# Untuk membuat model dan classifier yang akan digunakan di shiny app

# Load library
library(tidyverse)
library(tm)
library(e1071)
library(caret)

# Load dataset
setwd("D:/KULIAH/SEMESTER_8/3_Rabu/Prak. Data Science/ProjectAkhir/Dataset&Classifier") # set directory sesuai dengan direktori anda
myDataset <- read.csv("hotel-reviews.csv", stringsAsFactors = FALSE)

glimpse(myDataset)

# Ambil kolom description (reviewnya) dan Is_respone (classnya)
hotel_review <- myDataset %>%
  select(text = Description, class = Is_Response)

hotel_review$class <- as.factor(hotel_review$class)

glimpse(hotel_review)

# Ambil 1000 baris per class data untuk sample
happy_review <- hotel_review %>%
  filter(class == "happy") %>%
  sample_n(1000)
  
unhappy_review <- hotel_review %>%
  filter(class == "not happy") %>%
  sample_n(1000)

hotel_review <- rbind(happy_review, unhappy_review)

hotel_review %>% count(class)

view(hotel_review)

# Acak data set biar ga beurutan
set.seed(1)
hotel_review <- hotel_review[sample(nrow(hotel_review)), ]




# CLEANING DATASET

# Mengubah data reviewnya ke bentuk corpus
corpus <- Corpus(VectorSource(hotel_review$text))

# Cleaning
corpus_clean <- corpus %>%
  tm_map(content_transformer(tolower)) %>% 
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords(kind="en")) %>%
  tm_map(stripWhitespace)

corpus[[1]]$content
corpus_clean[[1]]$content

# Mengubah corpus jadi dtm
dtm <- DocumentTermMatrix(corpus_clean)



# Partisi 3:1 data untuk test dan training
hotel_review_train <- hotel_review[1:1500,]
hotel_review_test <- hotel_review[1501:2000,]

corpus_clean_train <- corpus_clean[1:1500]
corpus_clean_test <- corpus_clean[1501:2000]

dtm_train <- dtm[1:1500,]
dtm_test <- dtm[1501:2000,]

dim(dtm_train)
dim(dtm_test)



# Feature Selection, ambil kata yang muncul minimal 5 kali
fiveFreq <- findFreqTerms(dtm_train, 5)

length(fiveFreq)


# set directory tempat simpan feature yg digunakan
setwd("D:/KULIAH/SEMESTER_8/3_Rabu/Prak. Data Science/ProjectAkhir/HotelReview/data")
# save featurenya
saveRDS(fiveFreq, "features.rds")



# Sesuaikan fitur pada data train dan test dengan fitur yang sudah diseleksi sebelumnya
dtm_train_nb <- corpus_clean_train %>%
  DocumentTermMatrix(control=list(dictionary = fiveFreq))

dtm_test_nb <- corpus_clean_test %>%
  DocumentTermMatrix(control=list(dictionary = fiveFreq))

dim(dtm_train_nb)
dim(dtm_test_nb)

# Funsi untuk convert jumlah kemunculan kata jadi yes (ada) dan no (ga ada)
convert_count <- function(x) {
  y <- ifelse(x > 0, 1,0)
  y <- factor(y, levels=c(0,1), labels=c("No", "Yes"))
  y
}

# Apply the convert_count function to get final training and testing DTMs
trainNB <- apply(dtm_train_nb, 2, convert_count)
testNB <- apply(dtm_test_nb, 2, convert_count)

view(testNB)



# Membuat model naive bayes dari data training
classifier <- naiveBayes(trainNB, hotel_review_train$class, laplace = 1)

# set directory tempat simpan model naivebayes nya
setwd("D:/KULIAH/SEMESTER_8/3_Rabu/Prak. Data Science/ProjectAkhir/HotelReview/data")
# save model untuk di gunakan pada aplikasi
save(classifier , file = 'NaiveBayesClassifier.rda')


# test model naivebayes nya
pred <- predict(classifier, newdata=testNB)

# Buat table hasil prediksi
table("Predictions"= pred,  "Actual" = hotel_review_test$class)
  
# Confusion Matrix
conf_mat <- confusionMatrix(pred, hotel_review_test$class)
conf_mat$overall['Accuracy']
