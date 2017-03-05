

setwd("~/RStats/analysis-class/data/")

df <- read.csv("ESP_sensor.csv")
df$ESP_ID <- NULL
head(df)
linreg <- lm(data=df, Motor_Vibration ~ Current_Leakage_mA+PressureROC)
summary(linreg)

df$Well <- paste0("Well_", sample(5000, 1023), sample(c("A", "AG", "N", "G")))

rare_1_in_10 <- c(rep(0,9),1)

df$rareB <- sample(rare_1_in_10,1023, replace = T)

df$Surface_Temperature <- 3.57 + 0.9 *df$Intake_Temperature_F - 1.2*(df$Motor_Oil_Temperature^0.7) +
  df$rareB*df$Motor_Vibration

df$Surface_Temperature <- round(df$Surface_Temperature)


# OD Casing sizes
od <- c(4.5, 5.5, 7.0)
df$ESP_OD_Casing_inches <- sample(od, 1023, replace = T, prob = c(0.6, 0.3,0.1))

fit <- lm(data=df, Surface_Temperature ~ Motor_Oil_Temperature + 
     Motor_Vibration + Current_Leakage_mA+PressureROC + 
     Intake_Temperature_F)

summary(fit)
names(df)
write.csv(df[, c("Well", "ESP_OD_Casing_inches", 
                 "Motor_Oil_Temperature", 
                 "Intake_Temperature_F", 
                 "Intake_Pressure_Mpa",   
                "Motor_Vibration",
                "Current_Leakage_mA",
                "PressureROC",     
                 "Surface_Temperature")], file="ESP1_data.csv",
          row.names = F)


df2 <- read.csv("ESP1_data.csv", stringsAsFactors = F)

df2$ESP_OD_Casing_inches <- as.factor(df2$ESP_OD_Casing_inches)

# Change only for OD = 7
rows_7in <- df2$ESP_OD_Casing_inches == 7
rows_45in <- df2$ESP_OD_Casing_inches == 4.5
rows_55in <- df2$ESP_OD_Casing_inches == 5.5
rand7 <- runif(1023, 15, max=25)
rand4 <- runif(1023, 1, max=8)
rand5 <- runif(1023, 3, max=14)

df2$TDH <- runif(1023, 4000, 5500)
df2$TDH
df2$TDH[rows_7in] <- df2$TDH[rows_7in] + rand7[rows_7in]
df2$TDH[rows_45in] <- df2$TDH[rows_45in] + rand4[rows_45in]
df2$TDH[rows_55in] <- df2$TDH[rows_55in] + rand5[rows_55in]



fit2 <- lm(data=df2, Surface_Temperature ~ Motor_Oil_Temperature + 
     Motor_Vibration + Current_Leakage_mA+PressureROC + 
     Intake_Temperature_F)

summary(fit2)


ESP_anova <- aov(TDH ~ ESP_OD_Casing_inches, 
                 data=df2)
summary(ESP_anova)


model.tables(ESP_anova, type="means")
model.tables(ESP_anova, type="effects")

names(df2)
write.csv(df2, "Wells_ESP2.csv", row.names=F)
