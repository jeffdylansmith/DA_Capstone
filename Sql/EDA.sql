
--ok so lets start with accidents...

--How many have we had per year since 2013?
SELECT DISTINCT date_part('year', a.dateandtime), count(a.id)
from accidents a
group by date_part('year', a.dateandtime)

--What percentage of accidents were REPORTED as happening during rainy weather?
SELECT DISTINCT date_part('year', a.dateandtime),count(a.id) as TotalAccidents, s1.rainAccidents, ROUND(CAST((s1.rainAccidents::float/count(a.id)::float) as numeric), 2)
from accidents a
Left JOIN (
	SELECT DISTINCT date_part('year', a.dateandtime) as yeaer, count(a.id) as rainAccidents
	from accidents a
	WHEre a.weatherdescription = 'RAIN'
	group by date_part('year', a.dateandtime)
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




