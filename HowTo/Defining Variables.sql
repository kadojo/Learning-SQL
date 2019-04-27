DECLARE @MyString nvarchar(100)
DECLARE @MyInt int()
DECLARE @MyDateOrTime datetime()
DECLARE @MyBoolean bit()


--To populate a variable there are 2 key methods
SET @MyString = 'My Value'
SELECT @MyString = Column FROM Table WHERE RecordID = 1
