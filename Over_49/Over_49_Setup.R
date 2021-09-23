#First make sure you've read in the Over_49_Functions.R script.

#This will load in all of the datasets in the Datasets folder.
load("Over_49_Setup.Rdata")


#We use the CREATE_STAT_COLUMN function create the preliminary covariates for our analysis

  #For example, consider the row:
    Scores[2,]

  #Team 20 (Las Vegas) is playing Team 6 (Carolina).

  #The CREATE_STAT_COLUMN function appends a column containing the desired stats below 
    #for Las Vegas and for Carolina to this row (and for all other matchups)


PPG_Away <- CREATE_STAT_COLUMN(Scores$Away, PPG)
PPG_Home <- CREATE_STAT_COLUMN(Scores$Home, PPG)

PPG_Against_Away <- CREATE_STAT_COLUMN(Scores$Away, PPG_Against)
PPG_Against_Home <- CREATE_STAT_COLUMN(Scores$Home, PPG_Against)

YPG_Away <- CREATE_STAT_COLUMN(Scores$Away, YPG)
YPG_Home <- CREATE_STAT_COLUMN(Scores$Home, YPG)

YPG_Against_Away <- CREATE_STAT_COLUMN(Scores$Away, YPG_Against)
YPG_Against_Home <- CREATE_STAT_COLUMN(Scores$Home, YPG_Against)

QBR_Away <- CREATE_STAT_COLUMN(Scores$Away, QBR)
QBR_Home <- CREATE_STAT_COLUMN(Scores$Home, QBR)

Passer_Rating_Away <- CREATE_STAT_COLUMN(Scores$Away, Passer_Rating)
Passer_Rating_Home <- CREATE_STAT_COLUMN(Scores$Home, Passer_Rating)

Passer_Rating_Against_Away <- CREATE_STAT_COLUMN(Scores$Away, Passer_Rating_Against)
Passer_Rating_Against_Home <- CREATE_STAT_COLUMN(Scores$Home, Passer_Rating_Against)

Plays_PG_Away <- CREATE_STAT_COLUMN(Scores$Away, Plays_PG)
Plays_PG_Home <- CREATE_STAT_COLUMN(Scores$Home, Plays_PG)

PYPG_Away <- CREATE_STAT_COLUMN(Scores$Away, PYPG)
PYPG_Home <- CREATE_STAT_COLUMN(Scores$Home, PYPG)

RYPG_Away <- CREATE_STAT_COLUMN(Scores$Away, RYPG)
RYPG_Home <- CREATE_STAT_COLUMN(Scores$Home, RYPG)

PYPG_Against_Away <- CREATE_STAT_COLUMN(Scores$Away, PYPG_Against)
PYPG_Against_Home <- CREATE_STAT_COLUMN(Scores$Home, PYPG_Against)

RYPG_Against_Away <- CREATE_STAT_COLUMN(Scores$Away, RYPG_Against)
RYPG_Against_Home <- CREATE_STAT_COLUMN(Scores$Home, RYPG_Against)

#Now we're going to combine (or average) each of the created columns 
  #columns and these will be our predictor variables.

Scores$PPG_Combined <- PPG_Away+ PPG_Home
Scores$PPG_Against_Combined <- PPG_Against_Away+ PPG_Against_Home

Scores$YPG_Averaged <- (YPG_Home + YPG_Away)/2
Scores$YPG_Against_Averaged <- (YPG_Against_Home + YPG_Against_Away)/2

Scores$QBR_Averaged <- (QBR_Away + QBR_Home)/2

Scores$Passer_Rating_Averaged <- (Passer_Rating_Home + Passer_Rating_Away)/2
Scores$Passer_Rating_Against_Averaged <- (Passer_Rating_Against_Home + 
                                     Passer_Rating_Against_Away)/2

Scores$Plays_PG_Averaged <- (Plays_PG_Away + Plays_PG_Home)/2

Scores$PYPG_Averaged <- (PYPG_Away + PYPG_Home)/2
Scores$RYPG_Averaged <- (RYPG_Away + RYPG_Home)/2

Scores$PYPG_Against_Averaged <- (PYPG_Against_Away + 
                                        PYPG_Against_Home)/2

Scores$RYPG_Against_Averaged <- (RYPG_Against_Away + 
                                RYPG_Against_Home)/2


#From here, you may run the Over_49_Analysis.R script.
