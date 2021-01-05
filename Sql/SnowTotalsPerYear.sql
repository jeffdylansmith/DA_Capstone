SELECT date_part('year', date_trunc('day', w.dt_iso)::date)::varchar as year 
	, count(distinct(date_trunc('day', w.dt_iso)::date)) snowydays
	, count(distinct(w.id)) snowyhours
	, count(distinct(a.id))accidents
	, round(cast(AVG(w.temp) as numeric), 2) as averagetemp
FROM weather w
LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date and a.weatherdescription = 'SNOW'
where date_part('year', w.dt_iso) > 2012
AND w.snow_1h is not null and weather_main = 'Snow'
group by date_part('year', date_trunc('day', w.dt_iso)::date)::varchar
