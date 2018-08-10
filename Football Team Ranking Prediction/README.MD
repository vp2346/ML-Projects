## Markov Chains model for football teams ranking

In this project, we use Markov Chains model to predict 760 college football teams ranking in 2016 based on 
the scores of every game in the 2016 season. 

## Dataset
CFB2016 scores.csv: contains the result of one game on each line in following format

Team A index, Team A points, Team B index, Team B points.

If Team A has more points than Team B, then Team A wins, and vice versa. The index of a team refers
to the row of “TeamNames.txt” where that team’s name can be found.

## Markov_Chain.m 

Algorithm: 
Construct a 760×760 random walk matrix M on the college football teams. First construct the unnormalized matrix M hat with values initialized to zeros. For one particular game, let i be the index of Team A
and j the index of Team B. Then update



It outputs a) and b) below. 
a) top 25 teams and their corresponding score for t = 10, 100, 1000, 10000.

b) 
