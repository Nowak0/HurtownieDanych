USE Szkola;
GO


INSERT INTO FactKoniecRoku (
    ID_Ucznia,
    ID_Klasy,
    ID_Przedmiotu,
    ID_Roku_szkolnego,
    ID_Daty_matury,
    ID_Junk,
    Ocena_z_przedmiotu,
    Frekwencja,
    Wynik_z_matury
)
SELECT
    du.ID_Ucznia,
    dk.ID_Klasy,
    dp.ID_Przedmiotu,
    dd.ID_Daty AS ID_Roku_szkolnego,
    ddm.ID_Daty AS ID_Daty_matury,
    dj.ID_Junk,
    kr.Ocena,
    kr.Frekwencja,
    w.Wynik
FROM stg_koniec_roku kr

JOIN stg_uczen_w_klasie uw 
    ON kr.ID_Ucznia_w_klasie = uw.ID_Ucznia_w_klasie

JOIN DimUczen du 
    ON uw.Pesel = du.Pesel 
    AND du.IsCurrent = 1

JOIN stg_klasa k
    ON REPLACE(REPLACE(uw.Nazwa_klasy, CHAR(13), ''), CHAR(10), '') 
       = REPLACE(REPLACE(k.Nazwa_klasy, CHAR(13), ''), CHAR(10), '')

JOIN DimKlasa dk 
    ON REPLACE(REPLACE(uw.Nazwa_klasy, CHAR(13), ''), CHAR(10), '') 
       = REPLACE(REPLACE(dk.Nazwa, CHAR(13), ''), CHAR(10), '')
    AND dk.EndDate IS NULL

JOIN DimDate dd
    ON dd.DataDate = CAST(k.Rok_szkolny as date)

JOIN DimPrzedmiot dp 
    ON kr.ID_Przedmiotu = dp.SourceSubjectID

LEFT JOIN stg_wyniki w 
    ON LTRIM(RTRIM(uw. Pesel)) = LTRIM(RTRIM(w. Pesel))
    AND REPLACE(REPLACE(LTRIM(RTRIM(dp.Nazwa)), CHAR(13), ''), CHAR(10), '')
       = REPLACE(REPLACE(LTRIM(RTRIM(w.Przedmiot)), CHAR(13), ''), CHAR(10), '')

LEFT JOIN DimDate ddm 
    ON ddm.DataDate = CAST(w.Data_matury as date)

LEFT JOIN DimJunk dj 
    ON dj.Ocena = kr.Ocena
    AND dj.Frekwencja =
        CASE 
            WHEN kr.Frekwencja BETWEEN 0 AND 49 THEN '0-49'
            WHEN kr.Frekwencja BETWEEN 50 AND 69 THEN '50-69'
            WHEN kr.Frekwencja BETWEEN 70 AND 89 THEN '70-89'
            WHEN kr.Frekwencja BETWEEN 90 AND 100 THEN '90-100'
        END
    AND dj.Czy_zdany_przedmiot =
        CASE 
            WHEN kr.Ocena = 1 or kr.Frekwencja < 50 THEN 0
            ELSE 1
        END
    AND (
        (w.Wynik IS NULL AND dj.Czy_zdana_matura IS NULL)
        OR
        (w.Wynik <= 30 AND dj. Czy_zdana_matura = 0)
        OR
        (w.Wynik > 30 AND dj.Czy_zdana_matura = 1)
    )

LEFT JOIN FactKoniecRoku f
    ON f.ID_Ucznia          = du.ID_Ucznia
   AND f.ID_Klasy           = dk.ID_Klasy
   AND f.ID_Przedmiotu      = dp.ID_Przedmiotu
   AND f.ID_Roku_szkolnego  = dd.ID_Daty
   AND (
        (ddm.ID_Daty IS NULL AND f.ID_Daty_matury IS NULL)
        OR
        (ddm.ID_Daty = f.ID_Daty_matury)
       )
   AND f.ID_Junk = dj.ID_Junk

WHERE f.ID_Ucznia IS NULL;
GO