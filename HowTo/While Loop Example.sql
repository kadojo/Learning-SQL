SELECT 
     RowNum = ROW_NUMBER() OVER(ORDER BY CustomerID)
     ,*
INTO #ListToDo
FROM SalesLT.Customer

DECLARE @MaxRownum INT
SET @MaxRownum = (SELECT MAX(RowNum) FROM #ListToDo)

DECLARE @Iter INT
SET @Iter = (SELECT MIN(RowNum) FROM #ListToDo)

 WHILE @Iter <= @MaxRownum
BEGIN
     SELECT *
     FROM #ListToDo
     WHERE RowNum = @Iter
     
     -- run your operation here
     
     SET @Iter = @Iter + 1
END

DROP TABLE #ListToDo