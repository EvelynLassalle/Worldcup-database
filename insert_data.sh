#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE TABLE games,teams")
# Do not change code above this line. Use the PSQL variable above to query your database.


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ $WINNER != "winner" ]]
  then
    if [[ -z $TEAMS ]]
    then 
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted int teams, $WINNER
      fi
    fi
  fi

  TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
  then
    if [[ -z $TEAMS2 ]]
    then 
      INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ INSERT_TEAM2 == "INSERT 0 1" ]]
      then
        echo Inserted int teams, $OPPONENT
      fi
    fi
  fi
    
  T_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  T_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -n $T_WINNER_ID || -n $T_OPPONENT_ID ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) VALUES ($T_WINNER_ID, $T_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, $YEAR, '$ROUND')")
      if [[ INSERT_GAMES == "INSERT 0 1" ]]
      then
        echo Inserted int teams, $YEAR
      fi
    fi
  fi
done
