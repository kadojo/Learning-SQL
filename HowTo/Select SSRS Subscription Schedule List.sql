SELECT rs.[ScheduleID] AS ScheduleID_SQLJobName
	  ,u.UserName
      ,c.[Name]
      ,c.[Path]
  FROM [ReportServer].[dbo].[ReportSchedule] rs
  LEFT OUTER JOIN [ReportServer].[dbo].[Catalog] c ON rs.ReportID = c.ItemID
  LEFT OUTER JOIN [ReportServer].[dbo].[Subscriptions] s ON s.subscriptionID = rs.SubscriptionID
  LEFT OUTER JOIN [ReportServer].[dbo].[Users] u ON s.OwnerID = u.UserID
  ORDER BY u.UserName, c.Name