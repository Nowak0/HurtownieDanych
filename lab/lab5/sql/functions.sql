USE Szkoła;
GO

IF OBJECT_ID('dbo.fn_peel_to_date') IS NOT NULL DROP FUNCTION dbo.fn_peel_to_date;
GO
CREATE FUNCTION dbo.fn_peel_to_date(@pesel varchar(20))
RETURNS date
AS
BEGIN
    DECLARE @y int, @m int, @d int, @century int, @yy int;
    IF @pesel IS NULL OR LEN(@pesel) < 6 RETURN NULL;

    SELECT @yy = TRY_CAST(SUBSTRING(@pesel,1,2) AS int),
           @m = TRY_CAST(SUBSTRING(@pesel,3,2) AS int),
           @d = TRY_CAST(SUBSTRING(@pesel,5,2) AS int);

    IF @yy IS NULL OR @m IS NULL OR @d IS NULL RETURN NULL;

    IF @m BETWEEN 1 AND 12 SET @century = 1900;
    ELSE IF @m BETWEEN 21 AND 32 BEGIN SET @m = @m - 20; SET @century = 2000; END
    ELSE IF @m BETWEEN 41 AND 52 BEGIN SET @m = @m - 40; SET @century = 2100; END
    ELSE IF @m BETWEEN 61 AND 72 BEGIN SET @m = @m - 60; SET @century = 2200; END
    ELSE IF @m BETWEEN 81 AND 92 BEGIN SET @m = @m - 80; SET @century = 1800; END
    ELSE RETURN NULL;

    SET @y = @century + @yy;

    RETURN TRY_CONVERT(date, CONCAT(@y,'-', FORMAT(@m,'00'), '-', FORMAT(@d,'00')));
END;
GO