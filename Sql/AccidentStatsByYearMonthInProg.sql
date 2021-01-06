SELECT  date_part('year', a.dateandtime)::varchar as year
		,date_part('month', a.dateandtime)::varchar as month
		,count(distinct a.id) as TotalAccidents
		,f.yearlyInjuryAccidents
		,(count(a.id)/365) AccidentsPerDay
	 	,s3.clearAccidents
		,s3.clearInjuries
		,s3.cleardays 
		,(s3.clearAccidents/s3.cleardays) accidentsPerClearDay
		,s1.rainyAccidents
		,s1.rainyInjuries
		,s1.rainydays 
		,(s1.rainyAccidents/s1.rainydays) accidentsPerRainDay
		,ROUND(CAST((s1.rainyAccidents::float/count(a.id)::float) as numeric), 2) rainyPercOfTotalAccidents
		,s2.snowyAccidents
		,s2.snowyInjuries
		,s2.snowyDays
		,(s2.snowyAccidents/s2.snowyDays) accidentsPerSnowDay
		,ROUND(CAST((s2.snowyAccidents::float/count(a.id)::float) as numeric), 2) snowyPercOfTotalAccidents
from accidents a
Left JOIN (
	SELECT date_part('year', date_trunc('day', w.dt_iso)::date)::varchar as year
		,date_part('month', a.dateandtime) as month
		, count(distinct(date_trunc('day', w.dt_iso)::date)) rainydays
		, count(distinct(w.id)) rainyhours
		, count(distinct(a.id)) rainyAccidents
		, count(distinct(f.id)) as rainyInjuries
		, round(cast(AVG(w.temp) as numeric), 2) as averagetemp
	FROM weather w
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date --and a.weatherdescription = 'RAIN'
	LEFT JOIN accidents f on date_trunc('day', f.dateandtime)::date = date_trunc('day', w.dt_iso)::date  and f.numberofinjuries > 0
	where date_part('year', w.dt_iso) > 2012
	AND date_trunc('day', w.dt_iso)::date < '2020-10-30'
	AND (weather_main = 'Rain')
	group by date_part('year', date_trunc('day', w.dt_iso)::date)::varchar, date_part('month', a.dateandtime) 
)s1 ON s1.year = date_part('year', a.dateandtime)::varchar AND s1.month = date_part('month', a.dateandtime)  
Left JOIN (
	SELECT date_part('year', date_trunc('day', w.dt_iso)::date)::varchar as year 
		, date_part('month', a.dateandtime) as month
		, count(distinct(date_trunc('day', w.dt_iso)::date)) snowydays
		, count(distinct(w.id)) snowyhours
		, count(distinct(a.id)) snowyAccidents
		, count(distinct(f.id)) as snowyInjuries
		, round(cast(AVG(w.temp) as numeric), 2) as averagetemp
	FROM weather w
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date --and a.weatherdescription = 'SNOW'
	LEFT JOIN accidents f on date_trunc('day', f.dateandtime)::date = date_trunc('day', w.dt_iso)::date and f.numberofinjuries > 0
	where date_part('year', w.dt_iso) > 2012
	AND date_trunc('day', w.dt_iso)::date < '2020-10-30'
	AND w.weather_main = 'Snow'
	group by date_part('year', date_trunc('day', w.dt_iso)::date)::varchar, date_part('month', a.dateandtime)
)s2 ON s2.year = date_part('year', a.dateandtime)::varchar AND s2.month = date_part('month', a.dateandtime)  
LEFT JOIN (	
	Select distinct date_part('year', date_trunc('day', w.dt_iso)::date)::varchar as year
		,date_part('month', a.dateandtime) as month
		, count(distinct(date_trunc('day', w.dt_iso)::date)) cleardays
		, count(distinct(w.id)) clearhours
		, count(distinct(a.id)) clearAccidents
		, count(distinct(f.id)) as clearInjuries
		, round(cast(AVG(w.temp) as numeric), 2) as averagetemp
FRom weather w	
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = date_trunc('day', w.dt_iso)::date 
	LEFT JOIN accidents f on date_trunc('day', f.dateandtime)::date = date_trunc('day', w.dt_iso)::date and f.numberofinjuries > 0
where date_trunc('day', w.dt_iso)::date not in (
	SELECT distinct date_trunc('day', w.dt_iso)::date as date
	FROM weather w
	WHERE date_part('year', w.dt_iso) > 2012	
	AND ((w.weather_main = 'Rain') 
    Or (w.weather_main = 'Snow'))		
	GROUP BY w.dt_iso
	order by date_trunc('day', w.dt_iso)::date
	)
and date_part('year', w.dt_iso) > 2012	
group by date_part('year', date_trunc('day', w.dt_iso)::date)::varchar, date_part('month', a.dateandtime) 
) s3 ON s3.year = date_part('year', a.dateandtime)::varchar AND s3.month = date_part('month', a.dateandtime)  
LEFT JOIN (
	select date_part('year', dateandtime)::varchar as year
			,date_part('month', dateandtime) as month
		   , count(distinct(id)) as yearlyInjuryAccidents
	from accidents
	where date_part('year', dateandtime) > 2012 
	AND numberofinjuries > 0 group by date_part('year', dateandtime),date_part('month', dateandtime)
) f on f.year = date_part('year', a.dateandtime)::varchar AND f.month = date_part('month', a.dateandtime)  
WHERE date_part('year', a.dateandtime) > 2012  
AND date_trunc('day', a.dateandtime)::date < '2020-10-30'
group by date_part('year', a.dateandtime),date_part('month', a.dateandtime), s1.rainyAccidents,s2.snowyAccidents,s1.rainydays , s2.snowyDays, s1.rainyInjuries,s2.snowyInjuries, f.yearlyInjuryAccidents, s3.clearAccidents, s3.clearInjuries, s3.clearDays
order by date_part('year', a.dateandtime)

