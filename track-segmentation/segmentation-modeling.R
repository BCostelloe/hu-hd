library('momentuHMM')

setwd("~/Documents/GitHub/zebra-vigilance/track-segmentation")

# read in data
tr015 <- read.csv('tracks-for-segmentation/ob015_smoothed.csv')
tr066 <- read.csv('tracks-for-segmentation/ob066_smoothed.csv')
tr074 <- read.csv('tracks-for-segmentation/ob074_smoothed.csv')

# read in track-ID info
IDs <- read.csv('../data/trackIDs.csv')

# rename track ID column to ID
# NEED TO FILTER OUT ALL NON-ZEBRAS AND NON-FOCALS
names(tr015)[names(tr015)=="trackID"] <- "ID"
names(tr066)[names(tr066)=="trackID"] <- "ID"
names(tr074)[names(tr074)=="trackID"] <- "ID"

# combine data from all observations
tracks <- rbind(tr015, tr066, tr074)
remove(tr015, tr066, tr074)

# make a data frame for each smoothing window
tr05 <- tracks[,c(4,5,8,9)]
tr15 <- tracks[,c(4,5,10,11)]
tr31 <- tracks[,c(4,5,12,13)]
tr45 <- tracks[,c(4,5,14,15)]
tr61 <- tracks[,c(4,5,16,17)]

# Set model parameters
state_names <- c('stationary', 'traveling')
dist = list(step = "weibull", angle = "vm") # no idea if these distributions make sense
angleMean0 <- c(0, 0) # initial means (one for each state)
angleCon0 <- c(0.5, 8) # initial concentrations (one for each state)
anglePar0 <- c(angleMean0, angleCon0)
#Par0 <- list(step=c(1,1,0.5,1.5),angle=angleCon0)

# Model 0.1 - parameters 0, 5-frame smoothing
df_05 <-prepData(data = tr05, coordNames = c('smooth_05_x', 'smooth_05_y'), type = 'UTM')
# calculate proportion of steps that are 0 for zero-value parameter.
whichzero <- which(df_05$step == 0)
zpar = length(whichzero)/nrow(df_05)
Par_m0_1 <- list(step=c(1,1,0.5,1.5,zpar,zpar), angle = angleCon0)

m0_1 <- fitHMM(data = df_05, nbStates = 2, dist = dist, Par0 = Par_m0_1,
                   estAngleMean = list(angle=FALSE), stateNames = state_names)
states_m0_1 <- viterbi(m0_1)
table(states_m0_1)/nrow(df_05)
plot(m0_1)

# Model 0.2 - parameters 0, 15-frame smoothing
df_15 <-prepData(data = tr15, coordNames = c('smooth_15_x', 'smooth_15_y'), type = 'UTM')
whichzero <- which(df_15$step == 0)
zpar = length(whichzero)/nrow(df_15)
Par_m0_2 <- list(step=c(1,1,0.5,1.5,zpar,zpar), angle = angleCon0)

m0_2 <- fitHMM(data = df_15, nbStates = 2, dist = dist, Par0 = Par_m0_2,
               estAngleMean = list(angle=FALSE), stateNames = state_names)
states_m0_2 <- viterbi(m0_2)
table(states_m0_2)/nrow(df_15)
plot(m0_2)

# Model 0.3 - parameters 0, 31-frame smoothing
df_31 <-prepData(data = tr31, coordNames = c('smooth_31_x', 'smooth_31_y'), type = 'UTM')
whichzero <- which(df_31$step == 0)
zpar = length(whichzero)/nrow(df_31)
Par_m0_3 <- list(step=c(1,1,0.5,1.5,zpar,zpar), angle = angleCon0)
m0_3 <- fitHMM(data = df_31, nbStates = 2, dist = dist, Par0 = Par_m0_3,
               estAngleMean = list(angle=FALSE), stateNames = state_names)
states_m0_3 <- viterbi(m0_3)
table(states_m0_3)/nrow(df_31)
plot(m0_3)

# Model 0.4 - parameters 0, 45-frame smoothing
df_45 <-prepData(data = tr45, coordNames = c('smooth_45_x', 'smooth_45_y'), type = 'UTM')
whichzero <- which(df_45$step == 0)
zpar = length(whichzero)/nrow(df_45)
Par_m0_4 <- list(step=c(1,1,0.5,1.5,zpar,zpar), angle = angleCon0)
m0_4 <- fitHMM(data = df_45, nbStates = 2, dist = dist, Par0 = Par_m0_4,
               estAngleMean = list(angle=FALSE), stateNames = state_names)
states_m0_4 <- viterbi(m0_4)
table(states_m0_4)/nrow(df_45)
plot(m0_4)

# Model 0.5 - parameters 0, 61-frame smoothing
df_61 <-prepData(data = tr61, coordNames = c('smooth_61_x', 'smooth_61_y'), type = 'UTM')
whichzero <- which(df_61$step == 0)
zpar = length(whichzero)/nrow(df_61)
Par_m0_5 <- list(step=c(1,1,0.5,1.5,zpar,zpar), angle = angleCon0)
m0_5 <- fitHMM(data = df_61, nbStates = 2, dist = dist, Par0 = Par_m0_5,
               estAngleMean = list(angle=FALSE), stateNames = state_names)
states_m0_5 <- viterbi(m0_5)
table(states_m0_5)/nrow(df_61)
plot(m0_5)

# start with just ob015 to see which smoothing window is best
tr015_05 <- tr015[,c(4,5,8,9)]
tr015_15 <- tr015[,c(4,5,10,11)]
tr015_31 <- tr015[,c(4,5,12,13)]
tr015_45 <- tr015[,c(4,5,14,15)]
tr015_61 <- tr015[,c(4,5,16,17)]

# try with 5-frame window
df_05 <-prepData(data = tr015_05, coordNames = c('smooth_05_x', 'smooth_05_y'), type = 'UTM')
state_names <- c('stationary', 'traveling')
dist = list(step = "weibull", angle = "vm") # no idea if these distributions make sense

hist(df_05$step) # look at step length distribution to get idea for starting parameters

# calcualte proportion of steps that are 0 for zero-value parameter.
whichzero <- which(df_05$step == 0)
length(whichzero)/nrow(df_05)

hist(df_05$angle)

angleMean0 <- c(0, 0) # initial means (one for each state)
angleCon0 <- c(0.5, 8) # initial concentrations (one for each state)
anglePar0 <- c(angleMean0, angleCon0)

Par0_smooth05 <- list(step=c(1,1,0.5,1.5),angle=angleCon0)

smooth05 <- fitHMM(data = df_05, nbStates = 2, dist = dist, Par0 = Par0_smooth05,
             estAngleMean = list(angle=FALSE), stateNames = state_names)

states_05 <- viterbi(smooth05)

table(states_05)/nrow(df_05)

plot(smooth05) # animals 13, 14 & 15 should be all stationary

# try with 15-frame window
df_15 <-prepData(data = tr015_15, coordNames = c('smooth_15_x', 'smooth_15_y'), type = 'UTM')
state_names <- c('stationary', 'traveling')
dist = list(step = "weibull", angle = "vm") # no idea if these distributions make sense

hist(df_15$step) # look at step length distribution to get idea for starting parameters

# calcualte proportion of steps that are 0 for zero-value parameter.
whichzero <- which(df_15$step == 0)
length(whichzero)/nrow(df_15)

hist(df_15$angle)

angleMean0 <- c(0, 0) # initial means (one for each state)
angleCon0 <- c(0.5, 8) # initial concentrations (one for each state)
anglePar0 <- c(angleMean0, angleCon0)

Par0_smooth15 <- list(step=c(1,1,0.5,1.5),angle=angleCon0)

smooth15 <- fitHMM(data = df_15, nbStates = 2, dist = dist, Par0 = Par0_smooth15,
                   estAngleMean = list(angle=FALSE), stateNames = state_names)

states_15 <- viterbi(smooth15)

table(states_15)/nrow(df_15)

plot(smooth15)

# try with 31-frame window
df_31 <-prepData(data = tr015_31, coordNames = c('smooth_31_x', 'smooth_31_y'), type = 'UTM')
state_names <- c('stationary', 'traveling')
dist = list(step = "weibull", angle = "vm") # no idea if these distributions make sense

hist(df_31$step) # look at step length distribution to get idea for starting parameters

# calcualte proportion of steps that are 0 for zero-value parameter.
whichzero <- which(df_31$step == 0)
length(whichzero)/nrow(df_31)

hist(df_31$angle)

angleMean0 <- c(0, 0) # initial means (one for each state)
angleCon0 <- c(0.5, 8) # initial concentrations (one for each state)
anglePar0 <- c(angleMean0, angleCon0)

Par0_smooth31 <- list(step=c(1,1,0.5,1.5),angle=angleCon0)

smooth31 <- fitHMM(data = df_31, nbStates = 2, dist = dist, Par0 = Par0_smooth31,
                   estAngleMean = list(angle=FALSE), stateNames = state_names)

states_31 <- viterbi(smooth31)

table(states_31)/nrow(df_31)

plot(smooth31)
