	SELECT date_part('year', date_trunc('day', w.dt_iso)::date)::varchar as year
		,date_part('month', a.dateandtime) as month
		, count(distinct(date_trunc('day', w.dt_iso)::date)) cleardays
		, count(distinct(w.id)) clearhours
		, count(distinct(a.id)) clearAccidents
		, count(distinct(f.id)) as clearInjuries
		, round(cast(AVG(w.temp) as numeric), 2) as averagetemp
	FROM weather w
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date and a.weatherdescription = 'RAIN'
	LEFT JOIN accidents f on date_trunc('day', f.dateandtime)::date = date_trunc('day', w.dt_iso)::date and f.weatherdescription = 'RAIN' and f.numberofinjuries > 0
	where date_part('year', w.dt_iso) > 2012
	AND w.rain_1h is null and (weather_main = 'Clear' or weather_main = 'Clouds')
	group by date_part('year', date_trunc('day', w.dt_iso)::date)::varchar, date_part('month', a.dateandtime) 
	
Select w.dt_iso
	   ,w.weather_main
       ,date_part('year', date_trunc('day', w.dt_iso)::date)::varchar as year
	   ,date_part('month', w.dt_iso) as month
FROM weather w
where date_part('year', w.dt_iso) > 2012
AND (weather_main = 'Clear' or weather_main = 'Clouds')
order by w.dt_iso
	
