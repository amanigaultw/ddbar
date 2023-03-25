#' Format a given dataframe for use by ddbar
#'
#' @param data input dataframe
#' @param FUN aggregation function; must return a single numeric value.
#' When \code{aggMode = "count"}, may remain null;
#' When \code{aggMode = "vector"}, will take the last column of \code{data} as input;
#' When \code{aggMode = "dataframe"}, will take \code{data} as input;
#' @param mode aggregation mode. "count", "vector" or "dataframe" options may be used.
#' @param filterVars a character vector of column names to be used as filter variables.
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
#' filterVars <- c("nationality", "sex", "age")
#'
#' formattedData1 <- dataFormat(rawdata)
#'
#' rawdata2 <- data.frame(rawdata,
#'                        x1 = rnorm(100),
#'                        x2 = rnorm(100),
#'                        IQ = round(rnorm(100, mean = 100, sd = 10), 0))
#'
#' formattedData2 <- dataFormat(rawdata2, mean,
#'                              mode = "vector", filterVars = filterVars)
#'
#' getMeanDiffx1x2 <- function(dataframe) mean(dataframe$x1 - dataframe$x2, na.rm = TRUE)
#'
#' formattedData3 <- dataFormat(rawdata2, getMeanDiffx1x2,
#'                              mode = "dataframe", filterVars = filterVars)
#'
dataFormat <- function(data, FUN = NULL, mode = "count", filterVars = NULL, delimiter = "|", na.action = "omit"){

  #check mode input
  stopifnot("invalid mode input" = mode %in% c("count", "vector", "dataframe"))

  #save a copy of the input data and generate the plot data
  rawdata <- plotData <- data
  if(!is.null(filterVars)) plotData <- rawdata[, filterVars]

  #check input plotData
  if(any(is.na(plotData[, !sapply(plotData, is.numeric)]))){
    plotData <- handleMissingData(plotData, na.action)
  }
  #reformat plotData
  dataList <- getDataList(plotData)
  lapply(dataList[!unlist(lapply(dataList, isTerminal))], toeChartListFormat, rawdata, FUN, mode, delimiter)
}
#' Handles missing values in the input dataframe
#'
#' @inheritParams dataFormat
#'
#' @export
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

toeChartListFormat <- function(data, rawdata, FUN, mode, delimiter){
  dataGroupId = getDataGroupId(data, delimiter)
  namedValueVector <- getNamedValueVector(data, rawdata, FUN, mode)
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


getNamedValueVector <- function(data, rawdata, FUN, mode){
  switch (mode,
    "count" = getCount(data),
    "vector" = applyVectorFUN(data, rawdata, FUN),
    "dataframe" = applyDataframeFUN(data, rawdata, FUN)
  )
}

getCount <- function(data){
  table(data[,firstNonUniqueCol(data)])
}

applyVectorFUN <- function(data, rawdata, FUN){
  #default to computing a sum if FUN is null
  if(is.null(FUN)) FUN <- function(x) sum(x, na.rm = T)
  #add non-filter variables back into data prior to aggregation by FUN
  if(ncol(data) < ncol(rawdata)){
    data <- merge(data, rawdata[,!colnames(rawdata) %in% colnames(data)], by = 0)
    rownames(data) <- data[,1]
    data <- data[,-1]
  }
  #aggregate
  temp <- stats::aggregate(data[,ncol(data)], by = list(data[, firstNonUniqueCol(data)]), FUN)
  #format output
  namedValueVector <- temp[,2]
  names(namedValueVector) <- temp[,1]
  return(namedValueVector)
}

applyDataframeFUN <- function(data, rawdata, FUN){
  temp <- split(data, data[, firstNonUniqueCol(data)])
  temp <- lapply(temp, function(x) merge(x, rawdata[,!colnames(rawdata) %in% colnames(x)], by = 0))
  namedValueVector <- sapply(temp, FUN)
  return(namedValueVector)
}
