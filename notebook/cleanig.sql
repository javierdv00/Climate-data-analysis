SELECT * FROM mean_temperature;
SELECT * FROM stations;

-- creating a primary key in station
ALTER TABLE stations 
ADD PRIMARY KEY (staid);

-- creating a reference in mean_temperature table with the station table
ALTER TABLE mean_temperature
ADD FOREIGN KEY (staid) REFERENCES stations(staid);

-- devide tg from 10
UPDATE mean_temperature_small SET tg = ROUND(tg*10,1);
--UPDATE mean_temperature SET tg = ROUND(tg/10,1);


-- show hot,normal and cold
SELECT 
    CASE 
        WHEN tg/10 > 25 THEN 'hot'
        WHEN tg/10 BETWEEN 10 AND 25 THEN 'normal'
        ELSE 'cold' 
    END as feeling
FROM mean_temperature;

-- adding the names hot, normal and cold to the table as a new columns
--ALTER TABLE mean_temperature DROP COLUMN feeling;
ALTER TABLE mean_temperature ADD feeling VARCHAR;

UPDATE mean_temperature SET feeling = (
    CASE 
        WHEN tg/10 > 25 THEN 'hot'
        WHEN tg/10 BETWEEN 10 AND 25 THEN 'normal'
        ELSE 'cold' 
    END
);


-- just a test, delete it late
--ALTER TABLE stations DROP COLUMN altitud;
--ALTER TABLE stations ADD altitud VARCHAR;
--UPDATE stations SET altitud = (
--    CASE 
--        WHEN hght > 1000 THEN 'high'
--        WHEN hght BETWEEN 200 AND 1000 THEN 'normal'
--        ELSE 'low' 
--    END --as altitud
--);



--ALTER TABLE stations DROP COLUMN coordinates;

ALTER TABLE stations ADD coordinates POINT;
UPDATE stations SET coordinates = (
    point(
        split_part(lat, ':', 1)::numeric + -- the degrees
        split_part(lat, ':', 2)::numeric/60+ -- the minutes divided by 60
        split_part(lat, ':', 3)::numeric/(60*60), -- the seconds divided by 3600 all summed up 
        split_part(lon, ':', 1)::numeric +
        split_part(lon, ':', 2)::numeric/60+
        split_part(lon, ':', 3)::numeric/(60*60)
    )
);

ALTER TABLE stations DROP COLUMN latitude, DROP COLUMN longitude;
ALTER TABLE stations ADD latitude NUMERIC, ADD longitude NUMERIC;
UPDATE stations SET latitude = (
        split_part(lat, ':', 1)::numeric + -- the degrees
        split_part(lat, ':', 2)::numeric/60+ -- the minutes divided by 60
        split_part(lat, ':', 3)::numeric/(60*60) -- the seconds divided by 3600 all summed up 
);
UPDATE stations SET longitude = (
        split_part(lon, ':', 1)::numeric +
        split_part(lon, ':', 2)::numeric/60+
        split_part(lon, ':', 3)::numeric/(60*60)
);


-- Creating a derived Table that contains the yearly temperature averages
-- group by year and stadid and show tha avg(yearly temp)
DROP TABLE IF EXISTS yearly_mean_temperature;
CREATE TABLE yearly_mean_temperature AS (
	SELECT mean_temperature.staid as staid,							--small
	EXTRACT (year FROM mean_temperature.date) as year,				--small
	ROUND(AVG(mean_temperature.tg)/10,3) as avg_tg	 				--small
	FROM mean_temperature											--small		 
	GROUP BY staid, year
	ORDER BY staid
);

SELECT * FROM yearly_mean_temperature;  -- just to see the table

-- Show the yearly average of the maximum temperatures of all stations
-- group by year and stadid and subquery for the maximo temperatura in each station
SELECT year,
	ROUND(AVG(max_tg),2)
FROM (
	SELECT mean_temperature_small.staid as staid,
		EXTRACT (year FROM mean_temperature_small.date) as year,
		MAX(mean_temperature_small.tg)/10 as max_tg
	FROM mean_temperature_small
	GROUP BY staid, year
	ORDER BY staid
	) as tbl_max
GROUP BY year
ORDER BY year DESC
;


SELECT * FROM yearly_mean_temperature;  -- just to see the table


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

select count(avg_tg) FROM yearly_mean_temperature;  -- 332007
select AVG(avg
_tg) FROM yearly_mean_temperature;
select count(staid) FROM stations;  -- 6620
select count(alpha2) FROM countries;  -- 243

-- taking for every country the codes (alphas2 eand 3) and the average of the temperature for each country
SELECT name, alpha2, alpha3, year, ROUND(AVG(avg_tg),3) as avg_temp --, staid
FROM yearly_mean_temperature 
JOIN stations 
USING (staid)
JOIN countries 
ON stations.cn = countries.alpha2
GROUP BY name, alpha2, alpha3, year
;

-- taking for average of the temperature for each station in Germany
SELECT staid, year, avg_tg, cn, hght, coordinates, latitude, longitude 
FROM yearly_mean_temperature 
JOIN stations 
USING (staid)
WHERE cn = 'DE'
;


-- Check the large timeframe in yearly_mean_temperature
SELECT staid, COUNT(year) FROM yearly_mean_temperature
GROUP BY staid
ORDER BY COUNT(year) DESC
LIMIT 3;
-- R: the larger information is in station id = 27 with 248 year's information, second (id=173, 246), third (id=48, 237)
SELECT * FROM yearly_mean_temperature
WHERE staid IN (27,173)
;





