-- http://www.dotnetforce.com/Content.aspx?t=a&n=204
 
SET NOCOUNT ON
 
USE AdventureWorks
GO
 
DECLARE @MyQuery nvarchar(4000)
 
SET @MyQuery = 'SELECT Title as title,
ModifiedDate as pubdate,
DocumentSummary as description,
[Filename] as link
FROM Production.[Document] as item
FOR XML AUTO, ELEMENTS'
 
--PRINT @MyQuery
 
EXEC master.dbo.sp_makewebtask
@outputfile = 'C:\Rss.xml'
,@query = @MyQuery
,@templatefile = 'C:\@AppData\RssFeedTemplate.xml'
