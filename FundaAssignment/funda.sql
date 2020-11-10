SET datestyle = dmy;

CREATE TABLE housing_data_test(
globalId text PRIMARY KEY,
publicatieDatum TIMESTAMP WITHOUT TIME ZONE,
postcode text,
koopPrijs text,
volledigeOmschijving text,
soortWoning text,
categorieObject text,
bouwjaar text,
indTuin text,
perceelOppervlakte text,
kantoor_naam_MD5hash text,
aantalKamers text,
aantalBadkamers text,
energielabelKlasse text,
globalId_1 text,
oppervlakte text,
datum_ondertekening TIMESTAMP WITHOUT TIME ZONE
);

\copy housing_data_test FROM '/home/pi/RSL/FundaAssignment/Funda_Datasets/housing_data_test.csv' with (format csv, header true);

-- Adding timeOnMarket variable
ALTER TABLE housing_data_test ADD timeOnMarket interval;
UPDATE housing_data_test SET timeOnMarket = datum_ondertekening - publicatieDatum;

-- Adding Municipality name to Funda Dataset using two CBS datasets including Postcode, Gemeentecode and Gemeentenaam
SET CLIENT_ENCODING TO 'utf8';
CREATE TABLE CBS_Gemeentes(
Gemeentecode text PRIMARY KEY,
Gemeentenaam text
);

\copy CBS_Gemeentes FROM '/home/pi/RSL/FundaAssignment/CBS_Datasets/CBS_Gemeentecode_Gemeentenaam2018.csv' with (format csv, header true, delimiter ';', encoding 'UTF8');

UPDATE CBS_Gemeentes SET Gemeentenaam = REPLACE(Gemeentenaam, ',', '');

CREATE TABLE CBS_Postcodes(
Postcode text PRIMARY KEY,
Huisnummer text,
Buurt text,
Wijk text,
Gemeentecode_ text
);

\copy CBS_Postcodes FROM '/home/pi/RSL/FundaAssignment/CBS_Datasets/CBS_Postcode_Gemeentecode2018_Clean.csv' with (format csv, header true, delimiter ';');

CREATE TABLE Postcode_Gemeentenaam AS SELECT * FROM CBS_Postcodes JOIN CBS_Gemeentes ON CBS_Postcodes.Gemeentecode_ = CBS_Gemeentes.Gemeentecode;

ALTER TABLE housing_data_test ADD gemeentenaam text;

UPDATE housing_data_test SET gemeentenaam = (select Postcode_Gemeentenaam.Gemeentenaam FROM Postcode_Gemeentenaam WHERE housing_data_test.postcode = Postcode_Gemeentenaam.postcode);

-- Adding Provincie to Funda Dataset
CREATE TABLE CBS_Provincies(
Gemeentecode text,
GemeentecodeGM text,
Gemeentenaam text PRIMARY KEY,
Provinciecode text,
ProvinciecodePV text,
Provincienaam text
);

\copy CBS_Provincies FROM '/home/pi/RSL/FundaAssignment/CBS_Datasets/CBS_Provincies.csv' with (format csv, header true, delimiter ',');

ALTER TABLE housing_data_test ADD provincie text;

UPDATE housing_data_test SET provincie = (select CBS_Provincies.Provincienaam FROM CBS_Provincies WHERE housing_data_test.gemeentenaam = CBS_Provincies.Gemeentenaam);

\copy (SELECT * FROM housing_data_test) to '/home/pi/RSL/FundaAssignment/CSV_Output/funda_output.csv' WITH csv;

/*
CREATE TABLE CBS_Population(
ID int PRIMARY KEY,
WijkenEnBuurten text,
Gemeentenaam text,
AantalInwoners int,
Mannen int,
Vrouwen int,
k_0Tot15Jaar int,
k_15Tot25Jaar int,
k_25Tot45Jaar int,
k_45Tot65Jaar int,
k_65JaarOfOuder int,
Bevolkingsdichtheid text,
GemiddeldInkomenPerInwoner text,
MeestVoorkomendePostcode text
);
\copy CBS_Population FROM '/home/pi/RSL/FundaAssignment/CBS_Datasets/CBS_Population.csv' with (format csv, header true, delimiter ';');
\copy (SELECT * FROM CBS_Population) to '/home/pi/RSL/FundaAssignment/CSV_Output/cbs_data_output.csv' WITH csv;
*/

DROP TABLE CBS_Gemeentes;
DROP TABLE CBS_Postcodes;
DROP TABLE housing_data_test;
DROP TABLE CBS_Population;
DROP TABLE Postcode_Gemeentenaam;
DROP TABLE CBS_Provincies;



