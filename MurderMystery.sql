-- Crime Scene Report from SQL City
select *
from crime_scene_report  
where city = 'SQL City' AND 
type = 'murder'

/*
date	type	description	city
20180215	murder	REDACTED REDACTED REDACTED	SQL City
20180215	murder	Someone killed the guard! He took an arrow to the knee!	SQL City
20180115	murder	Security footage shows that there were 2 witnesses. 
The first witness lives at the last house on "Northwestern Dr". 
The second witness, named Annabel, lives somewhere on "Franklin Ave".	
SQL City
*/

--Clues 
--1 guard was killed but suspect has arrow wound in knee
-- 2 witness
--first witness live in last house at northwestern dr
-- second witness is named annabel and lived on franklin ave. 


-- Pull up first witness
select *
from person  
where lower(address_street_name) like '%northwestern%' 
order by address_number desc
--limit 1


/*
First Witness ID
id	name	license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949
*/

select *
from interview 
where person_id = 14887


--Interview
/*I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".*/


--pull up second witness

select *
from person  
where lower(address_street_name) like '%franklin%' AND
name like '%annabel%';


/*
id	name	license_id	address_number	address_street_name	ssn
16371	Annabel Miller	490173	103	Franklin Ave	318771143
*/

select *
from interview 
where person_id = 16371


--Interview
/*I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.*/

--Check for guests on Jan 9th who have a gold member status that starts with 48Z
--From those guests check each of their plate numbers for H42W in it

select *
from get_fit_now_check_in
join get_fit_now_member ON get_fit_now_check_in.membership_id=get_fit_now_member.id
where check_in_date = 20180109 
AND check_in_time >= 1	
AND membership_status = 'gold' 
AND id like '48Z%'

/*
membership_id	check_in_date	check_in_time	check_out_time	id	person_id	name	membership_start_date	membership_status
48Z7A	20180109	1600	1730	48Z7A	28819	Joe Germuska	20160305	gold
48Z55	20180109	1530	1700	48Z55	67318	Jeremy Bowers	20160101	gold
*/

--2 suspects
-- 28819	Joe Germuska
-- 67318	Jeremy Bowers

--Look into car Plates
SELECT *
from person
WHERE name = 'Joe Germuska'

/*
id	name	license_id	address_number	address_street_name	ssn
28819	Joe Germuska	173289	111	Fisk Rd	138909730
*/
SELECT *
from drivers_license
WHERE id = 173289

/* Joe Germuska has a drivers license with id 173289 but no car plate number*/


SELECT *
from person
JOIN drivers_license ON person.license_id=drivers_license.id
WHERE name = 'Jeremy Bowers'
/*
id	name	license_id	address_number	address_street_name	ssn	id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279	423327	30	70	brown	brown	male	0H42W2	Chevrolet	Spark LS*/

--Jeremy Bowers is the killer - He has a car with a plate number that includes H42W

/*
Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.*/

--interview with killer
/*
I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/


select *
from person
JOIN facebook_event_checkin ON person.id=facebook_event_checkin.person_id
JOIN drivers_license ON person.license_id=drivers_license.id
JOIN income ON person.ssn=income.ssn

WHERE
--Female
gender = 'female'

--She has red hair 
AND lower(hair_color) = 'red'

--she drives a Tesla Model S. 
AND car_make = 'Tesla'
AND car_model = 'Model S'

--I know that she attended the SQL Symphony Concert 3 times in December 2017.
--AND column_name BETWEEN value1 AND value2;
-- she's around 5'5" (65") or 5'7" (67").
AND height between 64 AND 68 

--I was hired by a woman with a lot of money. 
ORDER BY annual_income desc


