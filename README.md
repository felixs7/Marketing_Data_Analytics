# Marketing Analytics Demo Project
Demo Project aiming to descriptively  analyse marketing data for a fictitious company. 
Project contains a single, relatively clean dataset that is stored in a SQL database. A stored procedure can be run to clean the raw data and to create the required views.
Power BI is then used to connect to the SQL database and to create basic visualisation to analyse
customer base and marketing campaigns.

1. To setup up the Database in its initial state run InitialDB_Setup.sql on your SQL Server. This will setup the database containing the raw Marketing Data Table as imported from the .csv
2. Run Stored Procedure [dbo].[CleanMarketingTable] to clean the raw data and to create the dbo.marketing_data_prepared table and
   VAmountSpentByProduct view.
3. Connect Power BI to the SQL Server database. The Power BI reports query the above view and marketing_data_prepared table.

![Report 1](img/Report1.png?raw=true "Report1")
![Report 1](img/Report2.png?raw=true "Report2")
![Report 1](img/Report3.png?raw=true "Report3")
