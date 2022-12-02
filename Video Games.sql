-- Selecting the table we will use

SELECT
	*
FROM [Video Game Sales].dbo.vgsales

-- Seeing which platform has the most games

SELECT
	platform,
	COUNT(*) AS num_of_games
FROM [Video Game Sales].dbo.vgsales
GROUP BY platform
ORDER BY num_of_games DESC

-- Seeing which year has the most games

SELECT
	year,
	COUNT(*) AS num_of_games
FROM [Video Game Sales].dbo.vgsales
WHERE year IS NOT NULL
GROUP BY year
ORDER BY num_of_games DESC

-- Seeing which genre has the most games

SELECT
	genre,
	COUNT(*) AS num_of_games
FROM [Video Game Sales].dbo.vgsales
GROUP BY genre
ORDER BY num_of_games DESC

-- Seeing which publisher makes the most games

SELECT
	publisher,
	COUNT(*) AS num_of_games
FROM [Video Game Sales].dbo.vgsales
GROUP BY publisher
ORDER BY num_of_games DESC

-- Looking at the total video game sales in millions in this dataset

SELECT
	ROUND(SUM(Global_sales), 2) * 1000000 AS total_sales
FROM [Video Game Sales].dbo.vgsales

-- Looking at the average sales in millions across regions

SELECT
	CONCAT(ROUND(100 * AVG(NA_sales), 2), ' million') AS avg_NA_sales,
	CONCAT(ROUND(100 * AVG(EU_sales), 2), ' million') AS avg_EU_sales,
	CONCAT(ROUND(100 * AVG(JP_sales), 2), ' million') AS avg_JP_sales,
	CONCAT(ROUND(100 * AVG(Other_sales), 2), ' million') AS avg_Other_sales,
	CONCAT(ROUND(100 * AVG(Global_sales), 2), ' million') AS avg_Global_sales
FROM [Video Game Sales].dbo.vgsales

-- Looking at the percentage 
-- NA_Sales vs Global_Sales

SELECT
	name,
	NA_Sales,
	Global_Sales,
	CONCAT(ROUND(NA_Sales/Global_Sales, 4) * 100, '%') AS Percent_of_NA_sales
FROM [Video Game Sales].dbo.vgsales

-- EU_Sales vs Global_Sales

SELECT
	name,
	EU_Sales,
	Global_Sales,
	CONCAT(ROUND(EU_Sales/Global_Sales, 4) * 100, '%') AS Percent_of_EU_sales
FROM [Video Game Sales].dbo.vgsales

-- JP_Sales vs Global_Sales

SELECT
	name,
	JP_Sales,
	Global_Sales,
	CONCAT(ROUND(JP_Sales/Global_Sales, 4) * 100, '%') AS Percent_of_JP_sales
FROM [Video Game Sales].dbo.vgsales

-- Other_Sales vs Global_Sales

SELECT
	name,
	Other_Sales,
	Global_Sales,
	CONCAT(ROUND(Other_Sales/Global_Sales, 4) * 100, '%') AS Percent_of_Other_sales
FROM [Video Game Sales].dbo.vgsales

-- Comparing the total NA_Sales vs EU_Sales vs JP_Sales vs Other_Sales vs Global_Sales

SELECT
	CONCAT(ROUND(1.0 * SUM(NA_Sales), 2), ' million') AS total_NA_sales,
	CONCAT(ROUND(1.0 * SUM(EU_Sales), 2), ' million') AS total_EU_sales,
	CONCAT(ROUND(1.0 * SUM(JP_Sales), 2), ' million') AS total_JP_sales,
	CONCAT(ROUND(1.0 * SUM(Other_Sales), 2), ' million') AS total_Other_sales,
	CONCAT(ROUND(1.0 * SUM(Global_Sales), 2), ' million') AS total_Global_sales
FROM [Video Game Sales].dbo.vgsales

-- Looking at the percentages of total sales by regions

SELECT
	(SELECT
		CONCAT(ROUND(100.0 * SUM(NA_Sales)/SUM(Global_Sales), 2), '%') 
	FROM [Video Game Sales].dbo.vgsales) AS percentage_NA_sales
	,
	(SELECT
		CONCAT(ROUND(100.0 * SUM(EU_Sales)/SUM(Global_Sales), 2), '%')
	FROM [Video Game Sales].dbo.vgsales) AS percentage_EU_sales
	,
	(SELECT
		CONCAT(ROUND(100.0 * SUM(JP_Sales)/SUM(Global_Sales), 2), '%')
	FROM [Video Game Sales].dbo.vgsales) AS percentage_JP_sales 
	,
	(SELECT
		CONCAT(ROUND(100.0 * SUM(Other_Sales)/SUM(Global_Sales), 2), '%')
	FROM [Video Game Sales].dbo.vgsales) AS percentage_Other_sales

-- Looking at the percentage of NA_Sales that are greater than EU, JP, and Other Sales combined 

SELECT
	REPLACE(CONCAT(ROUND(100.0 * COUNT(CASE WHEN NA_Sales > (EU_Sales + JP_Sales + Other_Sales) THEN 1 ELSE NULL END)/
	COUNT(*), 2), '%'), '0', '') AS percent_Top_NA 
FROM [Video Game Sales].dbo.vgsales

-- Looking at the top 10 selling games

WITH top_sale 
AS (
	SELECT
		name,
		platform,
		year,
		genre,
		publisher,
		MAX(Global_Sales) AS total_sales,
		DENSE_RANK() OVER(ORDER BY MAX(Global_Sales) DESC) AS rk
	FROM [Video Game Sales].dbo.vgsales
	GROUP BY name, platform, year, genre, publisher
	)

SELECT
	name,
	platform,
	year,
	genre,
	publisher,
	total_sales
FROM top_sale
WHERE rk <= 10

-- Looking at the top 10 selling games not published by Nintendo

WITH top_sale 
AS (
	SELECT
		name,
		platform,
		year,
		genre,
		publisher,
		MAX(Global_Sales) AS total_sales,
		DENSE_RANK() OVER(ORDER BY MAX(Global_Sales) DESC) AS rk
	FROM [Video Game Sales].dbo.vgsales
	WHERE publisher != 'Nintendo'
	GROUP BY name, platform, year, genre, publisher
	)

SELECT
	name,
	platform,
	year,
	genre,
	publisher,
	total_sales
FROM top_sale
WHERE rk <= 10

-- Seeing which platform has sold the most games

SELECT 
	platform,
	ROUND(1.0 * SUM(Global_Sales), 2) AS total_sales
FROM [Video Game Sales].dbo.vgsales
GROUP BY platform
ORDER BY total_sales DESC

-- Looking at the total sales worldwide by year

SELECT
	year,
	ROUND(1.0 * SUM(Global_Sales), 2) AS total_sales
FROM [Video Game Sales].dbo.vgsales
WHERE year IS NOT NULL
GROUP BY year
ORDER BY year 

-- Seeing which genre has sold the most games in millions

SELECT
	genre,
	ROUND(1.0 * SUM(Global_Sales), 2) AS total_sales
FROM [Video Game Sales].dbo.vgsales
GROUP By genre
ORDER BY total_sales DESC

-- Seeing how many games the top 10 publishers sells in millions

WITH top_publisher 
AS(
	SELECT 
		publisher,
		ROUND(1.0 * SUM(Global_Sales), 2) AS total_sales,
		DENSE_RANK() OVER(ORDER BY SUM(Global_Sales) DESC) AS rk
	FROM [Video Game Sales].dbo.vgsales
	GROUP BY publisher
	)

SELECT
	publisher,
	total_sales
FROM top_publisher
WHERE rk <= 10

-- Looking at the top 10 video game names and their sales for each regions

SELECT
	name,
	NA_sales,
	EU_sales,
	JP_sales,
	Other_sales
FROM (
	SELECT 
		name,
		ROUND(1.0 * SUM(NA_Sales), 2) AS NA_sales,
		ROUND(1.0 * SUM(EU_Sales), 2) AS EU_sales,
 		ROUND(1.0 * SUM(JP_Sales), 2) AS JP_sales,
		ROUND(1.0 * SUM(Other_Sales), 2) AS Other_sales,
		DENSE_RANK() OVER(ORDER BY SUM(Global_sales) DESC) AS rk
	FROM [Video Game Sales].dbo.vgsales
	GROUP BY name
	) sub
WHERE rk <= 10

-- Looking at the top 10 platforms and their sales for each regions

SELECT
	platform,
	NA_sales,
	EU_sales,
	JP_sales,
	Other_sales
FROM (
	SELECT 
		platform,
		ROUND(1.0 * SUM(NA_Sales), 2) AS NA_sales,
		ROUND(1.0 * SUM(EU_Sales), 2) AS EU_sales,
 		ROUND(1.0 * SUM(JP_Sales), 2) AS JP_sales,
		ROUND(1.0 * SUM(Other_Sales), 2) AS Other_sales,
		DENSE_RANK() OVER(ORDER BY SUM(Global_sales) DESC) AS rk
	FROM [Video Game Sales].dbo.vgsales
	GROUP BY platform
	) sub
WHERE rk <= 10

-- Looking at the different genres and their sales for each regions

SELECT 
	genre,
	ROUND(1.0 * SUM(NA_Sales), 2) AS NA_sales,
	ROUND(1.0 * SUM(EU_Sales), 2) AS EU_sales,
 	ROUND(1.0 * SUM(JP_Sales), 2) AS JP_sales,
	ROUND(1.0 * SUM(Other_Sales), 2) AS Other_sales
FROM [Video Game Sales].dbo.vgsales
GROUP BY genre
ORDER BY SUM(Global_sales) DESC

-- Looking at the top 10 publishers and their sales for each regions

SELECT
	publisher,
	NA_sales,
	EU_sales,
	JP_sales,
	Other_sales
FROM (
	SELECT 
		publisher,
		ROUND(1.0 * SUM(NA_Sales), 2) AS NA_sales,
		ROUND(1.0 * SUM(EU_Sales), 2) AS EU_sales,
 		ROUND(1.0 * SUM(JP_Sales), 2) AS JP_sales,
		ROUND(1.0 * SUM(Other_Sales), 2) AS Other_sales,
		DENSE_RANK() OVER(ORDER BY SUM(Global_sales) DESC) AS rk
	FROM [Video Game Sales].dbo.vgsales
	GROUP BY publisher
	) sub
WHERE rk <= 10


