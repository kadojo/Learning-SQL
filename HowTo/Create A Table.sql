/*
To prevent any potential data loss issues, you should
review this script in detail before running it outside
the context of the database designer.

The table name and main column name will need to be changed
You may want to add more columns
"Xxx" are all strings that need to be replaced

*/


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.AT_LST_Xxx
(
RecID int NOT NULL IDENTITY (1, 1),
XxxName nvarchar(50) NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.AT_LST_Xxx ADD CONSTRAINT
PK_AT_LST_Xxx PRIMARY KEY CLUSTERED
(
RecID
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 
GO
COMMIT
 
