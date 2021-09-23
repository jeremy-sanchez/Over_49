CREATE_STAT_COLUMN <- function(Main_DF_Column,Stat_DF)
{
  
  new_column <- vector()
  
  for(ii in 1:length(Main_DF_Column))
  {
    
    new_column[ii] <- Stat_DF[Scores[ii,]$Week,Main_DF_Column[ii]]
    
  }
  
  return(new_column)
}

#********************    Principle Component Analysis Centering and Scaling:      ***********************************#

CENTER <- function(df, weights)
{
  
  for(ii in 1:ncol(df))
  {
    
    df[,ii] <- df[,ii] - weights[ii]
    
    
  }
  return (df)
  
}
  
SCALE <- function(df, weights)
{
  
  for(ii in 1:ncol(df))
  {
    
    df[,ii] <- df[,ii] / weights[ii]
    
    
  }
  return (df)
  
}


