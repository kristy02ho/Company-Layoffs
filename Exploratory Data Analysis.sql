-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

-- Look at the maximum laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Look at all companies that laid off entire company
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Look at total laid off from all years at each company
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Look at time frame of layoffs
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Look at total layoffs for each industry
SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT * 
FROM layoffs_staging2;

-- Look at total layoffs for each country
SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Look at total layoffs for each year
SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Look at total layoffs for each stage
SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Look at layoff percentages for each industry
SELECT industry, AVG(percentage_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- ROLLING TOTALS
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Look at rolling totals for each month
WITH Rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Look at total laid off for each year at each company
SELECT company, YEAR(`date`) AS `YEAR`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, `YEAR`
ORDER BY 3 DESC;

-- Look at top 5 companies with most layoffs per year
WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`) AS `YEAR`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, `YEAR`
), Company_Year_Rank AS
(
SELECT company, years, total_laid_off, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;
