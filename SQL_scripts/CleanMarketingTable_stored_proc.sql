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
      ,[MntWines]
      ,[MntFruits]
      ,[MntMeatProducts]
      ,[MntFishProducts]
      ,[MntSweetProducts]
      ,[MntGoldProds]
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
INTO marketing_data_prepared
FROM [marketing_data]

END