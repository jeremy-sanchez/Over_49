This folder contains the code (in R) to obtain the results of my Over 49: Predicting NFL Point Totals project.

The necessary R packages needed to run this code are the following:

e1071, pls, randomForest, rpart

In order to reproduce my results, you can either:

- Run Over_49_Analysis.R


- Run Over_49_Functions.R, Over_49_Setup.R, and then Over_49_Analysis.R

  The benefit of using this method is to see how the dataset used in the analysis was
  constructed.


Here is a description of the datasets used to create my covariates for this analysis.

###########################################################################################################################################################################

Datasets:

	Here are the predictor datasets by name, and the websites from which the original data were compiled.

	Dataset / Dimension (excluding header)	Description											Website
	__________________________________________________________________________________________________________________________________________________________________
	Opponent.csv / 33x14			The opponent for each NFL team by week.								Pro-Football-Reference.com
	
	Passer_Rating.csv / 33X15		The average of the passer ratings of the player with the most pass attempts per game 		TeamRankings.com
						in the weeks previous to this week, for each NFL team. 
						In Week 1, take the average passer rating of the team's quarterbacks
						from last year. If this is not available, take the 2019 league average.

	Passer_Rating_Against.csv / 33x15	The average of the passer ratings of quarterbacks playing against each NFL team			TeamRankings.com
						in the weeks previous to this week.
	
																
	Plays_PG.csv / 33X15			The average of the number of plays run by the offense of each NFL team in 			Pro-Football-Reference.com
						the weeks previous to this week. In Week 1, take the 2019 team average.							

	PPG.csv / 33x15				The average of the number of points scored per game of each NFL team in the			TeamRankings.com
						weeks previous to this week. In Week 1, take the 2019 team average.
																		
	PPG_Against.csv / 33x18			The average of the number of points scored against each NFL team per game in 			TeamRankings.com
						the weeks previous to this week. In Week 1, take the 2019 team average.								
	
	PYPG.csv / 33x18			The average of the number of passing yards per game of each NFL team in the			TeamRankings.com
						weeks previous to this week. In Week 1, take the 2019 team average.													
	
	PYPG_Against.csv / 33x18		The average of the number of passing yards per game gained against each NFL team 		TeamRankings.com
						in the weeks previous to this week. In Week 1, take the 2019 team average.

	QBR.csv	/ 33x18				The average quarterback rating (ESPN) of the quarterback with the most pass attempts per game	ESPN.com
						for each NFL team in the weeks previous to this week. In Week 1, take the average
						of the team's starting quarterback from 2019. If this is not avaiable, take the 2019
						league average.	
												
	RYPG.csv / 33x18			The average of the number of rushing yards per game of each NFL team in the 
						weeks previous to this week. In Week 1, take the 2019 team average.
											
	RYPG_Against.csv / 33x18		The average of the number of rushing yards per game gained against each NFL team		TeamRankings.com
						in the weeks previous to this week. In Week 1, take the 2019 team average.

	YPG.csv	/ 33x18				The average of the yards per game gained by each NFL team in the weeks previous to this		TeamRankings.com
						week. In Week 1, take the 2019 team average.											
				
	YPG_Against.csv	/ 33x18			The average of the yards per game gained against each NFL team in the weeks previous		TeamRankings.com
						to this week. In Week 1, take the 2019 team average.									
	
	___________________________________________________________________________________________________________________________________________________________________
				
	
	
	The outcome dataset:

	Scores					The number of points scored by each NFL team in weeks 1 through 13 of the 2020 season		Pro-Football-Reference.com
	

##############################################################################################################################################################################	

		