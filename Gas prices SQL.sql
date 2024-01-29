USE [carsales_project];
-- Combines total vehicle registrations in Canada and average CPI
-- for gasoline, by quarter.
SELECT r.Date, r.Location, r.FuelType AS 'Fuel Type', r.Value AS 'Vehicle Registrations', cpi.Value AS 'Average CPI'
FROM [Vehicle.Registrations] AS r
RIGHT JOIN [Gasoline.AvgCPI] AS cpi ON
r.Date=cpi.Date AND
r.LocationID=cpi.LocationID
-- Edit LocationID below to pick a specific province or exclude locations.
-- The below statement filters for only locations listed as Canada
-- because it is a total value for all provinces.
-- LocationID code can be found within the other tables.
WHERE cpi.LocationID='2016A000011124' AND
r.FuelType NOT LIKE 'All fuel types' AND
r.VehicleType='Total, vehicle type';


SELECT vr.DATE, vr.VALUE, fbl.Type_of_fuel, fbl.VALUE AS Cents_per_liter 
FROM dbo.vehicleregistration AS vr 
	JOIN dbo.fuelbylocation AS fbl ON 
		vr.LOCATION_ID = fbl.LOCATION_ID 
		AND vr.DATE = fbl.DATE
WHERE vr.Fuel_type = 'Gasoline' 
	AND vr.Vehicle_type = 'Passenger cars' 
	AND vr.LOCATION = 'British Columbia and the Territories' 
	AND fbl.LOCATION = 'Vancouver, British Columbia' 
	AND NOT fbl.Type_of_fuel = 'Diesel fuel at self service filling stations' 
	AND NOT fbl.Type_of_fuel = 'Premium unleaded gasoline at self service filling stations'

USE [carsales_project];
-- Fixes and error with the locationID for NWT 
UPDATE [Fuel.SalesL] 
SET LocationID='2011A000261' 
WHERE Location='Northwest Territories';

-- Combines Litres of gasoline sold and the cents per litre, by 
-- location and date (yearly) 
SELECT s.Date, s.Location, s.Value AS 'Litres in Thousands Sold', 
regular.Value AS 'Cents per Litre'
	FROM [Fuel.SalesL] AS s 
		LEFT JOIN [Fuel.PriceRegular] AS regular ON 
		s.Date=regular.Date AND 
		s.LocationID=regular.LocationID
-- FuelType sales can be changed to: 
-- 'Gross sales of gasoline', 'Net sales of diesel oil', and
-- 'Net sales of liquified petroleum gas' 
	
WHERE s.FuelType='Net sales of gasoline' AND
-- Edit below to pick a specific province or exclude locations.
-- The below statement excludes Canada because it is a total value.
-- Nunavut has also been excluded because the cents per litre 
-- was not given.
-- LocationID codes can be found within the other tables. 
	s.LocationID NOT LIKE '2016A000011124' AND 
	s.LocationID NOT LIKE '2016A000262'
