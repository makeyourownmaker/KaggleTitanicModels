
# There is a bug somewhere in the xgbDART method
# Results on Kaggle leaderboard are terrible
#xgbDART.preds  <- predict(xgbDART.fit, as.matrix(test))
#xgbDART.labels <- as.numeric(xgbDART.preds > 0.50)
#xgbDART.submit <- data.frame(PassengerId = test.passengerIds, Survived = xgbDART.labels)
#write.csv(xgbDART.submit, file = "xgbDART-submission.csv", row.names = FALSE)

avNNet.labels <- max.col(predict(t4[[12]]$finalModel, test)) - 1
avNNet.submit <- data.frame(PassengerId = test.passengerIds, Survived = avNNet.labels)
write.csv(avNNet.submit, file = "avNNET_submission.csv", row.names = FALSE)

save.image("KaggleTitanicModels.RData")

