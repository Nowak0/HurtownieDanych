USE Szkola;
GO

IF NOT EXISTS (SELECT 1 FROM DimJunk)
BEGIN
    DECLARE @grades TABLE (grade int);
    INSERT INTO @grades (grade) VALUES (1),(2),(3),(4),(5),(6);

    DECLARE @attendances TABLE (att varchar(10));
    INSERT INTO @attendances (att) VALUES ('0-49'),('50-69'),('70-89'),('90-100');

    DECLARE @exams TABLE (exam bit);
    INSERT INTO @exams (exam) VALUES (0),(1), (NULL);

    INSERT INTO DimJunk (Ocena, Frekwencja, Czy_zdany_przedmiot, Czy_zdana_matura)
    SELECT 
        g.grade,
        a. att,
        CASE WHEN g.grade = 1 OR a.att = '0-49' THEN 0 ELSE 1 END AS Czy_zdany_przedmiot,
        e.exam
    FROM @grades g
    CROSS JOIN @attendances a
    CROSS JOIN @exams e;

END
GO