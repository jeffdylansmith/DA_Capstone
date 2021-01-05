SELECT distinct(date_trunc('day', w.dt_iso)::date) as date
	, date_part('year', date_trunc('day', w.dt_iso)::date) as year 
	, count(distinct(w.id)) rainyhours
	, count(distinct(a.id))accidents
	, round(cast(AVG(w.temp) as numeric), 2) as averagetemp
FROM weather w
LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date
where date_part('year', w.dt_iso) > 2012
AND w.rain_1h is not null and weather_main = 'Rain'
group by date_trunc('day', w.dt_iso)::date
ORDER BY date_trunc('day', w.dt_iso)::date