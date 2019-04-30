--CREATE PROCEDURE dbo.Get_ADGroups_ForUser
--(
DECLARE     @Username NVARCHAR(256) 
--)
--AS
--BEGIN

SET @UserName = 'Karl.Jones6'

    DECLARE @Query NVARCHAR(1024), @Path NVARCHAR(1024)

    SET @Query = '
        SELECT @Path = distinguishedName
        FROM OPENQUERY([PURPLE_AD], ''
            SELECT distinguishedName 
            FROM ''''LDAP://DC=purple,DC=zebra,DC=ad''''
            WHERE 
                objectClass = ''''user'''' AND
                sAMAccountName = ''''' + @Username + '''''
        '')
    '
    EXEC SP_EXECUTESQL @Query, N'@Path NVARCHAR(1024) OUTPUT', @Path = @Path OUTPUT 

    SET @Query = '
        SELECT ''' + @UserName + ''' AS UserName,cn,AdsPath 
        FROM OPENQUERY ([PURPLE_AD], ''<LDAP://DC=purple,DC=zebra,DC=ad>;(&(objectClass=group)(member:1.2.840.113556.1.4.1941:=' + @Path +'));cn, adspath;subtree'')'

    EXEC SP_EXECUTESQL @Query  

--END
GO