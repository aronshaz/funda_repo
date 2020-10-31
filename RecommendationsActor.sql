
--CREATING RECOMMENDATIONS BASED ON STARRING ACTOR
test=> CREATE TABLE IF NOT EXISTS movies (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);

test=> \copy movies FROM '/home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header

test=> SELECT * FROM movies where url='inception';
test=> ALTER TABLE movies ADD COLUMN IF NOT EXISTS lexemesStarring tsvector;

test=> UPDATE movies SET lexemesStarring = to_tsvector(Starring);

test=> SELECT url FROM movies WHERE lexemesStarring @@ to_tsquery('DiCaprio');
test=> ALTER TABLE movies ADD COLUMN IF NOT EXISTS rank float4;

test=> UPDATE movies SET rank = ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies WHERE url='inception')));

test=> CREATE TABLE IF NOT EXISTS recommendationsBasedOnStarringActor AS SELECT url, rank FROM movies WHERE rank > 0.2 ORDER BY rank DESC LIMIT 50;

test=> \copy (SELECT * FROM recommendationsBasedOnStarringActor) to '/home/pi/RSL/top50recommendationsStarring.csv' WITH csv;


