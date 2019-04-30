DECLARE @RepPathFilter nvarchar(100)
DECLARE @RepNameFilter nvarchar(100)

SET @RepPathFilter = ''
SET @RepNameFilter = ''


SELECT RepCat.[ItemID]
, RepCat.[Path] AS ReportPath
, RepCat.[Name] AS ReportName
, schdlog.[LastRunTime] AS ReportLastSchedRun
, exlog.UserName
,exlog.[Status]
,exlog.TimeStart
,exlog.TimeEnd
,exlog.TimeDataRetrieval
,exlog.TimeProcessing
,exlog.TimeRendering
,exlog.ByteCount
,exlog.[RowCount]
,exlog.[Parameters]


FROM [ReportServer].[dbo].[Catalog] RepCat
LEFT OUTER JOIN [ReportServer].[dbo].[ExecutionLogStorage] exlog ON RepCat.[ItemID] = exlog.[ReportID]
LEFT OUTER JOIN [ReportServer].[dbo].[Subscriptions] schdlog ON RepCat.[ItemID] = schdlog.[Report_OID]

WHERE RepCat.[Name] != ''
AND RepCat.[Name] != 'System Resources'
AND RepCat.[Path] LIKE '%' + @RepPathFilter + '%'
AND RepCat.[Name] LIKE '%' + @RepNameFilter + '%'


ORDER BY RepCat.[Name] ASC