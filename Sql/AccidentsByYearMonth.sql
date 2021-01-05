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
