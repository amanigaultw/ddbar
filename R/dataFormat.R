#' Format a given dataframe for use by ddbar
#'
#' @param data input dataframe
#' @param FUN aggregation function
#' @param delimiter string delimiter for the dataGroupId
#' @param na.action string indicating how missing data should be handled. "omit" or "label" options may be used.
#'
#' @export
#'
#' @examples
#' rawdata <- data.frame(nationality = sample(c("French", "German", "British"),
#'                       100, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
#'                       sex = sample(c("Male", "Female"),
#'                       100, replace=TRUE, prob=c(0.5, 0.5)),
#'                       age = sample(c("child", "adult", "older adult"),
#'                       100, replace=TRUE, prob=c(0.1, 0.7, 0.2)))
#'
#' formattedData <- dataFormat(rawdata)
#'
#' rawdata2 <- data.frame(rawdata,
#'                        IQ = round(rnorm(100, mean = 100, sd = 10), 0))
#'
#' formattedData2 <- dataFormat(rawdata2)
#'
dataFormat <- function(data, FUN = NULL, delimiter = "|", na.action = "omit"){
  #check input data
  if(any(is.na(data[, !sapply(data, is.numeric)]))){
    data <- handleMissingData(data, na.action)
  }
  #reformat data
  dataList <- getDataList(data)
  lapply(dataList[!unlist(lapply(dataList, isTerminal))], toeChartListFormat, FUN, delimiter)
}

handleMissingData <- function(data, na.action){

  if(na.action == "omit"){
    initialRowCount <- nrow(data)
    data <- data[rowSums(is.na(data[, !sapply(data, is.numeric)])) == 0,]
    stopifnot("Too much missing data to generate a valid drill down plot" = nrow(data) > 0)
    warning(paste(initialRowCount - nrow(data), "rows were dropped due to missing values."))
  }

  if(na.action == "label"){
    for(i in seq_along(data[, !sapply(data, is.numeric)])){
      data[, !sapply(data, is.numeric)][,i][is.na(data[, !sapply(data, is.numeric)][,i])] <- paste0(names(data[, !sapply(data, is.numeric)][i]), ": missing")
    }
  }

  return(data)
}

firstNonUniqueCol <- function(data){
  data <- data[, !sapply(data, is.numeric)]
  for(i in 1:ncol(data)){
    if(length(unique(data[,i])) == 1) next
    return(i)
  }
}

isTerminal <- function(data){
  data <- data[, !sapply(data, is.numeric)]
  if(is.null(firstNonUniqueCol(data))) return(TRUE)
  return(FALSE)
}

getDataGroupId <- function(data, delimiter){
  if (isTerminal(data)) return(NULL)
  if(firstNonUniqueCol(data) == 1) return("")
  return(paste0(apply(as.data.frame(data[,1:(firstNonUniqueCol(data)-1)]), 2, function(x) unique(x)), collapse = delimiter))
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

toeChartListFormat <- function(data, FUN, delimiter){
  dataGroupId = getDataGroupId(data, delimiter)
  namedValueVector <- getNamedValueVector(data, FUN)
  dataFormatted <- list()
  if(firstNonUniqueCol(data) == ncol(data[, !sapply(data, is.numeric)])){
    for(i in seq_along(namedValueVector)) dataFormatted[[i]] <- unname(c(names(namedValueVector[i]), namedValueVector[i]))
  }else if(firstNonUniqueCol(data) == 1){
    for(i in seq_along(namedValueVector)) dataFormatted[[i]] <- unname(c(names(namedValueVector[i]), namedValueVector[i], names(namedValueVector[i])))
  }else{
    for(i in seq_along(namedValueVector)) dataFormatted[[i]] <- unname(c(names(namedValueVector[i]), namedValueVector[i], paste0(c(dataGroupId, names(namedValueVector[i])), collapse = delimiter)))
  }
  for(i in seq_along(dataFormatted)){
    if(isTerminal(data[data[,firstNonUniqueCol(data)] == dataFormatted[[i]][1],])) dataFormatted[[i]] <- dataFormatted[[i]][1:2]
  }
  list(dataGroupId = dataGroupId,
       data = dataFormatted)
}


getNamedValueVector <- function(data, FUN){
  if(is.character(data[, ncol(data)])) return(table(data[,firstNonUniqueCol(data)]))
  if(is.null(FUN)) FUN <- function(x) sum(x, na.rm = T)
  temp <- stats::aggregate(data[,ncol(data)], by = list(data[, firstNonUniqueCol(data)]), FUN)
  namedValueVector <- temp[,2]
  names(namedValueVector) <- temp[,1]
  return(namedValueVector)
}
