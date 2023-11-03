SELECT * FROM [dbo].[IDM_NM_ago23];

-- Adding new column Entidad_new
ALTER TABLE [dbo].[IDM_NM_ago23]
ADD Entidad_new NVARCHAR(MAX);

select * from [dbo].[IDM_NM_ago23];
-- Filtering data to new column
UPDATE [dbo].[IDM_NM_ago23]
SET Entidad_new = REPLACE(Entidad, ' ', '');

select * from [dbo].[IDM_NM_ago23];

-- Adding new column municipio_new
ALTER TABLE [dbo].[IDM_NM_ago23]
ADD Municipio_new NVARCHAR(MAX);

select * from [dbo].[IDM_NM_ago23];

-- Filtering data to new column Municipio_new
UPDATE [dbo].[IDM_NM_ago23]
SET Municipio_new = REPLACE(Municipio, ' ', '');

select * from [dbo].[IDM_NM_ago23];

-- Adding new colum of columns entidad and municipio
ALTER TABLE [dbo].[IDM_NM_ago23]
ADD EntidadMunicipio NVARCHAR(MAX);

select * from [dbo].[IDM_NM_ago23];
-- Combining both columns
UPDATE [dbo].[IDM_NM_ago23]
SET EntidadMunicipio = CONCAT(Entidad_new, Municipio_new);

select * from [dbo].[IDM_NM_ago23];

SELECT DISTINCT EntidadMunicipio FROM [dbo].[IDM_NM_ago23];

--Checking new INEGI data
SELECT * FROM [dbo].[INEGI]

SELECT *
FROM [dbo].[IDM_NM_ago23]
WHERE Municipio = 'Ángel Albino Corzo';

UPDATE [dbo].[IDM_NM_ago23]
SET Municipio_new = 'ÁngelAlbinoCorzo'
WHERE Municipio_new = 'AngelAlbinoCorzo';

SELECT DISTINCT EntidadMunicipio FROM IDM_NM_ago23;

SELECT DISTINCT Concatenated_Column from INEGI;
/**
SELECT
    Concatenated_Column,
    MAX(LAT_DECIMAL) AS LAT_DECIMAL,
    MAX(LON_DECIMAL) AS LON_DECIMAL
FROM
    INEGI
GROUP BY
    Concatenated_Column;
	**/ 

CREATE TABLE INEGI_UNIQUE (
    CONCATENATED_COLUMN nvarchar(MAX), -- Adjust the data type and length as needed
    LAT_DECIMAL FLOAT,
    LON_DECIMAL FLOAT
);

INSERT INTO INEGI_UNIQUE (Concatenated_Column, LAT_DECIMAL, LON_DECIMAL)
SELECT
    Concatenated_Column,
    MAX(LAT_DECIMAL) AS LAT_DECIMAL,
    MAX(LON_DECIMAL) AS LON_DECIMAL
FROM
    INEGI
GROUP BY
    Concatenated_Column;

SELECT * FROM [dbo].[INEGI_UNIQUE];

-- Merging columns of INEGI_UNIQUE to MUNI
-- Adding columns first LAT AND LON
ALTER TABLE [dbo].[IDM_NM_ago23]
ADD LAT_DECIMAL FLOAT, LON_DECIMAL FLOAT;


UPDATE [dbo].[IDM_NM_ago23] --MUNI
SET [dbo].[IDM_NM_ago23].LAT_DECIMAL = INEGI_UNIQUE.LAT_DECIMAL,  -- MUNI.LAT = INEGI.LAT, 
    [dbo].[IDM_NM_ago23].LON_DECIMAL = INEGI_UNIQUE.LON_DECIMAL  --INE.LON
FROM [dbo].[IDM_NM_ago23]
JOIN INEGI_UNIQUE ON [dbo].[IDM_NM_ago23].EntidadMunicipio = INEGI_UNIQUE.CONCATENATED_COLUMN;

-- Looking for NAN values
SELECT *
FROM [dbo].[IDM_NM_ago23]
WHERE LAT_DECIMAL IS NULL;

--Cleaning data 
ALTER TABLE [dbo].[IDM_NM_ago23]
DROP COLUMN LAT_DECIMAL, LON_DECIMAL;

