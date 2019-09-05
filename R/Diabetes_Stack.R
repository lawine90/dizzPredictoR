#' Pre-trained ensemble model for diabetes prediction.
#'
#' Using 7th Korea National Health and Nutrition Examination Survey in 2016,
#' build pre-trained ensemble model for diabetes predicting. 6 models are used and
#' average AUC is about 0.72. But this pre-trained models have terrible performance
#' for predicting not normal(F1 0.4), so do not take the result seriously.
#'
#' @docType data
#'
#' @usage data("Diabetes_Stack")
#'
#' @keywords datasets
#'
#' @examples
#' data("Diabetes_Stack")
"Diabetes_Stack"
