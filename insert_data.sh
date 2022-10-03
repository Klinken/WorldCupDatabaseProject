#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games RESTART IDENTITY CASCADE")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #GET THE WINNER OR OPPONENT
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #IF NOT FOUND
      if [[ -z $TEAM_ID ]]
      then
        #THEN INSERT AS TEAM
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
        if [[ $INSERT_TEAM == "INSERT 0 1" ]]
        then
        echo Inserted into teams: $WINNER
        fi
    fi
    #GET THE WINNER OR OPPONENT
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #IF NOT FOUND
      if [[ -z $TEAM_ID ]]
      then
        #THEN INSERT AS TEAM
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
        if [[ $INSERT_TEAM == "INSERT 0 1" ]]
        then
        echo Inserted into teams: $OPPONENT
        fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #GET ID OF WINNER
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #GET ID OF OPPONENT
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #ADD VALUES
    INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id, winner_goals, opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
    echo -e "INSERTED MATCHINFORMATION: \nYEAR: $YEAR, \nROUND: $ROUND, \nWINNER:$WINNER_ID, \nOPPONENT: $OPPONENT_ID, \nWINNER_GOALS: $WINNER_GOALS, \nOPPONENT_GOALS: $OPPONENT_GOALS\n"
    fi
  fi
done