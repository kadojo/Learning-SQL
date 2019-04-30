DECLARE @GrpName AS nvarchar(100)
SET @GrpName = 'PERM_Janus_Allow'

DECLARE @OuName AS nvarchar(200)
SET @OuName = 'Security Groups'


DECLARE @tsql AS nvarchar(MAX) 
SET @tsql = 'SELECT ' 
			+ '''' + @GrpName + '''' + ' AS MemberOf,  	
			CAST(CAST(objectguid AS uniqueidentifier) AS nvarchar(60)) AS UserObjectGuid, -- HAS TO BE LIKE THIS TO WORK
			cn, 
			displayName, 
			distinguishedName, 
			mail, 
			sAMAccountName 
		FROM OPENQUERY([PURPLE_AD],'
				+ '''SELECT objectguid, displayName, distinguishedName, sAMAccountName, mail, cn 
		FROM ''''LDAP://DC=purple,DC=zebra,DC=ad''''
		WHERE objectCategory = ''''Person''''
		AND objectClass = ''''User''''
		AND memberOf = ''''' + @GrpName + ''')''

PRINT @tsql

EXEC(@tsql) 

		--AND memberOf = ''''CN=' + @GrpName + ',OU=' + @OuName + ',DC=purple,DC=zebra,DC=ad'''' ''' + ')'
