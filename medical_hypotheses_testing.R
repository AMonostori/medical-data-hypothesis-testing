library(haven)
library(nortest)
library(circular)
library(dplyr)
library(onewaytests)
library(car)
install.packages("ggpubr")
library("ggpubr")
library(ggplot2)
install.packages('mvnormtest')
library('mvnormtest')

update.packages(ask = FALSE)


################
## Loading data

dataset <- read_spss("Medical_data_MA2.sav")
dataset

#### Handling missing values

dataset %>%
  summarise(count = sum(is.na(CREAT_0)))   # 6 missing
dataset %>%
  summarise(count = sum(is.na(K_0)))       # 9 missing

# I am choosing to impute data with global mean.

dataset <- dataset %>% mutate(CREAT_0
                        = replace(CREAT_0, is.na(CREAT_0), mean(CREAT_0, na.rm = TRUE)))
dataset <- dataset %>% mutate(K_0
                        = replace(K_0, is.na(K_0), mean(K_0, na.rm = TRUE)))


# Creating groups for plotting distribution

group_1C <- (dataset$CREAT_0[dataset$Csoport == 1])
group_2C <- (dataset$CREAT_0[dataset$Csoport == 2])
group_3C <- (dataset$CREAT_0[dataset$Csoport == 3])
group_1K <- (dataset$K_0[dataset$Csoport == 1])
group_2K <- (dataset$K_0[dataset$Csoport == 2])
group_3K <- (dataset$K_0[dataset$Csoport == 3])


# We have 3 groups therefore One-way Anova seems the best for parameter test.
# For Anova, the normality has to be tested.


#### Normality test

shapiro.test(group_1C)  
shapiro.test(group_2C)  
shapiro.test(group_3C) 
shapiro.test(group_1K) 
shapiro.test(group_2K)  
shapiro.test(group_3K)  

# Only group 2C fails the normality test - the plotting also confirms this.

plot(density(group_1C), ylim=c(0, 0.025), xlab="Creatinine")
lines(density(group_2C), col="red")
lines(density(group_3C), col="blue")
abline(v=mean(group_1C), col="black", add=T)
abline(v=mean(group_2C), col="red", add=T)
abline(v=mean(group_3C), col="blue", add=T)


plot(density(group_1K), xlab="Kalium")
lines(density(group_2K), col="red")
lines(density(group_3K), col="blue")
abline(v=mean(group_1K), col="black", add=T)
abline(v=mean(group_2K), col="red", add=T)
abline(v=mean(group_3K), col="blue", add=T)

# Secondly the homogenity of variances need to be tested.
# For that I chose Brown-Forsythe test

Group <- as.factor(dataset$Csoport)

dataframe <- data.frame(dataset$CREAT_0, Group)
dataframe
bf.test(dataset$CREAT_0 ~ Group, dataframe)


dataframe_2 <- data.frame(dataset$K_0, Group)
dataframe_2
bf.test(dataset$K_0 ~ Group, dataframe_2)

# The variance is not significantly different in any of the groups.


###################
## ONE-WAY ANOVA ##
###################
# One way anova is a perfect parametric test for more than 2 groups with one variable to be tested.
# Null hypothesis:  all groups are equal.

# Creatinine

anovaCR <- aov(CREAT_0 ~ Csoport, data = dataset)
summary(anovaCR)


# Kalium

anovaK <- aov(K_0 ~ Csoport, data = dataset)
summary(anovaK)

# Since the p-value is greater than 0.05, the null hypothesis is accepted at the 0.05 significance level,
# so there is no significant difference between the groups.


##########################
## Non-parametric probe ##
##########################

# Kruskal_Wallis test
# This is a very similar test to One-way ANOVA, but it is non-parametric and  
# normally distributed data is not a prerequisite.


kruskal.test(CREAT_0 ~ Csoport, data = dataset)

kruskal.test(K_0 ~ Csoport, data = dataset)

# We accept the nullhypotheses both cases, the groups are not different.


####################
## One-way Manova ##
####################

# If I were a doctor or a researcher, I would be interested in the combination of the two groups combined.
# For this purpose the multivariate ANOVA test is useful.
# The test compares the means of these groups as a vector.
# Under the null hypothesis the means are equal.

result = manova(cbind(dataset$CREAT_0, dataset$K_0) ~ Csoport, 
                data = dataset)
summary(result)

# The groups do not differ from each other according to various treatment plans.


####################
## Visualizations ##
####################


ggboxplot(dataset, x = "Csoport", y = "CREAT_0", 
          color = "Csoport", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("1", "2", "3"),
          ylab = "CREAT_0", xlab = "Csoport")

ggboxplot(dataset, x = "Csoport", y = "K_0", 
          color = "Csoport", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("1", "2", "3"),
          ylab = "K_0", xlab = "Csoport")


# Creating 'df' for further visualizations

df <- data.frame(x = dataset$CREAT_0, y = dataset$K_0, z= datset$Csoport)
df$z <- as.factor(df$z)

# CONTOUR PLOT 

ggplot(df, aes(x = x, y = y)) +geom_density_2d()


# SCATTERPLOT

ggplot(df, aes(x = x, y = y, color = z, linetype = z)) +
  geom_point()+
  stat_ellipse()



