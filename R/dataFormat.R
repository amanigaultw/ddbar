devtools::install_github("amanigaultw/ddbar")

library(ddbar)




rawdata <- data.frame(nationality = sample(c("French", "German", "British"), 100, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
                      sex = sample(c("Male", "Female"), 100, replace=TRUE, prob=c(0.5, 0.5)),
                      age = sample(c("child", "adult", "older adult"), 100, replace=TRUE, prob=c(0.1, 0.7, 0.2)))

data <- data.frame(nationality = sample(c("French", "German", "British"), 100, replace=TRUE, prob=c(0.4, 0.3, 0.3)))



foo <- function(data){

  temp <- table(data[,1])

  as.list(c(names(temp)))

  list(dataGroupId = "root",
       data = list(c("animals", 5, "animals"),
                   c("fruits", 2, "fruits")))

}

temp <- list()
for(i in seq_along(unique(rawdata[,1]))){
  subdata = rawdata[rawdata[,1] == unique(rawdata[,1])[i], -1]
  temp[[i]] <- list(count = nrow(subdata),
                    subdata = subdata)
  names(temp)[i] <- unique(rawdata[,1])[i]
}






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


