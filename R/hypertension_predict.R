#' Predicting risk probability of get Hypertension.
#'
#' mle_gamma function will calculate mle estimate for the shape parameter
#' "k" and the scale parameter "theta" by using given sample. Since there is no closed form of the mle for gamma distribution, mle_gamma used uniroot function from stats package.
#'
#' @param mode select mode, "insert" or "dataframe".
#' @param dataframe if argument mode is "dataframe", dataframe argument should not be NULL.
#'
#' @return probabilities of get disease.
#'
#' @details If argument "mode" is dataframe, you should be set column name correctly.\cr
#'  Explanation of columns will followed.\cr
#'  "sex_m": gender of sample. if sample is male, set 1 else, 0.\cr
#'  "age": age of sample.\cr
#'  "S_CT": amount of smoking per day.\cr
#'  "D_YF": frequency of drinking per month.\cr
#'  "D_AT": amount of drinking per once.\cr
#'  "D_DD": frequency of dringking badly(over 7 glasses in soju).\cr
#'  "E_BR": frequency of having breakfast per week.\cr
#'  "E_LN": frequency of having lunch per week.\cr
#'  "E_DN": frequency of having dinner per week.
#'
#' @examples
#'   data <- data.frame(
#'     sex_m = c(0, 1),
#'     age = c(20, 29),
#'     S_CT = c(0, 10),
#'     D_YF = c(1, 3),
#'     D_AT = c(3, 7),
#'     D_DD = c(0, 1),
#'     E_BR = c(3, 0),
#'     E_LN = c(7, 5),
#'     E_DN = c(3, 0)
#'   )
#'   test <- hypertension_predict("dataframe", data)
#' @export

hypertension_predict <- function(mode, dataframe = NULL){
  if(!(mode %in% c('insert', 'dataframe'))){
    stop("mode argument should be one of \"insert\" or \"dataframe\".")
  }

  Hypertension_Models <- dizzPredictoR::Hypertension_Models
  Hypertension_Stack <- dizzPredictoR::Hypertension_Stack
  Hypertensions <- dizzPredictoR::Hypertensions
  if(mode == 'insert'){
    # simple explanation.
    cat("Please answer simple questions.\n\n"); Sys.sleep(5)

    # gender.
    cat("Q1) About your gender.\n")
    sex_m <- readline("What is your gender?(Type 'male' or 'female')  ")
    sex_m <- dplyr::if_else(sex_m == 'male', 1, 0)
    cat("\n\n")

    # age.
    cat("Q2) About your age.\n")
    age <- readline("How old are you?(Example: 29)  ")
    cat("\n\n")

    # smoking amount a day.
    cat("Q3) About smoking habit.\n")
    S_CT <- readline("How much do you smoke per day? If you are not smoker, type 0.  ")
    cat("\n\n")

    # drink.
    cat("Q4) About drinking habit.\n")
    D_YF <- readline("How many days do you drink per month?  ")
    D_AT <- readline("How many glasses do you drink per once?  ")
    D_DD <- readline("How many days do you drink too much(over 7 glasses) per month?  ")
    cat("\n\n")

    # eating habit.
    cat("Q4) About your eating habbit.\n")
    E_BR <- readline("How many days do you have breakfast per week?  ")
    E_LN <- readline("How many days do you have lunch per week?  ")
    E_DN <- readline("How many days do you have dinner per week?  ")
    cat("\n\n")

    # user_data.
    new_data <- data.frame(
      sex_m = scale(sex_m, center = mean(Hypertensions$sex_m), scale = stats::sd(Hypertensions$sex_m)),
      age = scale(as.numeric(age), center = mean(Hypertensions$age), scale = stats::sd(Hypertensions$age)),
      S_CT = scale(as.numeric(S_CT), center = mean(Hypertensions$S_CT), scale = stats::sd(Hypertensions$S_CT)),
      D_YF = scale(as.numeric(D_YF), center = mean(Hypertensions$D_YF), scale = stats::sd(Hypertensions$D_YF)),
      D_DD = scale(as.numeric(D_DD), center = mean(Hypertensions$D_DD), scale = stats::sd(Hypertensions$D_DD)),
      D_AT = scale(as.numeric(D_AT), center = mean(Hypertensions$D_AT), scale = stats::sd(Hypertensions$D_AT)),
      E_BR = scale(as.numeric(E_BR), center = mean(Hypertensions$E_BR), scale = stats::sd(Hypertensions$E_BR)),
      E_LN = scale(as.numeric(E_LN), center = mean(Hypertensions$E_LN), scale = stats::sd(Hypertensions$E_LN)),
      E_DN = scale(as.numeric(E_DN), center = mean(Hypertensions$E_DN), scale = stats::sd(Hypertensions$E_DN))
    )

    # prediction.
    pred_result <- 1-predict(Hypertension_Stack, new_data, type = "prob")
    pred_result_p <- paste(round(pred_result, 4) * 100, "%", sep = "")
    if(pred_result >= 0.7){pred_result_p <- crayon::bgRed(pred_result_p)
    }else if(pred_result >= 0.3){pred_result_p <- crayon::bgYellow(pred_result_p)
    }else{pred_result_p <- crayon::bgGreen(pred_result_p)}

    pred_results <- dplyr::bind_rows(lapply(Hypertension_Models, caret::predict.train, newdata = new_data, type = "prob"))

    predictor_count <- sum(pred_results$X1 >= 0.5)
    predictor_max <- round(max(pred_results), 4)*100

    # print summary.
    cat("Hypertension Prediction Result.\n")
    cat("Among 6 predictors, ", predictor_count, " predictor judged YOU are in hypertension.\n", sep = "")
    cat("Among 6 predictors, maximum risk probability is ", predictor_max, "%.\n", sep = "")
    cat("\n")
    cat("Hypertension Possibility:", pred_result_p, "\n\n\n")

    # object to return.
    final_result <- list(
      Disease = "Hypertension.",
      Probability = pred_result,
      Predictors = pred_results
    )
  }
  else if(mode == "dataframe"){
    dataframe <- data.frame(
      sex_m = scale(dataframe$sex_m, center = mean(Hypertensions$sex_m), scale = stats::sd(Hypertensions$sex_m)),
      age = scale(dataframe$age, center = mean(Hypertensions$age), scale = stats::sd(Hypertensions$age)),
      S_CT = scale(dataframe$S_CT, center = mean(Hypertensions$S_CT), scale = stats::sd(Hypertensions$S_CT)),
      D_YF = scale(dataframe$D_YF, center = mean(Hypertensions$D_YF), scale = stats::sd(Hypertensions$D_YF)),
      D_DD = scale(dataframe$D_DD, center = mean(Hypertensions$D_DD), scale = stats::sd(Hypertensions$D_DD)),
      D_AT = scale(dataframe$D_AT, center = mean(Hypertensions$D_AT), scale = stats::sd(Hypertensions$D_AT)),
      E_BR = scale(dataframe$E_BR, center = mean(Hypertensions$E_BR), scale = stats::sd(Hypertensions$E_BR)),
      E_LN = scale(dataframe$E_LN, center = mean(Hypertensions$E_LN), scale = stats::sd(Hypertensions$E_LN)),
      E_DN = scale(dataframe$E_DN, center = mean(Hypertensions$E_DN), scale = stats::sd(Hypertensions$E_DN))
    )

    pred_result <- data.frame(prob = 1-predict(Hypertension_Stack, dataframe, type = "prob"))
    pred_result$class <- ifelse(pred_result$prob >= 0.5, "hypertension", "normal")

    pred_results <- lapply(Hypertension_Models, caret::predict.train, newdata = dataframe, type = "prob")
    pred_results <- lapply(pred_results, function(x) tibble::rownames_to_column(x, "ID"))
    #pred_results <- lapply(pred_results, function(x) dplyr::mutate(x, model = names(x)))
    pred_results <- dplyr::bind_rows(pred_results)

    final_result <- list(
      Disease = "Hypertension.",
      Probability = pred_result,
      Predictors = pred_results
    )
  }
  return(final_result)
}
