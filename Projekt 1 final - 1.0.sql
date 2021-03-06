CREATE TABLE t_Gustav_Galik_projekt_SQL_final AS
SELECT 
	cb.`date`,
	cb.country,
	CASE 
		WHEN (WEEKDAY(cb.`date`) in (5,6)) then 1
		WHEN (WEEKDAY(cb.`date`) in (0,1,2,3,4)) then 0
		ELSE 'Chybi_data'
		END AS '1_1_WEEKEND_indic',	
		(4 + ( CASE 
			WHEN month(cb.`date`) in (1,2,12) then 0 
			WHEN month(cb.`date`) in (3,4,5) then 1
			WHEN month(cb.`date`) in (6,7,8) then 2 
			WHEN month(cb.`date`) in (9,10,11) then 3 
			END  
		- CASE WHEN  c.north > 0 then 0
			ELSE 2
			END ) ) % 4 as '1_2_Meteo_season_by_hemi',
		/* north - rozlisovac severni a jizni polokoule, 4+ a modulo pro spravne formatovani)*/
	/*CONCAT(c.north,' ', COUNTRY) as control severu*/
	c.population_density as '2_1_Hustota_zalidneni',
	ROUND(e.gdp / e.population , 2) AS '2_2_HDP_na_obyvatele',
	eg.gini AS '2_3_GINI_koef',
	e.mortaliy_under5 AS '2_4_Detska_umrtnost',
	c.median_age_2018 AS '2_5_Median_veku_2018',
	rel.Christianity AS '2_6_Christianity' ,
	rel.Islam  AS '2_6_Islam',
	rel.Unaffiliated AS '2_6_Unaffiliated',  
	rel.Hinduism AS '2_6_Hinduism',
	rel.Buddhism AS '2_6_Buddhism',
	rel.Folk AS '2_6_Folk',
	rel.Other AS '2_6_Other',
	rel.Judaism AS '2_6_Judaism',
	lexp.rozdil_1965_2015 AS '2_7_Rozdil_v_doziti_mezi_roky_1965_a_2015',
	dayw.avg_day_temp AS '3_1_Prumerna_denni_teplota_v_°C',
	dayw.day_rain_hours AS '3_2_Pocet_hodin_deste_pres_den_v_mm',
	dayw.max_day_gust AS '3_3_Maximalni_narazovy_vitr_pres_den_v_km/h'
FROM covid19_basic_differences AS cb
LEFT JOIN countries AS c 
	ON cb.country = c.country 
LEFT JOIN (SELECT e.GDP, e.population, e.country, e.mortaliy_under5 
	FROM economies AS e 
	WHERE e.YEAR = 2019) AS e
	ON cb.country = e.country
LEFT JOIN (SELECT e.country, round(avg(e.gini),2) as gini
	FROM economies AS e 
	WHERE gini IS NOT NULL AND e.`year` >2000
	GROUP BY country) AS eg
	ON cb.country= eg.country 
LEFT JOIN (SELECT
	r.country,
	round(chr.population/p.total_population *100, 1) AS Christianity, 
	round(isl.population/p.total_population *100, 1) AS Islam,
	round(unr.population/p.total_population *100, 1) AS Unaffiliated, 
	round(hin.population/p.total_population *100, 1) AS Hinduism,
	round(bud.population/p.total_population *100, 1) AS Buddhism,
	round(fre.population/p.total_population *100, 1) AS Folk,
	round(ore.population/p.total_population *100, 1) AS Other,
	round(jud.population/p.total_population *100, 1) AS Judaism
	FROM religions AS r
	JOIN (SELECT SUM(population) AS total_population, country
		FROM religions AS r2
		WHERE `year`= 2020
		GROUP BY country, `year`
	) AS p	
		ON r.country = p.country 
		AND `year` = 2020
	JOIN (SELECT population, country
		FROM religions AS r
		WHERE `year`= 2020 AND r.religion ='Christianity'
		GROUP BY country, `year`
	) AS chr	
		ON r.country = chr.country 
	JOIN (SELECT population, country
		FROM religions AS r
		WHERE `year`= 2020 AND r.religion ='Islam'
		GROUP BY country, `year`
	) AS isl	
		ON r.country = isl.country 
	JOIN (SELECT population, country
		FROM religions AS r
		WHERE `year`= 2020 AND r.religion ='Unaffiliated Religions'
		GROUP BY country, `year`
	) AS unr	
		ON r.country = unr.country 
	JOIN (SELECT population, country
		FROM religions AS r
		WHERE `year`= 2020 AND r.religion ='Hinduism'
		GROUP BY country, `year`
	) AS hin	
		ON r.country = hin.country 
	JOIN (SELECT population, country
		FROM religions AS r
		WHERE `year`= 2020 AND r.religion ='Buddhism'
		GROUP BY country, `year`
	) AS bud	
		ON r.country = bud.country
	JOIN (SELECT population, country
		FROM religions AS r
		WHERE `year`= 2020 AND r.religion ='Folk Religions'
		GROUP BY country, `year`
	) AS fre	
		ON r.country = fre.country
	JOIN (SELECT population, country
		FROM religions AS r
		WHERE `year`= 2020 AND r.religion ='Other Religions'
		GROUP BY country, `year`
	) AS ore	
		ON r.country = ore.country
	JOIN (SELECT population, country
		FROM religions AS r
		WHERE `year`= 2020 AND r.religion ='Judaism'
		GROUP BY country, `year`
	) AS jud	
		ON r.country = jud.country
	GROUP BY r.country) AS rel
	ON rel.country = cb.country
LEFT JOIN (SELECT le2015.country, le2015.life_expectancy AS 'Doziti 2015', le1965.life_expectancy AS 'Doziti 1965', round( le2015.life_expectancy/le1965.life_expectancy,3)*100 AS 'Percentile change', round(le2015.life_expectancy-le1965.life_expectancy,2) AS rozdil_1965_2015
		FROM (SELECT * 
			FROM life_expectancy AS le
		WHERE `year` = 2015) AS le2015
	LEFT JOIN (SELECT * 
		FROM life_expectancy AS le
		WHERE `year` = 1965) AS le1965
	ON le2015.country = le1965.country
	) AS lexp
	ON lexp.country = cb.country
LEFT JOIN (
	SELECT 
		dw.date,
		dw.city, 
		avg(dw.temp_nu) AS avg_day_temp,
		SUM(CASE WHEN dw.rain_nu >0 THEN 1 ELSE 0 END)*3 AS day_rain_hours,
		max(dw.gust_nu) AS max_day_gust,
		CASE 
			WHEN dw.city = 'Athens' THEN 'Athenai'
			WHEN dw.city = 'Brussels' THEN 'Bruxelles [Brussel]'
			WHEN dw.city = 'Bucharest' THEN 'Bucuresti'
			WHEN dw.city = 'Helsinki' THEN 'Helsinki [Helsingfors]'
			WHEN dw.city = 'Kiev' THEN 'Kyiv'
			WHEN dw.city = 'Lisbon' THEN 'Lisboa'
			WHEN dw.city = 'Luxembourg' THEN 'Luxembourg [Luxemburg/L'
			WHEN dw.city = 'Prague' THEN 'Praha'
			WHEN dw.city = 'Rome' THEN 'Roma'
			WHEN dw.city = 'Vienna' THEN 'Wien'
			WHEN dw.city = 'Warsaw' THEN 'Warszawa'
			ELSE dw.city
			END AS 'city_updated'
	FROM (SELECT w.date, w.`time`, w.city, REPLACE (w.rain,' mm','') AS rain_nu, REPLACE (w.temp,' °c','') AS temp_nu, REPLACE (w.gust, ' km/h', '') AS gust_nu
		FROM weather AS w 
		WHERE w.time >= '06:00' AND w.time <= '18:00' AND city IS NOT NULL) AS dw
		GROUP BY dw.date, dw.city
	) AS dayw
	ON dayw.city_updated = c.capital_city 
	AND cb.date = dayw.date;
