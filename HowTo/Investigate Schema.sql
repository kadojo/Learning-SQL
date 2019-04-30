SET NOEXEC OFF
SET NOCOUNT ON


--THIS SCRIPT IGNORES DATA TYPES OF 'bit','image','varbinary'


DECLARE @SearchType nvarchar(20)  -- Text\Number\Date\GUID
DECLARE @SearchFor nvarchar(200) 
DECLARE @ScriptFilter nvarchar(300)
DECLARE @TableFilter nvarchar(200)
DECLARE @ColumnFilter nvarchar(200)
DECLARE @ShowResults bit = 1

SET @SearchType = 'Guid'
SET @SearchFor = '8A2C2C41-321F-4B4C-AA29-54E603CD361D'
SET @TableFilter = 'query'
SET @ColumnFilter = ''


-- REMOVE TEMP TABLE IF EXISTS

IF OBJECT_ID('tempdb..#SearchScripts') IS NOT NULL
BEGIN
	PRINT '#SearchScripts exists - Dropping!'
	DROP TABLE #SearchScripts
END


-- VALIDATE PROVIDED PARAMETERS

IF ISNULL(@SearchFor,'') = '' 
BEGIN 
	PRINT 'Execution cancelled, @SearchFor IS NULL or Empty - Reduce the impact to the server by focusing the search!'
	SET NOEXEC ON
END

IF @SearchType NOT IN ('Text','Number','Date','GUID') 
BEGIN
	PRINT 'Execution cancelled, @SearchType must be Text, Number or Date'
	SET NOEXEC ON
END

IF @TableFilter IS NULL
BEGIN 
	PRINT 'Execution cancelled, @TableFilter IS NULL'
	SET NOEXEC ON
END


-- IF PARAMETERS VALIDATED THEN CONTINUE 

-- PREPARE SQL SEARCH SCRIPTS

IF @SearchType = 'Text'
BEGIN
	SET @ScriptFilter = 'LIKE ''%' +  @SearchFor + '%'''
END


IF @SearchType = 'Number'
BEGIN
	SET @ScriptFilter = '= ' + @SearchFor
END


IF @SearchType = 'Date'
BEGIN
	SET @ScriptFilter = '= ''' +  @SearchFor + ''''
END


IF @SearchType = 'GUID'
BEGIN
	SET @ScriptFilter = '= ''' +  @SearchFor + ''''
END

	SELECT RowNum = ROW_NUMBER() OVER(ORDER BY TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME) 
		,CASE @SearchType
			WHEN 'GUID' THEN 'FROM [' + TABLE_CATALOG + '].[' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] WHERE CAST([' + COLUMN_NAME + '] AS nvarchar(50)) ' + @ScriptFilter
			ELSE 'FROM [' + TABLE_CATALOG + '].[' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] WHERE [' + COLUMN_NAME + '] ' + @ScriptFilter 
		END AS SearchScript
		,TABLE_CATALOG AS DbName
		,TABLE_SCHEMA AS SchemaName
		,TABLE_NAME AS TableName
		,COLUMN_NAME AS ColName
		,@ScriptFilter AS Filter
		,0 AS RecCount
	INTO #SearchScripts
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_CATALOG + TABLE_SCHEMA + TABLE_NAME IN (SELECT TABLE_CATALOG + TABLE_SCHEMA + TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE')
	--AND DATA_TYPE NOT IN ('bit','image','uniqueidentifier','varbinary','xml')
	AND DATA_TYPE NOT IN ('bit','image','varbinary','xml')
	AND TABLE_NAME LIKE '%' + @TableFilter + '%'
	AND COLUMN_NAME LIKE '%' + @ColumnFilter + '%'
	AND	CASE @SearchType 
			WHEN 'Date' THEN CAST(DATETIME_PRECISION AS nvarchar(50))
			WHEN 'Number' THEN CAST(NUMERIC_PRECISION AS nvarchar(50))
			WHEN 'Text' THEN CAST(CHARACTER_MAXIMUM_LENGTH AS nvarchar(50))
			WHEN 'GUID' THEN CAST(DATA_TYPE AS nvarchar(50))
		END IS NOT NULL  -- This needs Fixing to filter the type down


		DECLARE @Script nvarchar(MAX)
		DECLARE @ScriptCount nvarchar(MAX)
		DECLARE @RecCount bigint
		DECLARE @Db nvarchar(300)
		DECLARE @Table nvarchar(300)
		DECLARE @Field nvarchar(300)
		
		DECLARE @MaxRownum INT
		SET @MaxRownum = (SELECT MAX(RowNum) FROM #SearchScripts)

		DECLARE @Iter INT
		SET @Iter = (SELECT MIN(RowNum) FROM #SearchScripts)



		PRINT 'START LOOP'
		 WHILE @Iter <= @MaxRownum
		BEGIN

			IF OBJECT_ID('tempdb..#RecCounts') IS NOT NULL
			BEGIN
				PRINT '#RecCounts exists - Dropping!'
				DROP TABLE #RecCounts
			END

			 SELECT @Script = 'SELECT ''' + TableName + ''' AS TableName, ''' + ColName + ''' AS ColumnSearched, * ' + SearchScript
					, @ScriptCount = 'SELECT [' + ColName + '] AS CheckColumn INTO #RecCounts ' + SearchScript
					, @Db = DbName
					, @Table = TableName
					, @Field = ColName 
			 FROM #SearchScripts 
			 WHERE RowNum = @Iter

			 EXECUTE sp_executesql @ScriptCount
			 SET @RecCount = @@ROWCOUNT

			 --IF (@RecCount > 0)
			 --  BEGIN 
				--	UPDATE #SearchScripts SET @RecCount = @RecCount WHERE RowNum = @Iter
			 --  END  		      

			 IF ( @RecCount > 0)
			   BEGIN
					UPDATE #SearchScripts SET RecCount = @RecCount WHERE RowNum = @Iter

					IF (@ShowResults <> 0)
					BEGIN
						PRINT 'Searching ...... Db:' + @Db + '  Table:' + @Table + '			Column:' + @Field + '			Count:' + CAST(@RecCount AS nvarchar(10))
						EXECUTE sp_executesql @Script
					END
					ELSE
					BEGIN
						PRINT 'Saved Search For :  Db:' + @Db + '  Table:' + @Table + '				Column:' + @Field + '			Count:' + CAST(@RecCount AS nvarchar(10))
					END
			   END
			   --ELSE
			   --BEGIN
					--PRINT 'IGNORING ...... Db:' + @Db + '  Table:' + @Table + '  Column:' + @Field + '  Count:' + CAST(@RecCount AS nvarchar(10))
			   --END		
			   
			 SET @Iter = @Iter + 1

		END
		PRINT 'END LOOP'

	SELECT * FROM #SearchScripts WHERE RecCount > 0


	DROP TABLE #SearchScripts
