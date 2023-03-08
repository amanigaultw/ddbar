applyFilterVector <- function(data, filterVector){
  if(!is.null(filterVector) && length(filterVector) > 0){
    for(i in seq_along(filterVector)){
      data <- data[data[,i] == filterVector[i], ]
    }
  }
  data
}
