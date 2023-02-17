#' Format dataframe for use by ddbar
#'
#' @param data
#'
#' @export
#'
#' @examples
#' rawdata <- data.frame(nationality = sample(c("French", "German", "British"), 100, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
#' sex = sample(c("Male", "Female"), 100, replace=TRUE, prob=c(0.5, 0.5)),
#' age = sample(c("child", "adult", "older adult"), 100, replace=TRUE, prob=c(0.1, 0.7, 0.2)))
#'
#' formattedData <- dataFormat(rawdata)
#'
dataFormat <- function(data){
  dataList <- getDataList(data)
  lapply(dataList[!unlist(lapply(dataList, isTerminal))], toeChartListFormat)
}

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

getDataGroupId <- function(data){
  if (isTerminal(data)) return(NULL)
  if(firstNonUniqueCol(data) == 1) return("1")
  return(paste0(apply(as.data.frame(data[,1:(firstNonUniqueCol(data)-1)]), 2, function(x) unique(x)), collapse = "-"))
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

toeChartListFormat <- function(data){
  dataGroupId = getDataGroupId(data)
  temp <- table(data[,firstNonUniqueCol(data)])
  tempData <- list()
  if(firstNonUniqueCol(data) == ncol(data)){
    for(i in seq_along(temp)) tempData[[i]] <- unname(c(names(temp[i]), temp[i]))
  }else if(firstNonUniqueCol(data) == 1){
    for(i in seq_along(temp)) tempData[[i]] <- unname(c(names(temp[i]), temp[i], names(temp[i])))
  }else{
    for(i in seq_along(temp)) tempData[[i]] <- unname(c(names(temp[i]), temp[i], paste0(c(dataGroupId, names(temp[i])), collapse = "-")))
  }
  list(dataGroupId = dataGroupId,
       data = tempData)
}
