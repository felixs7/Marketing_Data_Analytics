CREATE PROCEDURE CleanMarketingTable
AS
BEGIN
SET NOCOUNT ON

IF OBJECT_ID('dbo.marketing_data_prepared', 'U') IS NOT NULL 
  DROP TABLE dbo.marketing_data_prepared; 

-- Copy existing table - indexes and keys are lost in this stage but that's okay in that particular scenario
SELECT [ID]
      ,[Year_Birth]
	  ,YEAR(GETDATE()) - [Year_Birth] as Age -- This is not the exact age as we have no day and month data but it solves the purpose here
      ,[Education]
      ,[Marital_Status]
      , CAST(ISNULL(REPLACE(REPLACE([Income], '$', ''),',',''), '0') AS decimal(15,2)) as Income
      ,[Kidhome]
      ,[Teenhome]
      ,CONVERT(DATETIME,[Dt_Customer],23) as Dt_Customer
      ,[Recency]
      ,CAST([MntWines] AS int) as [MntWines]
      ,CAST([MntFruits] AS int)  as [MntFruits]
      ,CAST([MntMeatProducts] AS int)   as [MntMeatProducts]
      ,CAST([MntFishProducts] AS int)  as [MntFishProducts]
      ,CAST([MntSweetProducts] AS int)  as [MntSweetProducts]
      ,CAST([MntGoldProds] AS int)  as [MntGoldProds]
      ,[NumDealsPurchases]
      ,[NumWebPurchases]
      ,[NumCatalogPurchases]
      ,[NumStorePurchases]
      ,[NumWebVisitsMonth]
      ,[AcceptedCmp3]
      ,[AcceptedCmp4]
      ,[AcceptedCmp5]
      ,[AcceptedCmp1]
      ,[AcceptedCmp2]
      ,[Response]
      ,[Complain]
      ,[Country]
	  , [MntWines] + [MntFruits] + [MntMeatProducts] + [MntFishProducts] + [MntSweetProducts] + [MntGoldProds] as TotalAmountSpent
	  , [Kidhome] + [Teenhome] as TotalKids
INTO marketing_data_prepared
FROM [marketing_data]

-- A birth year less than 1900 is highly unlikely and is probably due to data entry errors
-- This is replaced with the median birth year
DECLARE @median_birthyear AS INT;
SELECT @median_birthyear = 
(
 (SELECT MAX([Year_Birth]) FROM
   (SELECT TOP 50 PERCENT [Year_Birth] FROM marketing_data_prepared ORDER BY [Year_Birth]) AS BottomHalf)
 +
 (SELECT MIN([Year_Birth]) FROM
   (SELECT TOP 50 PERCENT [Year_Birth] FROM marketing_data_prepared ORDER BY [Year_Birth] DESC) AS TopHalf)
) / 2 

UPDATE marketing_data_prepared
SET [Year_Birth] = @median_birthyear
WHERE  [Year_Birth] < 1900


-- create a view to analyse bought products by category. Amount spent on each category is currently pivoted.
-- Unpivot here to simplify subsequent analysis. We need to use dynamic SQL here to drop and create these views.

exec('
IF OBJECT_ID(''dbo.VAmountSpentByProduct'', ''v'') IS NOT NULL 
  DROP VIEW dbo.VAmountSpentByProduct;'
)
exec('
CREATE VIEW dbo.VAmountSpentByProduct AS
SELECT ID, RotatedCol, ValueCol
FROM (SELECT  ID, MntWines, MntFruits ,MntMeatProducts ,MntFishProducts ,MntSweetProducts ,MntGoldProds
              FROM [Marketing_Analytics].[dbo].[marketing_data_prepared]) p
UNPIVOT(
ValueCol FOR RotatedCol IN (MntWines, MntFruits ,MntMeatProducts ,MntFishProducts ,MntSweetProducts ,MntGoldProds)
) as unpvt
')
END