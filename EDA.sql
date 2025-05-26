-- Exploratory data anlysis Project
-- finding insights

select * from layoffs_staging2;

SELECT MAX(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;

SELECT * from layoffs_staging2
where percentage_laid_off=1
order by total_laid_off desc;

-- which company had the most layoffs
SELECT COMPANY, SUM(TOTAL_LAID_OFF)
FROM LAYOFFS_STAGING2
GROUP BY COMPANY
ORDER BY SUM(TOTAL_LAID_OFF) DESC;    -- KNOWN COMPANIES

SELECT MIN(date),max(date)
from layoffs_staging2;

-- which industry had the most layoffs
SELECT industry, SUM(TOTAL_LAID_OFF)
FROM LAYOFFS_STAGING2
GROUP BY industry
ORDER BY SUM(TOTAL_LAID_OFF) DESC;

-- which country hot max layoffs

SELECT country, SUM(TOTAL_LAID_OFF)
FROM LAYOFFS_STAGING2
GROUP BY country
ORDER BY SUM(TOTAL_LAID_OFF) DESC;

-- how many layoffs in each year

SELECT YEAR(DATE), SUM(TOTAL_LAID_OFF)
FROM layoffs_staging2
GROUP BY YEAR(DATE)
ORDER BY SUM(total_laid_off) DESC;

-- layoffs happened the most durinh which particular stage of the company
SELECT STAGE, SUM(TOTAL_LAID_OFF)
FROM layoffs_staging2
GROUP BY STAGE
ORDER BY SUM(total_laid_off) DESC limit 1;

-- number of layoffs in each month
SELECT substring(DATE,1,7) AS MONTH, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY MONTH
ORDER BY SUM(total_laid_off) DESC;

-- finding the total cumulative layoffs after each passing month(rolling layoffs)

with rolling_cte as
(
SELECT substring(DATE,1,7) AS MONTH, SUM(total_laid_off) as total_off
FROM layoffs_staging2
where substring(DATE,1,7) is not null
GROUP BY MONTH
ORDER BY 1 asc
)
SELECT month, total_off, sum(total_off) over(order by month) as cumulative
from rolling_cte;

-- not done fully 

SELECT COMPANY,year(date), SUM(TOTAL_LAID_OFF)
FROM LAYOFFS_STAGING2
GROUP BY COMPANY,year(date)
ORDER BY sum(total_laid_off) desc;
