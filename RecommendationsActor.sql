--CREATING RECOMMENDATIONS BASED ON STARRING ACTOR
--ALL PREVIOUS COMMENTS ARE APPLICABLE TO THIS SCRIPT. THE ONLY EXCEPTION IS THE RANKINGS ARE NOW BASED ON THE COMMON WORDS IN THE STARRING FIELDS. 

CREATE TABLE movies2 (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);

\copy movies2 FROM '/home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header

--SELECT * FROM movies2 where url='inception';

ALTER TABLE movies2 ADD lexemesStarring tsvector;

UPDATE movies2 SET lexemesStarring = to_tsvector(Starring);

--SELECT url FROM movies2 WHERE lexemesStarring @@ to_tsquery('DiCaprio');

ALTER TABLE movies2 ADD rank float4;

UPDATE movies2 SET rank = ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies2 WHERE url='inception')));

CREATE TABLE recommendationsBasedOnStarringActor AS SELECT url, rank FROM movies2 WHERE rank > 0.01 ORDER BY rank DESC LIMIT 50;

\copy (SELECT * FROM recommendationsBasedOnStarringActor) to '/home/pi/RSL/top50recommendationsStarring.csv' WITH csv;

DROP TABLE movies2;
DROP TABLE recommendationsBasedOnStarringActor;
