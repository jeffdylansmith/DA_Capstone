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
LEFT JOIN (
	SELECT date_part('year', r.day)::varchar as year
		, date_part('month', a.dateandtime) as month
		, count(distinct(r.day)) rainydays
		, count(distinct(r.day)) rainyhours
		, count(distinct(a.id)) rainyAccidents
		, count(distinct(f.id)) as rainyInjuries
		, 0 as averagetemp
	FROM rainydays r
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = r.day --and a.weatherdescription = 'RAIN'
	LEFT JOIN accidents f on date_trunc('day', f.dateandtime)::date = r.day and f.numberofinjuries > 0
	where date_part('year', r.day) > 2012
	AND r.day < '2020-10-30'
	group by date_part('year', r.day)::varchar, date_part('month', a.dateandtime) 
)s1 ON s1.year = date_part('year', a.dateandtime)::varchar AND s1.month = date_part('month', a.dateandtime)  
LEFT JOIN(
	SELECT date_part('year', r.day)::varchar as year
		, date_part('month', a.dateandtime) as month
		, count(distinct(r.day)) snowydays
		, count(distinct(r.day)) snowyhours
		, count(distinct(a.id)) snowyAccidents
		, count(distinct(f.id)) as snowyInjuries
		, 0 as averagetemp
	FROM snowydays r
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = r.day --and a.weatherdescription = 'RAIN'
	LEFT JOIN accidents f on date_trunc('day', f.dateandtime)::date = r.day and f.numberofinjuries > 0
	where date_part('year', r.day) > 2012
	AND r.day < '2020-10-30'
	group by date_part('year', r.day)::varchar, date_part('month', a.dateandtime) 
)s2 ON s2.year = date_part('year', a.dateandtime)::varchar AND s2.month = date_part('month', a.dateandtime)  
LEFT JOIN (	
	SELECT date_part('year', r.day)::varchar as year
		, date_part('month', a.dateandtime) as month
		, count(distinct(r.day)) cleardays
		, count(distinct(r.day)) clearhours
		, count(distinct(a.id)) clearAccidents
		, count(distinct(f.id)) as clearInjuries
		, 0 as averagetemp
	FROM otherdays r
	LEFT JOIN accidents a on date_trunc('day', a.dateandtime)::date = r.day --and a.weatherdescription = 'RAIN'
	LEFT JOIN accidents f on date_trunc('day', f.dateandtime)::date = r.day and f.numberofinjuries > 0
	where date_part('year', r.day) > 2012
	AND r.day < '2020-10-30'
	group by date_part('year', r.day)::varchar, date_part('month', a.dateandtime) 
)s3 ON s3.year = date_part('year', a.dateandtime)::varchar AND s3.month = date_part('month', a.dateandtime)  
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









