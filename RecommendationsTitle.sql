--CREATING RECOMMENDATIONS BASED ON TITLE
--ALL PREVIOUS COMMENTS ARE APPLICABLE TO THIS SCRIPT. THE ONLY EXCEPTION IS THE RANKINGS ARE NOW BASED ON THE COMMON WORDS IN THE TITLE FIELDS. 

CREATE TABLE movies3 (url text, Title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);

\copy movies3 FROM '/home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header

--SELECT * FROM movies3 where url='flight';

ALTER TABLE movies3 ADD lexemesTitle tsvector;

UPDATE movies3 SET lexemesTitle = to_tsvector(Title);

--SELECT url FROM movies3 WHERE lexemesTitle @@ to_tsquery('flight');

ALTER TABLE movies3 ADD rank float4;

UPDATE movies3 SET rank = ts_rank(lexemesTitle,plainto_tsquery((SELECT Title FROM movies3 WHERE url='flight')));

CREATE TABLE recommendationsBasedOnTitle AS SELECT url, rank FROM movies3 WHERE rank > 0.001 ORDER BY rank DESC LIMIT 50;

\copy (SELECT * FROM recommendationsBasedOnTitle) to '/home/pi/RSL/top50recommendationsTitle.csv' WITH csv;

DROP TABLE movies3;
DROP TABLE recommendationsBasedOnTitle
