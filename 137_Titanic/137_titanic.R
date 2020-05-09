setwd("C:/Users/admin/Desktop/137_Titanic")

## Load the datasets
titanic_train = read.csv("137_titanic_train.csv")
titanic_test = read.csv("137_titanic_test.csv")

## Setting Survived column for test data to NA
titanic_test$Survived <- NA

## Combining Training and Testing dataset
complete_data <- rbind(titanic_train, titanic_test)
LT=dim(titanic_train)[1]

## Check data structure
str(complete_data)

## Let's check for any missing values in the data
colSums(is.na(complete_data))

## Checking for empty values
colSums(complete_data=='')

## Check number of uniques values for each of the column to find out columns which we can convert to factors
sapply(complete_data, function(x) length(unique(x)))

## Missing values imputation
complete_data$Embarked[complete_data$Embarked==""] <- "S"
complete_data$Age[is.na(complete_data$Age)] <- median(complete_data$Age,na.rm=T)

## Removing Cabin as it has very high missing values, passengerId, Ticket and Name are not required
library(dplyr)
titanic_data <- complete_data %>% select(-c(Cabin, PassengerId, Ticket, Name))

## Converting "Survived","Pclass","Sex","Embarked" to factors
for (i in c("Survived","Pclass","Sex","Embarked")){
  titanic_data[,i]=as.factor(titanic_data[,i])
}


## Create dummy variables for categorical variables
library(dummies)
titanic_data <- dummy.data.frame(titanic_data, names=c("Pclass","Sex","Embarked"), sep="_")

dim(titanic_data)

## Splitting training and test data
set.seed(220)
train <- titanic_data[1:667,]
test <- titanic_data[668:889,]

## Model Creation
model <- glm(Survived ~.,data = train,family = binomial(link = "logit"))

View(titanic_data)
View(train)
View(test)
## Model Summary
summary(model)
predict_survival <- predict(model, test, type = "response")
titanic_test$Survived <- predict_survival
summary(titanic_test$Survived)
titanic_test$Survived <- round(predict_survival)
table(titanic_test$Survived)

## Using anova() to analyze the table of devaiance
anova(model, test="Chisq")


# fitting of logistic regression when considering only the statistically significant predictors
model <- glm(Survived~.-Parch-Fare, family = binomial(link = "logit"),data = train)
# summary of the fitted model
summary(model)


# analysis of variance table of the fitted model
anova(model, test = "Chisq")


# prediction of the response on the basis of fitted model
predict <- predict(model,newdata = test,type = "response")
# checking the accuracy
library(caret)
predict <- ifelse(predict > 0.5,1,0)
error <- mean(predict != test$Survived)
print(paste('Accuracy',1-error))



## Predicting Test Data
result <- predict(model,newdata=test,type='response')
result <- ifelse(result > 0.5,1,0)

## Confusion matrix and statistics
library(caret)
expected <- factor(result)
predicted <- factor(test$Survived)
confusionMatrix(data = predicted, reference = expected)
str(result)
levels(result)
str(test$Survived)
levels(test$Survived)
library(ROCR)
predictions <- predict(model, newdata=test, type="response")
ROCRpred <- prediction(predictions, test$Survived)
ROCRperf <- performance(ROCRpred, measure = "tpr", x.measure = "fpr")
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7), print.cutoffs.at = seq(0,1,0.1))

auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc


library(dplyr)
library(ggplot2)
qplot(Age, Fare, data=complete_data)

qplot(Age, Fare, data=complete_data, colour=Pclass)

complete_data <- complete_data %>% mutate(Pclass.factor = as.factor(Pclass), 
                              Survived.factor = as.factor(Survived),
                              age.group = cut(Age, breaks=seq(0,90,10))
)

summary(complete_data)

qplot(Age, Fare, data=complete_data, colour=Pclass.factor)

qplot(Age, Fare, data=complete_data, colour=Pclass.factor, facets=.~Embarked)

qplot(Age, Fare, data=complete_data, colour=Pclass.factor, facets=Sex~Embarked)

ggplot(complete_data, aes(x=Age, y=Fare, color=Pclass.factor)) + geom_point() + facet_grid(Sex~Embarked)

#Assign graph to a variable 
g <- ggplot(complete_data, aes(Age, Fare))

g <- ggplot(complete_data, aes(Age))
g + geom_histogram(aes(fill=Sex))
g + geom_histogram(aes(fill=Embarked))
g + geom_histogram(aes(fill=Pclass.factor))
g + geom_histogram(aes(fill=Survived.factor))
g + geom_density()
g + geom_density(aes(fill=Sex))
g + geom_density(aes(fill=Sex), alpha=0.3)

ggplot(complete_data, aes(Sex, Age)) + geom_boxplot()
ggplot(complete_data, aes(Age, Pclass.factor)) + geom_boxplot()
ggplot(complete_data, aes(Age,Survived)) + geom_boxplot()

ggplot(complete_data, aes(Pclass.factor, fill=Sex))+geom_bar()
ggplot(complete_data, aes(Pclass.factor, fill=Survived.factor))+geom_bar()

( sum(titanic_train$Survived) / nrow(titanic_train) ) %>% round(4)  * 100 #  data %>% mean (is equivalent to) mean(data)

ggplot(data=complete_data[1:LT,],aes(x=Sex,fill=Survived.factor))+geom_bar()
ggplot(data = complete_data[1:LT,],aes(x=Embarked,fill=Survived.factor))+geom_bar(position="fill")+ylab("Frequency")

