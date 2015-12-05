USE [StPoly]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GIS_ConvertSQLFormatPolygonString]    Script Date: 02/15/2013 13:39:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[fn_GIS_ConvertSQLFormatPolygonString] (@list nvarchar(MAX))
	RETURNS nvarchar(max)
	WITH SCHEMABINDING
BEGIN
DECLARE @pos        int,
        @nextpos    int,
        @voidExtr	int,
        @cont		int = 0,
        @strExtr	nvarchar(100),
        @strFirst	nvarchar(100),
        @newlist	nvarchar(max) = ''

	SET @list = replace(@list, ', ', ' ')
	SET @pos = 0 
	SET @nextpos = 1
	IF LEN(@list)=0 RETURN @list
	WHILE @nextpos > 0
	BEGIN
		SET @nextpos = charindex(',', @list, @pos + 1)
		IF @nextpos = 0
			SET @strExtr = substring(@list, @pos, LEN(@list) - @pos + 1)
		ELSE
			SET @strExtr = substring(@list, @pos, @nextpos - @pos)
		SET @pos = @nextpos + 1
		SET @voidExtr = charindex(' ', @strExtr)
		IF @cont = 0
			SET @strFirst = '(' + substring(@strExtr, @voidExtr +1, len(@strExtr) - @voidExtr-1) + ' ' + substring(@strExtr, 2, @voidExtr-2) + ')'
		SET @strExtr = '(' + substring(@strExtr, @voidExtr +1, len(@strExtr) - @voidExtr-1) + ' ' + substring(@strExtr, 2, @voidExtr-2) + ')'
		SET @newlist = @newlist + ',' + @strExtr
		SET @cont = @cont + 1
	END
	SET @newlist = @newlist + ',' + @strFirst
	SET @newlist = substring(@newlist,2,LEN(@newlist))
	SET @newlist = replace(@newlist, '),(', ', ')
	RETURN @newlist
END

GO
