-- psql -U postgres -h 34.159.48.7 -p 5432 -d climate -f cd/..../creating_big_table.sql

SELECT transaction_timestamp() 

BEGIN;

DROP TABLE IF EXISTS mean_temperature CASCADE;								--_small

CREATE TABLE mean_temperature (										--_small
    staid INT, -- REFERENCE stations(staid),
    date DATE,
    tg NUMERIC
);

\COPY mean_temperature FROM '../data/mean_temperature.csv'  WITH (HEADER false, FORMAT csv);	--_small / _small

COMMIT;

SELECT transaction_timestamp()