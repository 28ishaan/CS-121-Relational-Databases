-- load-data.sql script for Movie Recommendation System
USE movie_recommendation_db; 

SET GLOBAL local_infile=1;

-- Replace with your actual database name

LOAD DATA LOCAL INFILE 'movies.csv' INTO TABLE movies
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;



LOAD DATA LOCAL INFILE 'genres.csv' INTO TABLE genres
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'actors.csv' INTO TABLE actors
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;



-- Load data for cast (junction table between movies and actors)
LOAD DATA LOCAL INFILE 'cast.csv' INTO TABLE cast
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


-- Load data for ratings
LOAD DATA LOCAL INFILE 'ratings.csv' INTO TABLE ratings
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'movie_genres.csv' INTO TABLE movie_genres
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

UPDATE movies
SET movie_title = TRIM(movie_title);

UPDATE actors 
SET actor_name = REGEXP_REPLACE(actor_name, '[^[:print:]]+', '')
WHERE actor_name <> REGEXP_REPLACE(actor_name, '[^[:print:]]+', '');

UPDATE genres 
SET genre_name = REGEXP_REPLACE(genre_name, '[^[:print:]]+', '')
WHERE genre_name <> REGEXP_REPLACE(genre_name, '[^[:print:]]+', '');