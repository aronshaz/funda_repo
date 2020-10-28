--CREATING RECOMMENDATIONS BASED ON SUMMARY

CREATE TABLE movies (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);

\copy movies FROM '/home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header

SELECT * FROM movies where url='interstellar';

ALTER TABLE movies ADD lexemesSummary tsvector;

UPDATE movies SET lexemesSummary = to_tsvector(Summary);

SELECT url FROM movies WHERE lexemesSummary @@ to_tsquery('space & future');
ALTER TABLE movies ADD rank float4;

UPDATE movies SET rank = ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM movies WHERE url='interstellar')));

CREATE TABLE recommendationsBasedOnSummaryField AS SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;

\copy (SELECT * FROM recommendationsBasedOnSummaryField) to '/home/pi/RSL/top50recommendationsSummary.csv' WITH csv;

DROP TABLE movies;
DROP TABLE recommendationsBasedOnSummaryField;

