SELECT 
	cn, 
	displayName, 
	distinguishedName, 
	sAMAccountName, 
	CAST(CAST(objectguid AS uniqueidentifier) AS nvarchar(60)) -- HAS TO BE LIKE THIS TO WORK
FROM OpenQuery ( 
  [PURPLE_AD],  
  'SELECT objectguid, displayName, distinguishedName, employeeID, sAMAccountName, sn, title, l, mail, mobile, telephoneNumber, postalCode, postalAddress, physicalDeliveryOfficeName, extensionAttribute1, extensionAttribute5, extensionAttribute7, extensionAttribute14, cn
  FROM  ''LDAP://purple.zebra.ad/OU=Distribution Lists,DC=purple,DC=zebra,DC=ad'' 
  WHERE objectCategory = ''Group''
  ') AS tblAdUsers
--WHERE extensionAttribute14 IS NOT NULL
ORDER BY displayname

