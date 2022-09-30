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

-- Looking at the percentage 
-- NA_Sales vs Global_Sales

SELECT
	name,
	NA_Sales,
	Global_Sales,
	ROUND(NA_Sales/Global_Sales, 4)*100 AS Percent_of_NA_sales
FROM [Video Game Sales].dbo.vgsales

-- EU_Sales vs Global_Sales

SELECT
	name,
	EU_Sales,
	Global_Sales,
	ROUND(EU_Sales/Global_Sales, 4)*100 AS Percent_of_EU_sales
FROM [Video Game Sales].dbo.vgsales

-- JP_Sales vs Global_Sales

SELECT
	name,
	JP_Sales,
	Global_Sales,
	ROUND(JP_Sales/Global_Sales, 4)*100 AS Percent_of_JP_sales
FROM [Video Game Sales].dbo.vgsales

-- Other_Sales vs Global_Sales

SELECT
	name,
	Other_Sales,
	Global_Sales,
	ROUND(Other_Sales/Global_Sales, 4)*100 AS Percent_of_Other_sales
FROM [Video Game Sales].dbo.vgsales

-- Comparing total NA_Sales vs EU_Sales vs JP_Sales vs Other_Sales vs Global_Sales
-- Looking at the total sum of every region and their total percentages for sales

SELECT
	SUM(CAST(NA_Sales AS decimal(10,2))) AS total_NA_sales,
	SUM(CAST(EU_Sales AS decimal(10,2))) AS total_EU_sales,
	SUM(CAST(JP_Sales AS decimal(10,2))) AS total_JP_sales,
	SUM(CAST(Other_Sales AS decimal(10,2))) AS total_Other_sales,
	SUM(CAST(Global_Sales AS decimal(10,2))) AS total_Global_sales
FROM [Video Game Sales].dbo.vgsales

SELECT
	(SELECT SUM(CAST(NA_Sales AS decimal(10,2)))
	FROM [Video Game Sales].dbo.vgsales)
	/
	(SELECT SUM(CAST(Global_Sales AS decimal(10,2)))
	FROM [Video Game Sales].dbo.vgsales) * 100 AS percentage_NA_sales
	,
	(SELECT SUM(CAST(EU_Sales AS decimal(10,2)))
	FROM [Video Game Sales].dbo.vgsales)
	/
	(SELECT SUM(CAST(Global_Sales AS decimal(10,2)))
	FROM [Video Game Sales].dbo.vgsales) * 100 AS percentage_EU_sales
	,
	(SELECT SUM(CAST(JP_Sales AS decimal(10,2)))
	FROM [Video Game Sales].dbo.vgsales)
	/
	(SELECT SUM(CAST(Global_Sales AS decimal(10,2)))
	FROM [Video Game Sales].dbo.vgsales) * 100 AS percentage_JP_sales
	,
	(SELECT SUM(CAST(Other_Sales AS decimal(10,2)))
	FROM [Video Game Sales].dbo.vgsales)
	/
	(SELECT SUM(CAST(Global_Sales AS decimal(10,2)))
FROM [Video Game Sales].dbo.vgsales) * 100 AS percentage_Other_sales

-- Looking at the top 10 selling games

WITH top_sale AS
	(SELECT
		name,
		platform,
		year,
		genre,
		publisher,
		MAX(Global_Sales) AS Top_Sales,
		DENSE_RANK() OVER(ORDER BY MAX(Global_Sales) DESC) AS rk
	FROM [Video Game Sales].dbo.vgsales
	GROUP BY name, platform, year, genre, publisher)

SELECT
	*
FROM top_sale
WHERE rk <= 10

-- Looking at the top 10 selling action games

WITH top_action AS
		(SELECT
			name,
			platform,
			year,
			genre,
			publisher,
			MAX(Global_Sales) AS Top_Sales,
			DENSE_RANK() OVER(ORDER BY MAX(Global_Sales) DESC) AS rk
		FROM [Video Game Sales].dbo.vgsales
		WHERE genre = 'Action'
		GROUP BY name, platform, year, genre, publisher)

SELECT
	*
FROM top_action
WHERE rk <= 10

-- Seeing how many games the top 10 publisher sells in millions

WITH top_publisher AS
		(SELECT 
			publisher,
			SUM(CAST(Global_Sales AS decimal(10,2))) AS total_sales,
			DENSE_RANK() OVER(ORDER BY SUM(Global_Sales) DESC) AS rk
		FROM [Video Game Sales].dbo.vgsales
		GROUP BY publisher)

SELECT
	*
FROM top_publisher
WHERE rk <= 10

-- Seeing which genre has sold the most games in millions

SELECT
	genre,
	SUM(CAST(Global_Sales AS decimal(10,2))) AS total_sales
FROM [Video Game Sales].dbo.vgsales
GROUP By genre
ORDER BY total_sales DESC

-- Seeing which platform sold the most games

SELECT 
	platform,
	SUM(CAST(Global_Sales AS decimal(10,2))) AS total_sales
FROM [Video Game Sales].dbo.vgsales
GROUP BY platform
ORDER BY total_sales DESC

-- Looking at total sales worldwide by year

SELECT
	year,
	SUM(CAST(Global_Sales AS decimal(10,2))) AS total_sales
FROM [Video Game Sales].dbo.vgsales
WHERE year IS NOT NULL
GROUP BY year
ORDER BY year 

-- Looking at top 10 video game names in NA and the sales for each regions

SELECT TOP 10
	name,
	SUM(CAST(NA_Sales AS decimal(10,2))) AS NA_sales,
	SUM(CAST(EU_Sales AS decimal(10,2))) AS EU_sales,
 	SUM(CAST(JP_Sales AS decimal(10,2))) AS JP_sales,
	SUM(CAST(Other_Sales AS decimal(10,2))) AS Other_sales
FROM [Video Game Sales].dbo.vgsales
GROUP BY name
ORDER BY NA_sales DESC

-- Looking at top 10 platforms in NA and the sales for each regions

SELECT TOP 10
	platform,
	SUM(CAST(NA_Sales AS decimal(10,2))) AS NA_sales,
	SUM(CAST(EU_Sales AS decimal(10,2))) AS EU_sales,
 	SUM(CAST(JP_Sales AS decimal(10,2))) AS JP_sales,
	SUM(CAST(Other_Sales AS decimal(10,2))) AS Other_sales
FROM [Video Game Sales].dbo.vgsales
GROUP BY platform
ORDER BY NA_sales DESC

-- Looking at genres and the sales for each regions

SELECT 
	genre,
	SUM(CAST(NA_Sales AS decimal(10,2))) AS NA_sales,
	SUM(CAST(EU_Sales AS decimal(10,2))) AS EU_sales,
 	SUM(CAST(JP_Sales AS decimal(10,2))) AS JP_sales,
	SUM(CAST(Other_Sales AS decimal(10,2))) AS Other_sales
FROM [Video Game Sales].dbo.vgsales
GROUP BY genre
ORDER BY NA_sales DESC

-- Looking at top 10 publishers in NA and the sales for each regions

SELECT TOP 10
	publisher,
	SUM(CAST(NA_Sales AS decimal(10,2))) AS NA_sales,
	SUM(CAST(EU_Sales AS decimal(10,2))) AS EU_sales,
 	SUM(CAST(JP_Sales AS decimal(10,2))) AS JP_sales,
	SUM(CAST(Other_Sales AS decimal(10,2))) AS Other_sales
FROM [Video Game Sales].dbo.vgsales
GROUP BY publisher
ORDER BY NA_sales DESC

