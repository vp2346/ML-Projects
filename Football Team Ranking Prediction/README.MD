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

<img width="453" alt="markov_chains" src="https://user-images.githubusercontent.com/16806108/43934322-d7aa4ac2-9c1c-11e8-9eb2-daae8a7af931.PNG">

After processing all games, let M be the matrix formed by normalizing the rows of M hat so they sum to
one. Let wt be the 1×760 state vector at step t. Set w0 to the uniform distribution. Therefore, wt is
the marginal distribution on each state after t steps given that the starting state is chosen uniformly at
random.

It outputs top 25 teams and their corresponding score for t = 10, 100, 1000, 10000.
<img width="508" alt="10 100" src="https://user-images.githubusercontent.com/16806108/43934405-379cd8b4-9c1d-11e8-88f1-d2d9c166f19b.PNG">

<img width="508" alt="1000 10000" src="https://user-images.githubusercontent.com/16806108/43934411-3d7613fe-9c1d-11e8-9571-43133a848873.PNG">



