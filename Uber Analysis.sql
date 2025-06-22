create database Uber;
Use Uber;

Create Table Uber_Cabs(Request_id int,
	Pickup_point varchar(50),	
    Driver_id	int,
    Status	varchar(50),
    Request_Date text,
    Request_time time,
	Drop_Date text,
	Drop_Time time,
	Day_Name	varchar(50),
    Hour	int,
    Slot varchar(50)
    );

select * from Uber_Cabs;

	--1)  Pickup_point.

	SELECT 
  Pickup_point,
  COUNT(*) AS Total_Requests
FROM Uber_Cabs
GROUP BY Pickup_point;

--2)  Status of Booking 

SELECT 
 Status,
  COUNT(*) AS Total_Requests
FROM Uber_Cabs
GROUP BY Status;

--3) Peak Booking slot

	select * from Uber_Cabs;

	SELECT 
 Slot,
  COUNT(*) AS Total_Requests
FROM Uber_Cabs
GROUP BY Slot;

--4) Peak Booking Hours

SELECT Hour, COUNT(*) AS Total_Requests
FROM Uber_Cabs
GROUP BY Hour
ORDER BY Total_Requests DESC;

--5) Most Requested Days

SELECT Day_Name, COUNT(*) AS Total_Requests
FROM Uber_Cabs
GROUP BY Day_Name
ORDER BY Total_Requests DESC;

--6) Demand Gap Between Cancelled and No Cars Available

SELECT Pickup_point, COUNT(*) AS Demand_Gap
FROM Uber_Cabs
WHERE Status IN ('Cancelled', 'No Cars Available')
GROUP BY Pickup_point
ORDER BY Demand_Gap DESC;

-- 7)Gap by Hour

SELECT Hour, COUNT(*) AS Demand_Gap
FROM Uber_Cabs
WHERE Status IN ('Cancelled', 'No Cars Available')
GROUP BY HOur
ORDER BY Demand_Gap DESC;

-- 8) Total trip by Driver

SELECT Driver_id, COUNT(*) AS Trips
FROM Uber_Cabs
WHERE Status = 'Trip Completed'
GROUP BY Driver_id
ORDER BY Trips DESC;

-- 9) Cancellation Rate by Driver:

SELECT Driver_id,
       COUNT(*) AS Total_Trips,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancellations,
       ROUND(SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Cancellation_Rate
FROM Uber_Cabs
GROUP BY Driver_id
HAVING count(*) > 10;

-- 10) Trip Completion Rate 

SELECT 
  Pickup_point, 
  ROUND(
    SUM(CASE WHEN LOWER(Status) LIKE 'trip completed' THEN 1 ELSE 0 END) / COUNT(*) * 100, 
    2
  ) AS Completion_Rate
FROM Uber_Cabs
GROUP BY Pickup_point;

select * from Uber_Cabs;

-- 11) Trip Completion Rate by Time Slot


SELECT 
  Slot,
  COUNT(*) AS Total_Requests,
  SUM(CASE WHEN LOWER(TRIM(Status)) = 'trip completed' THEN 1 ELSE 0 END) AS Completed,
  ROUND(SUM(CASE WHEN LOWER(TRIM(Status)) = 'trip completed' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Completion_Rate
FROM Uber_Cabs
GROUP BY Slot
ORDER BY Completion_Rate ASC; 

-- 12) Pickup point wise Demand vs Gaps

SELECT 
  Pickup_point,
  COUNT(*) AS Total_Requests,
  SUM(CASE WHEN LOWER(TRIM(Status)) IN ('cancelled', 'no cars available') THEN 1 ELSE 0 END) AS Demand_Gap,
  ROUND(SUM(CASE WHEN LOWER(TRIM(Status)) IN ('cancelled', 'no cars available') THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Gap_Percentage
FROM Uber_Cabs
GROUP BY Pickup_point
ORDER BY Gap_Percentage DESC;

-- 13) Hourly Demand and Gap analysis

SELECT 
  Hour,
  COUNT(*) AS Total_Requests,
  SUM(CASE WHEN LOWER(TRIM(Status)) = 'trip completed' THEN 1 ELSE 0 END) AS Completed,
  SUM(CASE WHEN LOWER(TRIM(Status)) IN ('cancelled', 'no cars available') THEN 1 ELSE 0 END) AS Gaps,
  ROUND(SUM(CASE WHEN LOWER(TRIM(Status)) IN ('cancelled', 'no cars available') THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Gap_Percentage
FROM Uber_Cabs
GROUP BY Hour
ORDER BY Hour;

--14) Day-Wise Performance

SELECT 
  Day_Name,
  COUNT(*) AS Total_Requests,
  SUM(CASE WHEN LOWER(TRIM(Status)) = 'trip completed' THEN 1 ELSE 0 END) AS Completed_Trips,
   SUM(CASE WHEN LOWER(TRIM(Status)) = 'cancelled' THEN 1 ELSE 0 END) AS Cancelled_Trips,
  ROUND(SUM(CASE WHEN LOWER(TRIM(Status)) = 'trip completed' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Completion_Rate
FROM Uber_Cabs
GROUP BY Day_Name
ORDER BY CASE Day_Name
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    ELSE 6
END;

