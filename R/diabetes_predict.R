#' Predicting risk probability of get Diabetes.
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
#'  "A_WV": minutes of vigorous physical activities at work per week.
#'  "A_WM": minutes of moderate physical activities at work per week.
#'  "A_HV": minutes of vigorous physical activities as hobby per week.
#'  "A_HM": minutes of moderate physical activities as hobby per week.
#'  "A_MV": minutes of moving place to place with walking or biking and so on per week.
#'  "A_ST": minutes of sitting or lying down per day(usually).
#'  "A_WD": minutes of walking per week.
#'  "S_CT": amount of smoking per day.\cr
#'  "D_YF": frequency of drinking per month.\cr
#'  "D_AT": amount of drinking per once.\cr
#'  "D_DD": frequency of dringking badly(over 7 glasses in soju).
#'
#' @examples
#'   data <- data.frame(
#'     sex_m = c(0, 1),
#'     age = c(20, 29),
#'     A_WV = c(0, 360),
#'     A_WM = c(0, 1500),
#'     A_HV = c(0, 0),
#'     A_HM = c(240, 0),
#'     A_MV = c(50, 80),
#'     A_ST = c(960, 240),
#'     A_WD = c(40, 80),
#'     S_CT = c(0, 10),
#'     D_YF = c(1, 3),
#'     D_AT = c(3, 7),
#'     D_DD = c(0, 1)
#'   )
#'   test <- diabetes_predict("dataframe", data)
#' @export

diabetes_predict <- function(mode, dataframe = NULL){
  if(!(mode %in% c('insert', 'dataframe'))){
    stop("mode argument should be one of \"insert\" or \"dataframe\".")
  }

  Diabetes_Models <- dizzPredictoR::Diabetes_Models
  Diabetes_Stack <- dizzPredictoR::Diabetes_Stack
  Diabetes <- dizzPredictoR::Diabetes
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

    # physical activity.
    cat("Q3) About your physical activities.\n    Please read example activities below.\n")
    cat("\nVigorous activities at work: heavy lifting, digging, walking up stairs, working at construction sites.\n")
    cat("Moderate activities at work: walking fast, light lifting, cleaning, infant caring(bathing, hugging etc).\n")
    cat("Vigorous activities as hobby: jogging, climbing, swimming, playing badminton, playing basketball.\n")
    cat("Moderate activities as hobby: walking fast, light jogging, weight training, playing golf, doing pilates.\n\n")
    A_WV_d <- readline("How many days do you spend doing vigorous physical activities at work, per week?  ")
    A_WV_t <- readline("How much hours do you spend doing vigorous physical activities at work, per day?  ")
    cat("\n")
    A_WM_d <- readline("How many days do you spend doing moderate physical activities at work, per week?  ")
    A_WM_t <- readline("How much hours do you spend doing moderate physical activities at work, per day?  ")
    cat("\n")
    A_HV_d <- readline("How many days do you spend doing vigorous physical activities as hobby, per week?  ")
    A_HV_t <- readline("How much hours do you spend doing vigorous physical activities as hobby, per day?  ")
    cat("\n")
    A_HM_d <- readline("How many days do you spend doing moderate physical activities as hobby, per week?  ")
    A_HM_t <- readline("How much hours do you spend doing moderate physical activities as hobby, per day?  ")

    A_WV <- as.numeric(A_WV_d) * as.numeric(A_WV_t) * 60
    A_WM <- as.numeric(A_WM_d) * as.numeric(A_WM_t) * 60
    A_HV <- as.numeric(A_HV_d) * as.numeric(A_HV_t) * 60
    A_HM <- as.numeric(A_HM_d) * as.numeric(A_HM_t) * 60
    cat("\n")

    A_MV_d <- readline("How many days do you walk or ride a bike for at least 10 minutes from place to place per week?  ")
    A_MV_t <- readline("How much hours do you walk or ride a bike for at least 10 minutes from place to place per day?  ")
    A_MV <- as.numeric(A_MV_d) * as.numeric(A_MV_t) * 60
    cat("\n")

    A_ST <- readline("Usually, how much hours do you sit or lie down(except sleeping) per day?  ")
    A_ST <- as.numeric(A_ST) * 60
    cat("\n")

    A_WD_d <- readline("How many days do you walk least 10 minutes per week?  ")
    A_WD_t <- readline("How much hours do you walk least 10 minutes per day?  ")
    A_WD <- as.numeric(A_WD_d) * as.numeric(A_WD_t) * 60
    cat("\n\n")

    # smoking amount a day.
    cat("Q4) About smoking habit.\n")
    S_CT <- readline("How much do you smoke per day? If you are not smoker, type 0.  ")
    cat("\n\n")

    # drink.
    cat("Q5) About drinking habit.\n")
    D_YF <- readline("How many times do you drink per month?  ")
    D_AT <- readline("How much do you drink per once?  ")
    D_DD <- readline("How many times do you drink too much(over 7 glasses) per month?  ")
    cat("\n\n")

    # user_data.
    new_data <- data.frame(
      sex_m = scale(sex_m, center = mean(Diabetes$sex_m), scale = stats::sd(Diabetes$sex_m)),
      age = scale(as.numeric(age), center = mean(Diabetes$age), scale = stats::sd(Diabetes$age)),
      A_WV = scale(as.numeric(A_WV), center = mean(Diabetes$A_WV), scale = stats::sd(Diabetes$A_WV)),
      A_WM = scale(as.numeric(A_WM), center = mean(Diabetes$A_WM), scale = stats::sd(Diabetes$A_WM)),
      A_HV = scale(as.numeric(A_HV), center = mean(Diabetes$A_HV), scale = stats::sd(Diabetes$A_HV)),
      A_HM = scale(as.numeric(A_HM), center = mean(Diabetes$A_HM), scale = stats::sd(Diabetes$A_HM)),
      A_MV = scale(as.numeric(A_MV), center = mean(Diabetes$A_MV), scale = stats::sd(Diabetes$A_MV)),
      A_ST = scale(as.numeric(A_ST), center = mean(Diabetes$A_ST), scale = stats::sd(Diabetes$A_ST)),
      A_WD = scale(as.numeric(A_WD), center = mean(Diabetes$A_WD), scale = stats::sd(Diabetes$A_WD)),
      S_CT = scale(as.numeric(S_CT), center = mean(Diabetes$S_CT), scale = stats::sd(Diabetes$S_CT)),
      D_YF = scale(as.numeric(D_YF), center = mean(Diabetes$D_YF), scale = stats::sd(Diabetes$D_YF)),
      D_DD = scale(as.numeric(D_DD), center = mean(Diabetes$D_DD), scale = stats::sd(Diabetes$D_DD)),
      D_AT = scale(as.numeric(D_AT), center = mean(Diabetes$D_AT), scale = stats::sd(Diabetes$D_AT))
    )

    # prediction.
    pred_result <- 1-predict(Diabetes_Stack, new_data, type = "prob")
    pred_result_p <- paste(round(pred_result, 4) * 100, "%", sep = "")
    if(pred_result >= 0.7){pred_result_p <- crayon::bgRed(pred_result_p)
    }else if(pred_result >= 0.3){pred_result_p <- crayon::bgYellow(pred_result_p)
    }else{pred_result_p <- crayon::bgGreen(pred_result_p)}

    pred_results <- dplyr::bind_rows(lapply(Diabetes_Models, caret::predict.train, newdata = new_data, type = "prob"))

    predictor_count <- sum(pred_results$X1 >= 0.5)
    predictor_max <- round(max(pred_results$X1), 4)*100

    # print summary.
    cat("Diabetes Prediction Result.\n")
    cat("Among 6 predictors, ", predictor_count, " predictor judged YOU are in diabetes.\n", sep = "")
    cat("Among 6 predictors, maximum risk probability is ", predictor_max, "%.\n", sep = "")
    cat("\n")
    cat("Diabetes Possibility:", pred_result_p, "\n\n\n")

    # object to return.
    final_result <- list(
      Disease = "Diabetes.",
      Probability = pred_result,
      Predictors = pred_results
    )
  }
  else if(mode == "dataframe"){
    dataframe <- data.frame(
      sex_m = scale(dataframe$sex_m, center = mean(Diabetes$sex_m), scale = stats::sd(Diabetes$sex_m)),
      age = scale(dataframe$age, center = mean(Diabetes$age), scale = stats::sd(Diabetes$age)),
      A_WV = scale(dataframe$A_WV, center = mean(Diabetes$A_WV), scale = stats::sd(Diabetes$A_WV)),
      A_WM = scale(dataframe$A_WM, center = mean(Diabetes$A_WM), scale = stats::sd(Diabetes$A_WM)),
      A_HV = scale(dataframe$A_HV, center = mean(Diabetes$A_HV), scale = stats::sd(Diabetes$A_HV)),
      A_HM = scale(dataframe$A_HM, center = mean(Diabetes$A_HM), scale = stats::sd(Diabetes$A_HM)),
      A_MV = scale(dataframe$A_MV, center = mean(Diabetes$A_MV), scale = stats::sd(Diabetes$A_MV)),
      A_ST = scale(dataframe$A_ST, center = mean(Diabetes$A_ST), scale = stats::sd(Diabetes$A_ST)),
      A_WD = scale(dataframe$A_WD, center = mean(Diabetes$A_WD), scale = stats::sd(Diabetes$A_WD)),
      S_CT = scale(dataframe$S_CT, center = mean(Diabetes$S_CT), scale = stats::sd(Diabetes$S_CT)),
      D_YF = scale(dataframe$D_YF, center = mean(Diabetes$D_YF), scale = stats::sd(Diabetes$D_YF)),
      D_DD = scale(dataframe$D_DD, center = mean(Diabetes$D_DD), scale = stats::sd(Diabetes$D_DD)),
      D_AT = scale(dataframe$D_AT, center = mean(Diabetes$D_AT), scale = stats::sd(Diabetes$D_AT))
    )

    pred_result <- data.frame(prob = 1-predict(Diabetes_Stack, dataframe, type = "prob"))
    pred_result$class <- ifelse(pred_result$prob >= 0.5, "diabetes", "normal")

    pred_results <- lapply(Diabetes_Models, caret::predict.train, newdata = dataframe, type = "prob")
    pred_results <- lapply(pred_results, function(x) tibble::rownames_to_column(x, "ID"))
    #pred_results <- lapply(pred_results, function(x) dplyr::mutate(x, model = names(x)))
    pred_results <- dplyr::bind_rows(pred_results)
    colnames(pred_results)[colnames(pred_results) == "X0"] <- 'normal'
    colnames(pred_results)[colnames(pred_results) == "X1"] <- 'diabetes'

    final_result <- list(
      Disease = "Diabetes.",
      Probability = pred_result,
      Predictors = pred_results
    )
  }
  return(final_result)
}


devtools::install_github('lawine90/dizzPredictoR')
