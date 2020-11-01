--CREATING RECOMMENDATIONS BASED ON SUMMARY

--CREATING THE MOVIE DATABASE IN PSQL
CREATE TABLE movies (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);

--COPYING CSV TO PSQL
\copy movies FROM '/home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header

--SELECT * FROM movies where url='interstellar'; (OPTIONAL COMMAND)

--ADDING COLUMN WITH LEXEMES (WORDS) OF SUMMARY OF FAVORITE MOVIE
ALTER TABLE movies ADD lexemesSummary tsvector;
UPDATE movies SET lexemesSummary = to_tsvector(Summary);

--SELECT url FROM movies WHERE lexemesSummary @@ to_tsquery('space & future'); (OPTIONAL COMMAND)

--ADDING NEW COLUMN WITH RANK VARIABLE
ALTER TABLE movies ADD rank float4;

--DEFINING RANKINGS OF ALL OTHER MOVIES BASED ON THE COMMON WORDS IN THE SUMMARY FIELDS
UPDATE movies SET rank = ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM movies WHERE url='interstellar')));

--CREATING A TABLE WITH THE RECOMMENDATIONS SORTED BY RANKING 
CREATE TABLE recommendationsBasedOnSummaryField AS SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;

--EXPORTING NEW TABLE TO CSV
\copy (SELECT * FROM recommendationsBasedOnSummaryField) to '/home/pi/RSL/top50recommendationsSummary.csv' WITH csv;

--REMOVING NEW TABLES IN ORDER TO EXECUTE THE SCRIPT AGAIN
DROP TABLE movies;
DROP TABLE recommendationsBasedOnSummaryField;

