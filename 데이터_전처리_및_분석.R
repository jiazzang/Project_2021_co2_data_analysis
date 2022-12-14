# 0. 기본 세팅 #
setwd("C:\\Users\\USER\\Desktop\\지아\\수업\\전공수업\\국제금융학과\\Finance Analytics\\분석 프로젝트")
data = read.csv("2조_data.csv")


# 1. 각 모형의 적합성 검증 #
## 1) 첫 번째 모형: 원본 데이터 그대로 회귀분석 수행 ##
model_1 <- lm(CO2~temp+E.Growth+P.Growth+Power+Coal+Renewable+Petroleum+Hydro.E+Nuclear.E+Japan, data=data)
summary(model_1)


## 2) 두 번째 모형: 모든 변수를 차분한 후 회귀분석 수행 ##
## 과적합 문제(R-squared: 약 99%)를 해결하기 위해 모든 변수 전부 차분 적용
newtemp <- diff(data$temp, difference=1)
data$newtemp <- c(NA, newtemp)
newE.Growth <- diff(data$E.Growth, difference=1)
data$newE.Growth <- c(NA, newE.Growth)
newP.Growth <- diff(data$P.Growth, difference=1)
data$newP.Growth <- c(NA, newP.Growth)
newPower <- diff(data$Power, difference=1)
data$newPower <- c(NA, newPower)
newCoal <- diff(data$Coal, difference=1)
data$newCoal <- c(NA, newCoal)
newRenewable <- diff(data$Renewable, difference=1)
data$newRenewable <- c(NA, newRenewable)
newPetroleum <- diff(data$Petroleum, difference=1)
data$newPetroleum <- c(NA, newPetroleum)
newHydro.E <- diff(data$Hydro.E, difference=1)
data$newHydro.E <- c(NA, newHydro.E)
newNuclear.E <- diff(data$Nuclear.E, difference=1)
data$newNuclear.E <- c(NA, newNuclear.E)
newCO2 <- diff(data$CO2, difference=1)
data$newCO2 <- c(NA, newCO2)
newJapan <- diff(data$Japan, difference=1)
data$newJapan <- c(NA, newJapan)


## 모든 변수 차분한 후 회귀분석 수행
model_2 <- lm(newCO2~newtemp+newE.Growth+newP.Growth+newPower+newCoal+newRenewable
              +newPetroleum+newHydro.E+newNuclear.E+newJapan, data=data)
summary(model_2)


## 유의하지 않은 독립변수는 전부 제거한 모형으로 회귀분석 수행
model_2 <- lm(newCO2~newE.Growth+newPower, data=data)
summary(model_2)



## 등분산성 가정을 만족하는지 확인
plot(model_2$residuals~model_2$fitted)
abline(h=0, col="red")

# 가정4에 위배되는 것으로 보인다. 따라서 이 모형은 사용할 수 없다.
# 따라서, 등분산성 문제를 해결하기 위해 y에 로그변환 실시한 후 x,y 모두 차분한 모형을 사용한다.



## 3) 세 번째 모형: 종속변수에 로그변환을 적용한 다음 모든 변수를 차분한 후 회귀분석 수행 ##
## y에 로그변환 적용
data=read.csv("2조_data.csv")
data$lnCO2=log(data$CO2)
newlnCO2=diff(data$lnCO2, difference=1)
data$newlnCO2 <- c(NA, newlnCO2)
newlnCO2


## 모든 변수 전부 차분
newtemp <- diff(data$temp, difference=1)
data$newtemp <- c(NA, newtemp)
newE.Growth <- diff(data$E.Growth, difference=1)
data$newE.Growth <- c(NA, newE.Growth)
newP.Growth <- diff(data$P.Growth, difference=1)
data$newP.Growth <- c(NA, newP.Growth)
newPower <- diff(data$Power, difference=1)
data$newPower <- c(NA, newPower)
newCoal <- diff(data$Coal, difference=1)
data$newCoal <- c(NA, newCoal)
newRenewable <- diff(data$Renewable, difference=1)
data$newRenewable <- c(NA, newRenewable)
newPetroleum <- diff(data$Petroleum, difference=1)
data$newPetroleum <- c(NA, newPetroleum)
newHydro.E <- diff(data$Hydro.E, difference=1)
data$newHydro.E <- c(NA, newHydro.E)
newNuclear.E <- diff(data$Nuclear.E, difference=1)
data$newNuclear.E <- c(NA, newNuclear.E)
newJapan <- diff(data$Japan, difference=1)
data$newJapan <- c(NA, newJapan)


### 종속변수 로그 변환 & 모든 변수 차분 적용한 모형
model_3=lm(newlnCO2~newtemp+newE.Growth+newP.Growth+newCoal+
             newRenewable+newPetroleum+newHydro.E+newNuclear.E+newJapan, data=data)
summary(model_3)


## 유의하지 않은 독립변수는 전부 제거한 모형으로 회귀분석 수행
model_3=lm(newlnCO2~newE.Growth+
             newRenewable+newPetroleum, data=data)
summary(model_3)


## 등분산성 가정을 만족하는지 확인
plot(model_3$residuals~model_3$fitted)
abline(h=0, col="red")

# 모형2(모든 변수 차분한 모형)보다 분산이 안정되어 보인다.



# 2. 모형 가정 체크 #
## 가정 1: X와 Y의 scatter plot을 보고 판단 ##
plot(newlnCO2~newE.Growth, data=data)
plot(newlnCO2~newRenewable, data=data)
plot(newlnCO2~newPetroleum, data=data)

# 가정 1에 크게 위배되지 않는 것으로 판단된다.


## 가정3, 가정4: 잔차 plot을 보고 판단 ##
plot(model_3$residuals~model_3$fitted)
abline(h=0, col="red")

# 대체로 가정3과 가정4를 만족하는 것으로 보인다.


## 가정8: 잔차에 대한 히스토그램과 Normal q-q plot으로 판단 ##
qqnorm(model_3$residuals)
qqline(model_3$residuals)
hist(model_3$residuals)

# q-q plot의 직선 위에 대부분의 점들이 위치해 있음을 확인하였고, 히스토그램 또한 정규분포 모양을 어렴풋이 따르는 것을 확인하여 가정 8을 만족한다고 할 수 있다.


## 가정5: acf 함수, 더빈왓슨 검정으로 확인 ##
# Autocorrelation
acf(model_3$residuals)

# acf의 경우 대체적으로 점선을 넘지 않음을 확인하였으나, Lag(10)일 때 점선에 걸쳐지는 애매한 부분이 있어 추가적으로 더빈왓슨 검정을 실시해본다.

# d-w test
# install.packages("lmtest")
library(lmtest)
dwtest(model_3)

# 더빈왓슨 검정 결과, p-value = 0.3541로 0.05보다 크므로 H0를 기각하지 못합니다. 따라서 오차의 자기 상관이 존재하지 않는다고 판단된다.


## 가정6: vif를 이용하여 확인 ##
# install.packages("HH")
library(HH)
vif(data[,14:24])

# 모든 변수들의 VIF 값이 10을 넘지 않기 때문에, 해당 모형(세 번째 모형)은 다중공선성이 심하지 않다고 판단된다.