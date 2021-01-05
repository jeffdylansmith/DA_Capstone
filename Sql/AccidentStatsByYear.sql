SELECT  date_part('year', a.dateandtime)::varchar as year
		,count(a.id) as TotalAccidents
		,f.yearlyInjuryAccidents
		,(count(a.id)/365) AccidentsPerDay
		,s1.rainyAccidents
		,s1.rainyInjuries
		,s1.rainydays 
		,(s1.rainyAccidents/s1.rainydays) accidentsPerRainDay
		,ROUND(CAST((s1.rainyAccidents::float/count(a.id)::float) as numeric), 2) rainyPercOfTotalAccidents
		,s2.snowyAccidents
		,s2.snowyDays
		,(s2.snowyAccidents/s2.snowyDays) accidentsPerSnowDay
		,ROUND(CAST((s2.snowyAccidents::float/count(a.id)::float) as numeric), 2) snowyPercOfTotalAccidents
from accidents a
Left JOIN (
	SELECT date_part('year', date_trunc('day', w.dt_iso)::date)::varchar as year 
		, count(distinct(date_trunc('day', w.dt_iso)::date)) rainydays
		, count(distinct(w.id)) rainyhours
		, count(distinct(a.id)) rainyAccidents
		, count(distinct(f.id)) as rainyInjuries
		, round(cast(AVG(w.temp) as numeric), 2) as averagetemp
	FROM weather w
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date and a.weatherdescription = 'RAIN'
	LEFT JOIN accidents f on date_trunc('day', f.dateandtime)::date = date_trunc('day', w.dt_iso)::date and f.weatherdescription = 'RAIN' and f.numberofinjuries > 0
	where date_part('year', w.dt_iso) > 2012
	AND w.rain_1h is not null and (weather_main = 'Thunderstorm' or weather_main = 'Rain')
	group by date_part('year', date_trunc('day', w.dt_iso)::date)::varchar
)s1 ON s1.year = date_part('year', a.dateandtime)::varchar
Left JOIN (
	SELECT date_part('year', date_trunc('day', w.dt_iso)::date)::varchar as year 
		, count(distinct(date_trunc('day', w.dt_iso)::date)) snowydays
		, count(distinct(w.id)) snowyhours
		, count(distinct(a.id)) snowyAccidents
		, round(cast(AVG(w.temp) as numeric), 2) as averagetemp
	FROM weather w
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date and a.weatherdescription = 'SNOW'
	where date_part('year', w.dt_iso) > 2012
	AND w.snow_1h is not null and weather_main = 'Snow'
	group by date_part('year', date_trunc('day', w.dt_iso)::date)::varchar
)s2 ON s2.year = date_part('year', a.dateandtime)::varchar
LEFT JOIN (
	select date_part('year', dateandtime)::varchar as year
		  , count(distinct(id)) as yearlyInjuryAccidents
	from accidents
	where date_part('year', dateandtime) > 2012 
	AND numberofinjuries > 0 group by date_part('year', dateandtime)
) f on f.year = date_part('year', a.dateandtime)::varchar
group by date_part('year', a.dateandtime), s1.rainyAccidents,s2.snowyAccidents,s1.rainydays , s2.snowyDays, s1.rainyInjuries, f.yearlyInjuryAccidents
order by date_part('year', a.dateandtime)

--select distinct weather_main from weather

