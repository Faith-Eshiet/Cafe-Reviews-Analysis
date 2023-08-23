SELECT *
FROM Reviews;

/* 
The reviews table is made up of 775 rows an 7 columns.
Table Features:
	Index: A unique identifier for each review entry.
	Name: The name of the cafe being reviewed.
	Overall Rating: The overall rating provided by the reviewer.
	Cuisine: The type of cuisine offered by the cafe.
	Rate for Two: The average cost for two people dining at the cafe.
	City: The city where the cafe is located.
	Review: A detailed review written by the customer, capturing their experience.
*/

/*
Project Goals:
	Explore the distribution of reviews across different cafes and cuisines.
	Analyze overall ratings and sentiment in the reviews.
	Understand the cost of dining at different cafes.
	Identify common keywords and themes in the reviews.
*/

--What is the total number of reviews?
SELECT COUNT(*) AS TotalReviews
FROM Reviews;

--What is the average overall rating provided by reviewers?
SELECT ROUND(AVG(Overall_Rating),1) AS AvgOverallRating
FROM Reviews;

--What is the highest and lowest overall rating given?
SELECT MIN(Overall_Rating) AS MinRating, MAX(Overall_Rating) AS MaxRating
FROM Reviews;

--How many unique cafes are included in the dataset?
SELECT COUNT(DISTINCT Name) AS UniqueCafes
FROM Reviews;

--What are the top 5 most reviewed cafes?
SELECT TOP 5 Name, COUNT(*) AS ReviewCount
FROM Reviews
GROUP BY Name
ORDER BY ReviewCount DESC;

--Which cuisines are most commonly offered by cafes in the dataset?
SELECT Cuisine, COUNT(*) AS CafeCount
FROM Reviews
GROUP BY Cuisine
ORDER BY CafeCount DESC;

--What is the distribution of cafes across different cities?
SELECT City, COUNT(DISTINCT Name) AS CafeCount
FROM Reviews
GROUP BY City
ORDER BY CafeCount DESC;

--What is the average cost for two people across all cafes?
SELECT ROUND(AVG([Rate for two]),0) AS AvgCostForTwo
FROM Reviews;

--How does the average cost for two vary across different cities?
SELECT City, ROUND(AVG([Rate for two]),0) AS AvgCostForTwo
FROM Reviews
GROUP BY City
ORDER BY AvgCostForTwo DESC;

--What percentage of reviews are positive, neutral, and negative?

SELECT
  SUM(CASE WHEN Overall_Rating >= 4 THEN 1 ELSE 0 END) AS Positive,
  SUM(CASE WHEN Overall_Rating < 4 AND Overall_Rating >= 3 THEN 1 ELSE 0 END) AS Neutral,
  SUM(CASE WHEN Overall_Rating < 3 THEN 1 ELSE 0 END) AS Negative,
  COUNT(Overall_Rating) AS Total
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1;

SELECT
  ROUND(SUM(CASE WHEN Overall_Rating >= 4 THEN 1 ELSE 0 END) * 100.0/ COUNT(Overall_Rating),0) AS Positive,
  ROUND(SUM(CASE WHEN Overall_Rating < 4 AND Overall_Rating >= 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(Overall_Rating),0) AS Neutral,
  ROUND(SUM(CASE WHEN Overall_Rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(Overall_Rating),0) AS Negative
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1;

-- Which cafes have the highest positive reviews?

SELECT TOP 5
	Name,
	Overall_Rating
FROM Reviews
WHERE Overall_Rating >= 4
GROUP BY Name, Overall_Rating
ORDER BY Overall_Rating DESC;


/* Are there any notable patterns in sentiment across different cities or cuisines?

Sentiment Analysis by City:
*/

SELECT
  City,
  ROUND(SUM(CASE WHEN Overall_Rating >= 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),0) AS PositivePercentage,
  ROUND(SUM(CASE WHEN Overall_Rating < 4 AND Overall_Rating >= 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),0) AS NeutralPercentage,
  ROUND(SUM(CASE WHEN Overall_Rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),0) AS NegativePercentage
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1
GROUP BY City
ORDER BY PositivePercentage DESC;

--Sentiment Analysis by Cuisine:
SELECT
  Cuisine,
  SUM(CASE WHEN Overall_Rating >= 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS PositivePercentage,
  SUM(CASE WHEN Overall_Rating < 4 AND Overall_Rating >= 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS NeutralPercentage,
  SUM(CASE WHEN Overall_Rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS NegativePercentage
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1
GROUP BY Cuisine
ORDER BY PositivePercentage DESC;

-- Which cafes have the highest average overall ratings?
SELECT TOP 5
	Name,
	ROUND(AVG(Overall_Rating),1) AS AvgRating
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1
GROUP BY Name
ORDER BY AvgRating DESC;

-- Which cafes have the lowest average overall ratings?
SELECT TOP 5
	Name,
	ROUND(AVG(Overall_Rating),1) AS AvgRating
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1
GROUP BY Name
ORDER BY AvgRating ASC;


/*
Are there any commonalities among the top-rated or bottom-rated cafes?

To identify commonalities among the top-rated or bottom cafes,
I will look at attributes such as Cuisine average cost, city location, and the sentiment of reviews.

Analyzing Top-Rated Cafes:
*/
SELECT
  Name,
  Cuisine,
  [Rate for two] AS AverageCost,
  City,
  AVG(Overall_Rating) AS AverageRating,
  SUM(CASE WHEN Overall_Rating >= 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS PositivePercentage
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1
GROUP BY Name, Cuisine, [Rate for two], City
HAVING AVG(Overall_Rating) >= 4
ORDER BY AverageRating DESC;


--Analyzing Bottom-Rated Cafes:
SELECT
  Name,
  Cuisine,
  [Rate for two] AS AverageCost,
  City,
  AVG(Overall_Rating) AS AverageRating,
  SUM(CASE WHEN Overall_Rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS NegativePercentage
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1
GROUP BY Name, Cuisine, [Rate for two], City
HAVING AVG(Overall_Rating) < 3
ORDER BY AverageRating ASC;


--What are the most common keywords or phrases used in reviews?

SELECT TOP 10
  CASE WHEN CHARINDEX(' ', Review) > 0 THEN LEFT(Review, CHARINDEX(' ', Review) - 1)
       ELSE Review END AS FirstWord,
  COUNT(*) AS KeywordCount
FROM Reviews
GROUP BY
  CASE WHEN CHARINDEX(' ', Review) > 0 THEN LEFT(Review, CHARINDEX(' ', Review) - 1)
       ELSE Review END
ORDER BY KeywordCount DESC;




--Which cities have the highest number of reviewed cafes?
SELECT City, COUNT(*) AS CafeCount
FROM Reviews
GROUP BY City
ORDER BY CafeCount DESC;


-- What is the average overall rating for cafes in each city?
SELECT City, ROUND(AVG(CAST(Overall_Rating AS float)),1) AS AvgOverallRating
FROM Reviews
WHERE ISNUMERIC(Overall_Rating) = 1
GROUP BY City
ORDER BY AvgOverallRating DESC;


--How are reviews and ratings distributed across different cities?
SELECT City, COUNT(*) AS ReviewCount, ROUND(AVG(Overall_Rating),1) AS AvgRating
FROM Reviews
GROUP BY City
ORDER BY AvgRating DESC, ReviewCount DESC;

