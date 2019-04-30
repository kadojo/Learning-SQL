USE [LD_DataMgt]
GO

SELECT 
	cn, 
	displayName, 
	distinguishedName, 
	employeeID, 
	l, 
	mail, 
	mobile,
	physicalDeliveryOfficeName, 
	'Error On Fetch Fix Later' AS postalAddress, 
	postalCode, 
	sAMAccountName, 
	sn, 
	telephoneNumber, 
	title, 
	extensionAttribute1, 
	extensionAttribute5, 
	extensionAttribute7, 
	extensionAttribute14,
	CAST(CAST(objectguid AS uniqueidentifier) AS nvarchar(60)), -- HAS TO BE LIKE THIS TO WORK
	'Barrow'
FROM OpenQuery ( 
  [PURPLE_AD],  
  'SELECT objectguid, displayName, distinguishedName, employeeID, sAMAccountName, sn, title, l, mail, mobile, telephoneNumber, postalCode, postalAddress, physicalDeliveryOfficeName, extensionAttribute1, extensionAttribute5, extensionAttribute7, extensionAttribute14, cn 
  FROM  ''LDAP://purple.zebra.ad/OU=Users,OU=Departments,OU=Barrow,OU=Submarines,DC=purple,DC=zebra,DC=ad'' 
  WHERE objectClass =  ''User'' 
  ') AS tblAdUsers
--WHERE extensionAttribute14 IS NOT NULL
ORDER BY displayname





GO


