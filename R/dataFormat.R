rm(list = ls())

rawdata <- data.frame(nationality = sample(c("French", "German", "British"), 100, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
                      sex = sample(c("Male", "Female"), 100, replace=TRUE, prob=c(0.5, 0.5)),
                      age = sample(c("child", "adult", "older adult"), 100, replace=TRUE, prob=c(0.1, 0.7, 0.2)))

firstNonUniqueCol <- function(data){
  for(i in 1:ncol(data)){
    if(length(unique(data[,i])) == 1) next
    return(i)
  }
}

isTerminal <- function(data){
  if(is.null(firstNonUniqueCol(data))) return(TRUE)
  return(FALSE)
}

getDataList <- function(rawdata){
  todo <- list(rawdata)
  done <- list()
  while(length(todo) > 0){
    for(i in seq_along(todo)){
      data <- todo[[i]]
      done <- append(done, list(data))
      col = firstNonUniqueCol(data)
      for(j in seq_along(unique(data[,col]))){
        todo <- append(todo, list(data[data[,col] == unique(data[,col])[j],]))
      }
    }
    todo <- todo[!todo %in% done]
  }
  done
}

dataList <- getDataList(rawdata)


data <- dataList[[2]]

getDataGroupId <- function(data){
  if(firstNonUniqueCol(data) == 1){
    return("root")
  }
  else{
    col <- firstNonUniqueCol(data)
    for(i in seq_along(1:(col - 1))){
      temp <- apply(data[,1:i], 1, function(x) paste(x, collapse = "-"))
    }
  }
}





toeChartListFormat <- function(data){


}






devtools::install_github("amanigaultw/ddbar")

library(ddbar)


data = list(list(dataGroupId = "1",
                 data = list(c("animals", 5, "animals"),
                             c("fruits", 2, "fruits"))),
            list(dataGroupId = "animals",
                 data = list(c("cats", 6, "cats"),
                             c("dogs", 8, "dogs"))),
            list(dataGroupId = "fruits",
                 data = list(c("apples", 1),
                             c("oranges", 3))),
            list(dataGroupId = "cats",
                 data = list(c("calico cats", 10),
                             c("american short hair cats", 9))),
            list(dataGroupId = "dogs",
                 data = list(c("pugs", 12, "pugs"),
                             c("german shepherds", 7))),
            list(dataGroupId = "pugs",
                 data = list(c("brown pugs", 3),
                             c("black pugs", 1)))
)

ddbar(data)


