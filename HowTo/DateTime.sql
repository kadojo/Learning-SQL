/*
This file only scrapes the surface of what is possible
*/

--Define a datetime vaiable
DECLARE @MyDateOrTime datetime()

--Manually set a value to the variable
SET @MyDateOrTime = '2019-01-30 01:15:00'

--Set the variable to NOW!
SET @MyDateOrTime = GetDate()

--Set the variable to NOW - 1 Day
SET @MyDateTime = DateAdd(d,-1,GetDate())

--Display what is in the variable
SELECT @MyDateTime

--Display the datetime variable as Year-Month e.g. 2001-12
SELECT FORMAT(@MyDateTime,'yyyy-MM')
