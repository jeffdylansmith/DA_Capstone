SELECT  date_part('year', a.dateandtime)::varchar as year
		,count(a.id) as TotalAccidents
		,s1.rainAccidents
		,s2.snowAccidents
		,ROUND(CAST((s1.rainAccidents::float/count(a.id)::float) as numeric), 2)
from accidents a
Left JOIN (
	SELECT DISTINCT date_part('year', a.dateandtime) as yeaer, count(distinct(a.id)) as rainAccidents
	from accidents a
	LEFT JOIN weather w on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date
	WHEre a.weatherdescription = 'RAIN'
	group by date_part('year', a.dateandtime)
	order by date_part('year', a.dateandtime)
)s1 ON s1.yeaer = date_part('year', a.dateandtime)
Left JOIN (
	SELECT DISTINCT date_part('year', w.dt_iso) as yeaer--, count(distinct(date_trunc('day', w.dt_iso)::date)) as snowDays
	from weather w
	WHEre w.weather_main = 'SNOW'
	group by date_part('year', w.dt_iso)
	order by date_part('year', w.dt_iso)
)s2 ON s2.yeaer = date_part('year', a.dateandtime)
group by date_part('year', a.dateandtime), s1.rainAccidents
order by date_part('year', a.dateandtime)

	   
FROM weather w
LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date
where date_part('year', w.dt_iso) > 2012
AND w.rain_1h is not null and (weather_main = 'Thunderstorm' or weather_main = 'Rain')
group by date_part('year', w.dt_iso)
ORDER BY date_part('year', w.dt_iso)

select distinct weather_main from weather 
