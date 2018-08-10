## Matrix Factorization for Movie Recommendation

This project is using Matrix Factorization model for movie recommendation. 

## Dataset
The data set consists of: 100,000 ratings (1-5) from 943 users on 1682 movies. Each user has rated at least 20 movies. 
       
ratings.csv contains the ratings data in the format: user_id, movie_id, rating

ratings_test.csv contains the test set with ground truth in the same format as ratings.txt.

movies.txt contains the mapping from movie_id to movie name. Row j corresponds to index j of movie_id.

## Matrix Factorization Algorithm
Matrix_factorization.m: For the algorithm, we set σ2 = 0.25, d = 10 and λ = 1. Train the model on the larger training
set for 100 iterations. For each user-movie pair in the test set, predict the rating using the relevant dot product.
It returns a) and b) below.

a) Log joint likelihood for iterations 2 to 100 for 10 runs:

![2a](https://user-images.githubusercontent.com/16806108/43932816-2c1b244a-9c14-11e8-9d90-82f9948d14e7.jpg)


b) 10 closest movies for “Star Wars” “My Fair Lady” and “Goodfellas” according to Euclidean distance:

|Ten Closest Movies to Star Wars | Distance |
| ------------- | ------------- |
|Empire Strikes Back, The (1980)| 0.4096|
|Return of the Jedi (1983)| 0.6024|
|Raiders of the Lost Ark (1981)| 0.8743|
|Lost Horizon (1937)| 0.8865|
|Usual Suspects, The (1995)| 0.9525|
|Terminator, The (1984)| 1.0599|
|Meet John Doe (1941)| 1.0680|
|Princess Bride, The (1987)| 1.1085|
|My Man Godfrey (1936)| 1.1336|
|Manon of the Spring (Manon des sources) (1986)| 1.1411|

|Ten Closest Movies to My Fair Lady | Distance |
| ------------- | ------------- |
|Sound of Music, The (1965)| 0.7121|
|Singin'' in the Rain (1952)| 0.9441|
|Cinderella (1950)| 0.9810|
|Mary Poppins (1964)| 0.9872|
|Alice in Wonderland (1951)| 0.9889|
|Snow White and the Seven Dwarfs (1937)| 1.0046|
|All About Eve (1950)| 1.0548|
|SubUrbia (1997)| 1.0725|
|Beauty and the Beast (1991)| 1.0767|
|Babe (1995)| 1.1107|

|Ten Closest Movies to Goodfellas | Distance |
| ------------- | ------------- |
|Good, The Bad and The Ugly, The (1966)| 0.6911|
|Casino (1995)| 0.7074
|Bonnie and Clyde (1967)| 0.7725|
|Full Metal Jacket (1987)| 0.7831|
|Once Upon a Time in the West (1969)| 0.7950|
|Godfather: Part II, The (1974)| 0.8871|
|Short Cuts (1993)| 0.9352|
|Cool Hand Luke (1967)| 0.9455|
|2001: A Space Odyssey (1968)| 0.9642|
|Shining, The (1980)| 0.9681|
