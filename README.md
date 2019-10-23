dizzPredictoR
=============
2016 국민건강영양조사의 원시데이터(라이프스타일 관련 설문)를 이용하여 질병 여부를 예측하는 모델을 학습, 설문 입력자의 질병 확률을 계산하여 산출하는 패키지입니다. 본 패키지의 사용 결과는 전문가의 견해가 아니므로 패키지의 예측 결과를 맹신하진 말아주세요.


# 1. 패키지 설치 방법
```
devtools::install_github('lawine90/dizzPredictoR')
```


# 2. 현재 예측 가능한 질병 목록
  - 고혈압(Hypertension)
  - 2형 당뇨(Type 2 diabetes)


# 3. 각 함수 설명 및 사용법
> **1) 고혈압 예측(hypertension_predict)**
> 
> 성별, 나이, 흡연, 음주, 식습관 설문으로 고혈압일 확률을 산출합니다. Hold-out method 1000회 반복의 평균 AUC는 약 80%입니다. 고혈압은 라이프스타일 요인 외의 유전적 요인, 환경적 요인의 영향을 받으므로 결과를 맹신하지 마시기 바랍니다. 함수에서 사용하는 argument는 다음과 같습니다.
> - mode: (필수, 문자). 함수의 실행 모드로, "insert"는 설문모드, "dataframe"은 데이터프레임모드
> - dataframe: (옵션, 데이터프레임). mode를 "dataframe"으로 입력할 시 예측에 사용할 데이터를 입력

``` 
# example 1: "insert" mode.
> hypertension_predict(mode = 'insert')
Please answer simple questions.

Q1) About your gender.
What is your gender?(Type 'male' or 'female')  male


Q2) About your age.
How old are you?(Example: 29)  29


Q3) About smoking habit.
How much do you smoke per day? If you are not smoker, type 0.  10


Q4) About drinking habit.
How many days do you drink per month?  3
How many glasses do you drink per once?  5
How many days do you drink too much(over 7 glasses) per month?  1


Q4) About your eating habbit.
How many days do you have breakfast per week?  0
How many days do you have lunch per week?  6
How many days do you have dinner per week?  3


Hypertension Prediction Result.
Among 6 predictors, 3 predictor judged YOU are in hypertension.
Among 6 predictors, maximum risk probability is 67.04%.

Hypertension Possibility: 52.54% 


$Disease
[1] "Hypertension."

$Probability
[1] 0.5253754

$Predictors
         X0        X1
1 0.3475611 0.6524389
2 0.3295835 0.6704165
3 0.6158420 0.3841580
4 0.3814844 0.6185156
5 0.6339834 0.3660166
6 0.5589871 0.4410129
```
```
# example 2: "dataframe" mode.
> sample <- dplyr::sample_n(Hypertensions, 10)
> actual <- sample$hp2
> sample <- dplyr::mutate(sample, hp2 = NULL)
> 
> pred <- hypertension_predict(mode = 'dataframe', dataframe = sample)
> pred$Probability
         prob        class
1  0.62503647 hypertension
2  0.87109381 hypertension
3  0.12500025       normal
4  0.45105926       normal
5  0.10983447       normal
6  0.86093513 hypertension
7  0.77699306 hypertension
8  0.76608872 hypertension
9  0.87540479 hypertension
10 0.09805894       normal
>
> table(pred$Probability$class, actual) # X0 = 'normal', X1 = 'hypertension'.
              actual
               X0 X1
  hypertension  1  5
  normal        4  0
```


> **2) 당뇨 예측(hypertension_predict)**
> 
> 성별, 나이, 신체활동, 흡연, 음주 설문으로 당뇨일 확률을 산출합니다. Hold-out method 1000회 반복의 평균 AUC는 약 69%입니다. 고혈압은 라이프스타일 요인 외의 유전적 요인, 환경적 요인의 영향을 받으므로 결과를 맹신하지 마시기 바랍니다. 함수에서 사용하는 argument는 다음과 같습니다.
> - mode: (필수, 문자). 함수의 실행 모드로, "insert"는 설문모드, "dataframe"은 데이터프레임모드
> - dataframe: (옵션, 데이터프레임). mode를 "dataframe"으로 입력할 시 예측에 사용할 데이터를 입력

```
# example 1: "insert" mode.
> diabetes_predict("insert")
Please answer simple questions.

Q1) About your gender.
What is your gender?(Type 'male' or 'female')  male


Q2) About your age.
How old are you?(Example: 29)  29


Q3) About your physical activities.
    Please read example activities below.

Vigorous activities at work: heavy lifting, digging, walking up stairs, working at construction sites.
Moderate activities at work: walking fast, light lifting, cleaning, infant caring(bathing, hugging etc).
Vigorous activities as hobby: jogging, climbing, swimming, playing badminton, playing basketball.
Moderate activities as hobby: walking fast, light jogging, weight training, playing golf, doing pilates.

How many days do you spend doing vigorous physical activities at work, per week?  0
How much hours do you spend doing vigorous physical activities at work, per day?  0

How many days do you spend doing moderate physical activities at work, per week?  4
How much hours do you spend doing moderate physical activities at work, per day?  0.2

How many days do you spend doing vigorous physical activities as hobby, per week?  0
How much hours do you spend doing vigorous physical activities as hobby, per day?  0

How many days do you spend doing moderate physical activities as hobby, per week?  0
How much hours do you spend doing moderate physical activities as hobby, per day?  0

How many days do you walk or ride a bike for at least 10 minutes from place to place per week?  5
How much hours do you walk or ride a bike for at least 10 minutes from place to place per day?  0.2

Usually, how much hours do you sit or lie down(except sleeping) per day?  9

How many days do you walk least 10 minutes per week?  3
How much hours do you walk least 10 minutes per day?  0.3


Q4) About smoking habit.
How much do you smoke per day? If you are not smoker, type 0.  10


Q5) About drinking habit.
How many times do you drink per month?  3
How much do you drink per once?  6
How many times do you drink too much(over 7 glasses) per month?  1


Diabetes Prediction Result.
Among 6 predictors, 0 predictor judged YOU are in diabetes.
Among 6 predictors, maximum risk probability is 37.39%.

Diabetes Possibility: 13.94% 


$Disease
[1] "Diabetes."

$Probability
[1] 0.1394397

$Predictors
         X0        X1
1 0.8538611 0.1461389
2 0.7667747 0.2332253
3 0.7581832 0.2418168
4 0.8773830 0.1226170
5 0.7850494 0.2149506
6 0.6260788 0.3739212
```
```
# example 2: "dataframe" mode.
> sample <- dplyr::sample_n(Diabetes, 10)
> actual <- sample$dm2
> sample <- dplyr::mutate(sample, hp2 = NULL)
> 
> pred <- diabetes_predict(mode = 'dataframe', dataframe = sample)
> pred$Probability
         prob    class
1  0.12268151   normal
2  0.15431363   normal
3  0.32112008   normal
4  0.55191836 diabetes
5  0.48864788   normal
6  0.08596079   normal
7  0.36737026   normal
8  0.09902357   normal
9  0.69103625 diabetes
10 0.09518267   normal
>
> table(pred$Probability$class, actual) # X0 = 'normal', X1 = 'diabetes'.
          actual
           X0 X1
  diabetes  0  2
  normal    6  2
```




# 4. 건의 및 문의사항
추가적으로 수집을 원하시는 데이터에 대한 함수나 패키지에 대한 건의 및 문의사항은 환영입니다 :) lawine90(power1sky@gmail.com)에게 많은 연락 부탁드리겠습니다.
