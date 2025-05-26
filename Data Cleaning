-- DATA CLEANING PROJECT

SELECT * FROM LAYOFFS;

-- 1.REMOVE DUPLICATES
-- 2. STANDARDIZE DATA 
-- 3.NULL OR BLANK VALUES
-- 4.REMOVE UNECESSARY COLUMNS

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- we neeed to partition by every single column
with duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,`DATE`,STAGE,COUNTRY,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_cte
WHERE row_num>1;

SELECT * FRoM layoffs_staging
where COMPANY= 'CASPER';

with duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,`DATE`,STAGE,COUNTRY,funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE FROM duplicate_cte       -- this command is not valid so we have to copy the data into another table with row_num column ans then delete
WHERE row_num>1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,`DATE`,STAGE,COUNTRY,funds_raised_millions) AS row_num
FROM layoffs_staging;

-- deleting duplicates final command
delete from layoffs_staging2
WHERE row_num>1;

-- confirming duplicates are deleted
SELECT * FROM layoffs_staging2
WHERE row_num>1;

-- STANDARDIZING DATA

SELECT COMPANY, TRIM(COMPANY)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET COMPANY=TRIM(COMPANY);

SELECT * FROM layoffs_staging2;

-- finding out repititive industry

SELECT distinct INDUSTRY FROM layoffs_staging2
ORDER BY 1;

SELECT * FROM layoffs_staging2
WHERE INDUSTRY LIKE '%crypto%';

update layoffs_staging2
set INDUSTRY='Crypto'
WHERE INDUSTRY LIKE 'Crypto%';

SELECT DISTINCT INDUSTRY FROM layoffs_staging2
ORDER BY INDUSTRY ASC;

SELECT DISTINCT LOCATION FROM layoffs_staging2   -- everything perfect in location
ORDER BY LOCATION;

SELECT DISTINCT country FROM layoffs_staging2   -- found error in usa
ORDER BY country;

SELECT * FROM layoffs_staging2
WHERE COUNTRY LIKE 'UNITED STATES.%';

update layoffs_staging2
set COUNTRY='United States'
WHERE country LIKE 'United States.%';      -- 4 rows affected

SELECT * FROM layoffs_staging2             -- all columns updated
WHERE COUNTRY LIKE 'UNITED STATES.%';

SELECT DISTINCT COUNTRY FROM layoffs_staging2
ORDER BY COUNTRY DESC;

SELECT DATE FROM layoffs_staging2;

-- converting str to date format and correcting the order

SELECT `DATE`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY `DATE` DATE;

-- 3. NULL AND BLANK VALUES

SELECT * FROM layoffs_staging2      -- unecessary values
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2
WHERE INDUSTRY IS NULL OR INDUSTRY='';

-- trying to find out those industries whose value we can populate in null ones

SELECT *
FROM layoffs_staging2 t1
join layoffs_staging2 t2
on t1.COMPANY=t2.company
WHERE (t1.industry is null or t1.industry='')
 and t2.industry is not null;
 
 -- we got three such comapnies airbnb, carvana, juul
 
 UPDATE layoffs_staging2
 set INDUSTRY = null
 WHERE INDUSTRY='';
 
UPDATE layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.COMPANY=t2.COMPANY
SET t1.industry=t2.industry
WHERE (t1.industry is null)
 and t2.industry is not null;
 
 -- CHECKING UPDATED VALUES
 SELECT * FROM layoffs_staging2
 WHERE COMPANY LIKE 'BALLY%';     -- exception as there wasnt any other populating row
 
 -- we arent gonna do for total laid off and percentage because we dont have sufficient data available 
 
-- 4. removing unecessary columns/rows

SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

delete 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER  TABLE layoffs_staging2
drop COLUMN row_num;

SELECT * FROM layoffs_staging2;    -- our final cleaned table       
