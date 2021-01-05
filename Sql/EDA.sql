
--ok so lets start with accidents...

--How many have we had per year since 2013?
SELECT DISTINCT date_part('year', a.dateandtime), count(a.id)
from accidents a
group by date_part('year', a.dateandtime)

--What percentage of accidents were REPORTED as happening during rainy weather?
SELECT  date_part('year', a.dateandtime)
		,count(a.id) as TotalAccidents
		,s1.rainAccidents
		,ROUND(CAST((s1.rainAccidents::float/count(a.id)::float) as numeric), 2)
from accidents a
Left JOIN (
	SELECT DISTINCT date_part('year', a.dateandtime) as yeaer, count(distinct(a.id)) as rainAccidents
	from accidents a
	WHEre a.weatherdescription = 'RAIN'
	group by date_part('year', a.dateandtime)
	order by date_part('year', a.dateandtime)
)s1 ON s1.yeaer = date_part('year', a.dateandtime)
group by date_part('year', a.dateandtime), s1.rainAccidents

--how many of those were reported to have occured during storms?
Select distinct illuminationdescription 
from accidents a
--During Rain
SELECT DISTINCT date_part('year', a.dateandtime), count(a.id)
from accidents a
WHEre a.weatherdescription = 'RAIN'
group by date_part('year', a.dateandtime)
--During Rain and Fog
SELECT DISTINCT date_part('year', a.dateandtime), count(a.id)
from accidents a
WHEre a.weatherdescription = 'RAIN AND FOG'
group by date_part('year', a.dateandtime)
--During severe crosswind
SELECT DISTINCT date_part('year', a.dateandtime), count(a.id)
from accidents a
WHEre a.weatherdescription = 'SEVERE CROSSWIND'
group by date_part('year', a.dateandtime)


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

Select * From weather w
where date_trunc('day', w.dt_iso)::date = '2013-01-16'


SELECT  date_part('year', a.dateandtime)::varchar as year
		,date_part('month', a.dateandtime)::varchar as month
		,count(a.id) as TotalAccidents
		,s1.rainAccidents
		,ROUND(CAST((s1.rainAccidents::float/count(a.id)::float) as numeric), 2)
from accidents a
Left JOIN (
	SELECT DISTINCT date_part('year', a.dateandtime) as yeaer,date_part('month', a.dateandtime) as month, count(a.id) as rainAccidents
	from accidents a
	WHEre a.weatherdescription = 'RAIN'
	group by date_part('year', a.dateandtime),date_part('month', a.dateandtime)
	order by date_part('year', a.dateandtime),date_part('month', a.dateandtime)
)s1 ON s1.yeaer = date_part('year', a.dateandtime) AND s1.month = date_part('month', a.dateandtime)  
group by date_part('year', a.dateandtime),date_part('month', a.dateandtime), s1.rainAccidents
order by date_part('year', a.dateandtime),date_part('month', a.dateandtime)



















