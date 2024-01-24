-- Destin Harris
-- Q1: Write a query that describes the story of one row. 
SELECT * FROM divvybikes_2018 LIMIT 1;
/* Explanation
you have the bike_id which is to identify the bike
you have how long the duration of the ride was by the start_time and end_time
you have which station it was taken from and dropped off at by start_station_id and end_station_id
you have the DOB of the person by user_birth_year
*/

-- Q2: Without displaying the full table content to the output screen, count how many rows are in this table.
SELECT count(*) 
FROM divvybikes_2018;
-- 1,767,806 trips (counted by the number of rows in the table)

-- Q3: Your stakeholder needs to know how many unique ids have been assigned to the starting and ending locations? Report the discrete counted value for each. Use 1 query to create the counted values.
SELECT COUNT(DISTINCT start_station_id) AS start_locations,
COUNT(DISTINCT end_station_id) AS end_locations
FROM divvybikes_2018;
-- 315 starting stations
-- 317 ending stations
-- You observe that the two numbers are slightly different.
/* Explanations:
-- reason behind the two different number counts for each column could be due to theft or mechanical issues with station
-- we used a distinct count functin instead of just count so we wont have any repeating numbers
-- this led to us finding the issue that just been alerted what is happening with the other 2 bikes or rides
*/

-- Q4: Using the unique identifier for the bikes, learn how many bikes were deployed into the bike system in 2018?
select count(distinct bike_id) AS qty_bikes
FROM divvybikes_2018;
-- 4045 Bikes

-- Q5:Based on the summed value of dock slots reported in the stations table, what is the total max capacity that could be parked into the docks at one time?
SELECT sum(docks) as total_dock_slots
FROM divvy_stations;
-- 10434 Dock Slots reported

-- Q6: Using a math function, show the activity date range recorded in the 2018 trip table?
SELECT
min(start_time) AS first_date,
max(start_time) AS last_date
FROM divvybikes_2018;
-- First ride started at 2018-01-01 00:16:33,
-- Last recorded ride started on 2018-12-31 23:54:39.

-- Q7: How many rides were taken by each type of customer recorded?
SELECT
user_type,
COUNT(*) as qty_riders
FROM divvybikes_2018
GROUP BY user_type;
-- There are 331129 trips by customers and 1436677 by subscribers.

-- Q8: Further divide out the tally of each user type by gender.
SELECT User_type,
user_gender,
COUNT(*) as qty_riders
FROM divvybikes_2018
GROUP BY user_type,user_gender
order by User_type,user_gender;
/* Explanation
-- There are 398,394 trips by females and 1,141,735 by males
-- There are 227,677 trips didnt answer this question
-- more men ride divvy bikes in this area
-- many unknown gender are just customers instead of subscribers
*/

-- Q9: How long was the shortest and longest trip? (HINT: use TIMESTAMPDIFF function) a. Longest trip in completed weeks was
SELECT
timestampdiff(week,start_time, end_time) as duration_weeks,
timestampdiff(month,start_time, end_time) as duration_months,
timestampdiff(second,start_time, end_time) as duration_seconds,
timestampdiff(minute,start_time, end_time) as duration_minutes
FROM divvybikes_2018
ORDER BY 1 DESC
LIMIT 1;
-- The longest trip duration was: 3 months or 15 weeks 
-- Shortest trip in completed minutes was: 9328558 seconds or 155475 minutes
-- the problem with the data is that it isn't as exact as we want it 

-- Q10: Add a WHERE clause to the query above and eliminate any trips where the duration is less than zero.
SELECT
timestampdiff(week,start_time, end_time) as duration_weeks,
timestampdiff(month,start_time, end_time) as duration_months,
timestampdiff(second,start_time, end_time) as duration_seconds,
timestampdiff(minute,start_time, end_time) as duration_minutes
FROM divvybikes_2018
where timestampdiff(second,start_time, end_time)>0
ORDER BY 1 asc
LIMIT 1;
-- 277 SECONDS // 4 MINUTE

-- Q11: What are the top 8 most used starting stations based on the quantity of trips that began from each station location?
SELECT start_station_id, count(*) AS num_trips
FROM divvybikes_2018
GROUP BY start_station_id
ORDER BY num_trips desc
LIMIT 8;
-- The top 8 starting stations are 67, 80, 68, 22, 178, 190, 189 and 74

-- Q12: Place those ids’ into an IN( ) clause within a query and retrieve the station names from the station table.
SELECT id, name
FROM divvy_stations
WHERE id in(67,80,68,22,178,190,189,74);
/* Explanations
-- 178 State St & 19th St
-- 190 Southport Ave & Wrightwood Ave
-- 22 May St & Taylor St
-- 67 Sheffield Ave & Fullerton Ave
-- 68 Clinton St & Tilden St
-- 74 Kingsbury St & Erie St
-- 80 Aberdeen St & Monroe St
*/

-- Q13: What are the top 8 used end stations?
SELECT end_station_id, COUNT(*) AS total_trips
FROM divvybikes_2018
GROUP BY end_station_id
ORDER BY total_trips desc
LIMIT 8;
-- The most frequented ending stations are 67, 80, 190, 68, 22, 36, 178 and 74

-- Q14: Place those ids’ into an IN( ) clause within a query and retrieve the station names from the station table.
SELECT id, name
FROM divvy_stations
WHERE id in(67,80,68,22,178,190,36,74);
-- 178 State St & 19th St
-- 190 Southport Ave & Wrightwood Ave
-- 22 May St & Taylor St
-- 67 Sheffield Ave & Fullerton Ave
-- 68 Clinton St & Tilden St
-- 74 Kingsbury St & Erie St
-- 80 Aberdeen St & Monroe St

-- Q15: Create a query to show how many trips occurred on each day of the week.(Include the DAYNAME in the output.) Provide the functions to accomplish the query and add a comment stating the top 3 days.
SELECT
dayofweek(start_time) AS day_of_week,
dayname(start_time),
count(*) AS num_trips
FROM divvybikes_2018
GROUP BY day_of_week
ORDER BY num_trips DESC;
-- The most popular days of the week were Wednesday, Thursday, Friday

-- Q16: Create a query to show the quantity of trips started by each hour of the day. Add a comment that names the top two?
SELECT
hour(start_time) AS hour_of_day,
count(*) num_trips
FROM divvybikes_2018
GROUP BY hour_of_day
ORDER BY num_trips DESC;
-- The 17th(6pm) and 8th (9am) hours of the day is the most popular time of the day for starting rides.

-- Q17: Using a CASE statement to add the label into the data of “Weekend” or “Business Day” -- Write a query to compare weekend trips with business day trips.
SELECT
CASE
WHEN DAYOFWEEK(start_time) IN (1,7) THEN 'Weekend'
ELSE 'Business Day'
END AS day_type,
COUNT(*) AS num_trips
FROM divvybikes_2018
GROUP BY day_type;
-- 399,199 weekend trips and 1,368,607 business day trips.

-- Q18: Weekend vs Business Day Subdivision. Using the last query as a foundation, add the customer type (user_type) to the output to further divide the output.
SELECT
user_type,
CASE
WHEN DAYOFWEEK(start_time) IN (1,7) THEN 'Weekend'
ELSE 'Business Day'
END AS day_type,
COUNT(*) AS num_trips
FROM divvybikes_2018
GROUP BY user_type, day_type;
-- riders who are subscribers tend to ride bike more overall on both weekends and businessdays (260,194/1,176,483
-- while customers tend to ride mostly on business days (139,005/192,124)

-- Q19: Compare the trip start times throughout the time windows shown in the query below. Which time windows represent the high and low demand times for the overall year.
SELECT
CASE
WHEN HOUR(start_time) BETWEEN 0 AND 5 THEN 'Late Night'
WHEN HOUR(start_time) BETWEEN 6 AND 10 THEN 'Morning Commute'
WHEN HOUR(start_time) BETWEEN 11 AND 14 THEN 'Mid-Day'
WHEN HOUR(start_time) BETWEEN 15 AND 19 THEN 'Evening Commute'
ELSE 'Late Evening'
END AS time_block,
COUNT(*) AS num_trips
FROM divvybikes_2018
GROUP BY time_block;
-- The highest blocks of time is the evening and morning in which you would need more staffed
-- late evenings and nights tend to be less traffic so you can have less staffed

-- Q20: Summarize the output of the last query by first dividing the output by the type of customer taking the bike trip. (hint: add user_type)
SELECT
user_type,
CASE
WHEN HOUR(start_time) BETWEEN 0 AND 5 THEN 'Late Night'
WHEN HOUR(start_time) BETWEEN 6 AND 10 THEN 'Morning Commute'
WHEN HOUR(start_time) BETWEEN 11 AND 14 THEN 'Mid-Day'
WHEN HOUR(start_time) BETWEEN 15 AND 19 THEN 'Evening Commute'
ELSE 'Late Evening'
END AS time_block,
COUNT(*) AS num_trips
FROM divvybikes_2018
GROUP BY user_type, time_block
-- Regular customers tend to be highest in the evening totalling to 137,778 while its lowest is the late night which account for 11,200
-- subscribers who ride typically ride more throughout the day than customer in which the evening is the highest with 571,600 rides, but the late night rides are typically regular customers.
-- lowest rides for subscribers was 33,608 which was late nights

-- Analysis of Customer Participation and Engagement
/*
-- Q1: What does the data say about how and who is using the bikes?
-- A1:The people that typically uses bike are those who subscribe to the service, and arent just regular customers but frequent users
-- Q2:Based on the data observations you cited, what would you recommend for 3 operational priorities?
-- A2: The priorities is to check and inspect equipment for theft prevention and just to check.
--  second priority refers to checking and making sure stations are staffed correctly for high traffic hours
-- Third priority is figuring out how to increase the amount of subscribers
-- Q3: Given all that you’ve seen and experienced with this data, specify at least 2 Next Steps you would recommend for better analysis.
-- A3: I would go further into finding the seasons of high traffic as well as regions. the other step would be trying to figure out why people subscribe to the bikes and is it based on region
*/ 