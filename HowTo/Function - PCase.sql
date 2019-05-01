
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER FUNCTION [dbo].[fnPCase]
(
@OrigValue NVARCHAR(4000)
)
RETURNS NVARCHAR(4000)
AS
BEGIN
-- Declare the return variable here
DECLARE @NewValue NVARCHAR(4000)
    DECLARE @Index INT
    DECLARE @DelLen INT
    DECLARE @Slice NVARCHAR(4000)
    DECLARE @SubSlice NVARCHAR(200)
    DECLARE @SubIndex INT
    DECLARE @TmpSlice1 NVARCHAR(200)
    DECLARE @TmpSlice2 NVARCHAR(200)
    DECLARE @Delimiter nvarchar(5)
    DECLARE @Separator nvarchar(3)
    -- HAVE TO SET TO 1 SO IT DOESNT EQUAL
    --     ZERO FIRST TIME IN LOOP
    SELECT @OrigValue = REPLACE(REPLACE(LTRIM(RTRIM(@OrigValue)),'   ',' '),'  ',' ') + ' '
    SELECT @Delimiter = ' '
    SELECT @Index = 1
    SELECT @SubIndex = 1
    SELECT @DelLen = LEN(@Delimiter)
    SELECT @NewValue = ''
    SELECT @Separator = ''
 
    IF @OrigValue IS NULL RETURN 'No String Provided'
   
-- Cleanse the original value
    SELECT @OrigValue = REPLACE(REPLACE(@OrigValue,'_',' '),'  ',' ')
    SELECT @OrigValue = REPLACE(REPLACE(@OrigValue,'.',' '),'  ',' ')
    SELECT @OrigValue = REPLACE(@OrigValue,'/',' / ')
    SELECT @OrigValue = REPLACE(@OrigValue,'\',' \ ')
--    SELECT @OrigValue = REPLACE(@OrigValue,'_',' ')
--    SELECT @OrigValue = REPLACE(@OrigValue,' -','-')
--    SELECT @OrigValue = REPLACE(@OrigValue,'- ','-')
--    SELECT @OrigValue = REPLACE(@OrigValue,' +','+')
--    SELECT @OrigValue = REPLACE(@OrigValue,'+ ','+')
--    SELECT @OrigValue = REPLACE(@OrigValue,' &','&')
--    SELECT @OrigValue = REPLACE(@OrigValue,'& ','&')
--''' -- This is a dummy line as some IDEs get confused by \
 
    IF CHARINDEX(@Delimiter,@OrigValue) = 0 RETURN ''
   
    WHILE @Index !=0
 
        BEGIN   
            -- GET THE INDEX OF THE FIRST OCCURENCE OF THE SPLIT CHARACTER
            SELECT @Index = CHARINDEX(@Delimiter,@OrigValue)
 
            -- NOW PUSH EVERYTHING TO THE LEFT OF IT INTO THE SLICE VARIABLE
            IF @Index !=0
                SELECT @Slice = LEFT(@OrigValue,@Index - 1 )
            ELSE
                SELECT @Slice = @OrigValue
 
-- PCase The Sliced Value
IF @Slice LIKE 'Mc%'
SELECT @Slice = 'Mc' + UPPER(SUBSTRING(@SLice,3,1)) + LOWER(RIGHT(@Slice,(LEN(@Slice)-3)))
ELSE IF @Slice LIKE 'Mac%' AND @Slice NOT LIKE 'Machine%'
SELECT @Slice = 'Mac' + UPPER(SUBSTRING(@SLice,4,1)) + LOWER(RIGHT(@Slice,(LEN(@Slice)-4)))
ELSE IF @Slice LIKE '@%'
SELECT @Slice = '@' + UPPER(SUBSTRING(@SLice,2,1)) + LOWER(RIGHT(@Slice,(LEN(@Slice)-2))) 
ELSE IF @Slice LIKE '(%'
SELECT @Slice = '(' + UPPER(SUBSTRING(@SLice,2,1)) + LOWER(RIGHT(@Slice,(LEN(@Slice)-2))) 
ELSE IF @Slice LIKE '[%'
SELECT @Slice = '[' + UPPER(SUBSTRING(@SLice,2,1)) + LOWER(RIGHT(@Slice,(LEN(@Slice)-2))) 
ELSE IF @Slice LIKE '{%'
SELECT @Slice = '{' + UPPER(SUBSTRING(@SLice,2,1)) + LOWER(RIGHT(@Slice,(LEN(@Slice)-2))) 
ELSE IF @Slice LIKE '%-%' AND @Slice <> '-'
BEGIN
SELECT @SubIndex = CHARINDEX('-',@Slice)
SELECT @TmpSlice1 = LEFT(@Slice,@SubIndex - 1 )
SELECT @TmpSlice2 = RIGHT(@Slice,LEN(@Slice) - @SubIndex )
SELECT @Slice = UPPER(LEFT(@TmpSlice1,1)) + LOWER(RIGHT(@TmpSlice1,(LEN(@TmpSlice1)-1))) + '-' + UPPER(LEFT(@TmpSlice2,1)) + LOWER(RIGHT(@TmpSlice2,(LEN(@TmpSlice2)-1))) 
END
ELSE IF @Slice LIKE '%&%' AND @Slice <> '&'
BEGIN
SELECT @SubIndex = CHARINDEX('&',@Slice)
SELECT @TmpSlice1 = LEFT(@Slice,@SubIndex - 1 )
SELECT @TmpSlice2 = RIGHT(@Slice,LEN(@Slice) - @SubIndex )
SELECT @Slice = UPPER(LEFT(@TmpSlice1,1)) + LOWER(RIGHT(@TmpSlice1,(LEN(@TmpSlice1)-1))) + '&' + UPPER(LEFT(@TmpSlice2,1)) + LOWER(RIGHT(@TmpSlice2,(LEN(@TmpSlice2)-1))) 
END
ELSE IF @Slice NOT LIKE '%A%' AND @Slice NOT LIKE '%E%' AND @Slice NOT LIKE '%I%' AND @Slice NOT LIKE '%O%' AND @Slice NOT LIKE '%U%' AND @Slice NOT IN ('AT','IN','ON','BY','THE','FOR','PRO','INC')
SELECT @Slice = cast(len(@slice) as varchar) + 'b' + UPPER(@SLice) 
ELSE IF RIGHT(@Slice,LEN(@Slice)-1) LIKE '+%'
SELECT @Slice = UPPER(LEFT(@Slice,1)) + '+' + UPPER(SUBSTRING(@SLice,3,1)) + LOWER(RIGHT(@Slice,(LEN(@Slice)-3))) 
ELSE IF LEN(@Slice) = 2 AND @Slice NOT IN ('AT','IN','ON','BY')
SELECT @Slice = UPPER(@SLice) 
ELSE IF LEN(@Slice) = 3 AND @Slice NOT IN ('THE','FOR','PRO','INC')
SELECT @Slice = UPPER(@SLice) 
ELSE
SELECT @SLice = UPPER(LEFT(@Slice,1)) + LOWER(RIGHT(@Slice,(LEN(@Slice)-1)))
 
-- Build NewValue            
            SELECT @NewValue = ISNULL(@NewValue + @Separator,'')  + ISNULL(REPLACE(@Slice,',',''),'')
SELECT @Separator = ' '
 
            -- CHOP THE ITEM REMOVED OFF THE MAIN STRING
            SELECT @OrigValue = RIGHT(@OrigValue,LEN(@OrigValue) - (@Index + (@DelLen-1)) )
            -- BREAK OUT IF WE ARE DONE
            IF LEN(@OrigValue) = 0 BREAK
END
 
-- Return the result of the function
SELECT @NewValue = LEFT(@NewValue,LEN(@NewValue) - LEN(@Separator))
RETURN @NewValue
 
END
GO
 
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
