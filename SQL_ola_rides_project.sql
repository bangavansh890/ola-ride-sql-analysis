CREATE DATABASE ola_ride;
USE ola_ride;

CREATE TABLE cities (
city_id   INT PRIMARY KEY,
city_name VARCHAR(50) NOT NULL
);

CREATE TABLE locations (
location_id   INT PRIMARY KEY,
city_id       INT NOT NULL,
location_name VARCHAR(100) NOT NULL,
FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

CREATE TABLE customers (
customer_id   INT PRIMARY KEY,
customer_name VARCHAR(100) NOT NULL,
gender        VARCHAR(10),
age           INT,
city_id       INT,
signup_date   DATE,
FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

CREATE TABLE drivers (
driver_id           INT PRIMARY KEY,
driver_name         VARCHAR(100) NOT NULL,
rating              DECIMAL(2,1),
city_id             INT,
joining_date        DATE,
availability_status VARCHAR(20),
FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

CREATE TABLE vehicle_type (
vehicle_type_id INT PRIMARY KEY,
vehicle_type    VARCHAR(30) NOT NULL,
base_fare       DECIMAL(8,2),
per_km_rate     DECIMAL(8,2)
);

CREATE TABLE vehicle (
vehicle_id      INT PRIMARY KEY,
driver_id       INT,
vehicle_type_id INT,
registration_no VARCHAR(20) UNIQUE,
vehicle_model   VARCHAR(50),
vehicle_status  VARCHAR(20),
FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_type(vehicle_type_id)
);

CREATE TABLE coupons (
coupon_id        INT PRIMARY KEY,
coupon_code      VARCHAR(30) UNIQUE NOT NULL,
discount_percent DECIMAL(5,2) NOT NULL,
min_ride_amount  DECIMAL(8,2),
coupon_status    VARCHAR(20) NOT NULL
);

CREATE TABLE rides (
ride_id            INT PRIMARY KEY,
customer_id        INT NOT NULL,
driver_id          INT,              -- NULL when no driver was assigned (cancelled)
vehicle_id         INT,
city_id            INT NOT NULL,
pickup_location_id INT NOT NULL,
drop_location_id   INT NOT NULL,
ride_date          DATETIME NOT NULL,
distance_km        DECIMAL(7,2),
fare               DECIMAL(10,2),    -- fare before discount
coupon_id          INT,
discount_amount    DECIMAL(10,2) DEFAULT 0,
ride_status        VARCHAR(20),      -- Completed / Cancelled
FOREIGN KEY (customer_id)        REFERENCES customers(customer_id),
FOREIGN KEY (driver_id)          REFERENCES drivers(driver_id),
FOREIGN KEY (vehicle_id)         REFERENCES vehicle(vehicle_id),
FOREIGN KEY (city_id)            REFERENCES cities(city_id),
FOREIGN KEY (pickup_location_id) REFERENCES locations(location_id),
FOREIGN KEY (drop_location_id)   REFERENCES locations(location_id),
FOREIGN KEY (coupon_id)          REFERENCES coupons(coupon_id),
CHECK (pickup_location_id <> drop_location_id)
);

CREATE TABLE payment_methods (
payment_method_id INT PRIMARY KEY,
method_name       VARCHAR(30) NOT NULL
);

CREATE TABLE payments (
payment_id        INT PRIMARY KEY,
ride_id           INT NOT NULL,
payment_method_id INT NOT NULL,
amount            DECIMAL(10,2),     -- fare - discount_amount
payment_date      DATE,
payment_status    VARCHAR(20),       -- Successful / Failed
FOREIGN KEY (ride_id) REFERENCES rides(ride_id),
FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id)
);

CREATE TABLE ratings_reviews (
review_id   INT PRIMARY KEY,
ride_id     INT NOT NULL,
customer_id INT NOT NULL,
driver_id   INT NOT NULL,
rating      INT NOT NULL,
review_text VARCHAR(255),
review_date DATE,
FOREIGN KEY (ride_id)     REFERENCES rides(ride_id),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (driver_id)   REFERENCES drivers(driver_id),
CHECK (rating BETWEEN 1 AND 5)
);

USE ola_ride;

INSERT INTO cities VALUES
(1,'Delhi'),(2,'Mumbai'),(3,'Bengaluru'),(4,'Hyderabad'),(5,'Pune');

INSERT INTO locations VALUES
(1,1,'Connaught Place'),(2,1,'Saket'),(3,1,'Rohini'),(4,1,'Dwarka'),(5,1,'Karol Bagh'),
(6,2,'Andheri'),(7,2,'Bandra'),(8,2,'Powai'),(9,2,'Dadar'),(10,2,'Colaba'),
(11,3,'Whitefield'),(12,3,'Indiranagar'),(13,3,'Electronic City'),(14,3,'Koramangala'),(15,3,'Hebbal'),
(16,4,'Hitech City'),(17,4,'Gachibowli'),(18,4,'Secunderabad'),(19,4,'Banjara Hills'),(20,4,'Madhapur'),
(21,5,'Hinjewadi'),(22,5,'Kothrud'),(23,5,'Viman Nagar'),(24,5,'Hadapsar'),(25,5,'Shivaji Nagar');

INSERT INTO customers VALUES
(1,'Aarav Sharma','Male',25,1,'2026-01-05'),
(2,'Ananya Verma','Female',23,2,'2026-01-08'),
(3,'Rohan Mehta','Male',29,3,'2026-01-12'),
(4,'Priya Singh','Female',26,4,'2026-01-15'),
(5,'Arjun Gupta','Male',31,5,'2026-01-20'),
(6,'Neha Kapoor','Female',24,1,'2026-02-01'),
(7,'Rahul Malhotra','Male',28,2,'2026-02-04'),
(8,'Isha Patel','Female',22,3,'2026-02-09'),
(9,'Karan Arora','Male',30,4,'2026-02-13'),
(10,'Meera Joshi','Female',27,5,'2026-02-18'),
(11,'Aditya Rao','Male',26,1,'2026-03-01'),
(12,'Simran Kaur','Female',25,2,'2026-03-05'),
(13,'Vikram Nair','Male',32,3,'2026-03-09'),
(14,'Pooja Das','Female',28,4,'2026-03-14'),
(15,'Aman Jain','Male',24,5,'2026-03-18'),
(16,'Riya Khanna','Female',23,1,'2026-04-02'),
(17,'Mohit Saini','Male',29,2,'2026-04-07'),
(18,'Kavya Iyer','Female',27,3,'2026-04-11'),
(19,'Sahil Bansal','Male',31,4,'2026-04-16'),
(20,'Tanya Roy','Female',26,5,'2026-04-21');

INSERT INTO drivers VALUES
(101,'Deepak Kumar',4.8,1,'2025-01-10','Available'),
(102,'Suresh Yadav',4.6,2,'2025-02-15','Available'),
(103,'Manoj Reddy',4.7,3,'2025-03-20','Busy'),
(104,'Rajesh Verma',4.5,4,'2025-04-05','Available'),
(105,'Amit Patil',4.9,5,'2025-05-12','Available'),
(106,'Sunil Sharma',4.4,1,'2025-06-18','Busy'),
(107,'Nitin Shah',4.7,2,'2025-07-22','Available'),
(108,'Prakash Rao',4.6,3,'2025-08-09','Available'),
(109,'Vivek Singh',4.8,4,'2025-09-14','Busy'),
(110,'Ramesh Joshi',4.5,5,'2025-10-25','Available');

INSERT INTO vehicle_type VALUES
(1,'Auto',30.00,10.00),
(2,'Mini',50.00,12.00),
(3,'Sedan',80.00,15.00),
(4,'SUV',120.00,20.00);

INSERT INTO vehicle VALUES
(1,101,2,'DL01AB1001','Maruti WagonR','Active'),
(2,102,3,'MH02CD1002','Honda Amaze','Active'),
(3,103,1,'KA03EF1003','Bajaj Auto','Active'),
(4,104,4,'TS04GH1004','Mahindra XUV','Active'),
(5,105,2,'MH12JK1005','Maruti Swift','Active'),
(6,106,3,'DL06LM1006','Honda City','Active'),
(7,107,1,'MH07NP1007','Bajaj Auto','Active'),
(8,108,4,'KA08QR1008','Hyundai Creta','Active'),
(9,109,2,'TS09ST1009','Maruti WagonR','Active'),
(10,110,3,'MH10UV1010','Honda Amaze','Active');

INSERT INTO coupons VALUES
(1,'OLA10',10.00,100.00,'Active'),
(2,'OLA20',20.00,200.00,'Active'),
(3,'FIRST50',50.00,150.00,'Active'),
(4,'RIDE15',15.00,100.00,'Active'),
(5,'WEEKEND25',25.00,250.00,'Inactive');

INSERT INTO payment_methods VALUES
(1,'UPI'),(2,'Credit Card'),(3,'Debit Card'),(4,'Cash'),(5,'Wallet');

-- ride_id, customer, driver, vehicle, city, pickup, drop, date, km, fare, coupon, discount, status
INSERT INTO rides VALUES
-- Delhi
(1001,1, 101,1, 1,1,2,'2026-06-02 09:15:00',14.50,224.00,NULL,0.00,'Completed'),
(1002,6, 106,6, 1,3,1,'2026-06-10 18:40:00',18.00,350.00,NULL,0.00,'Completed'),
(1003,11,101,1, 1,2,4,'2026-06-21 08:30:00',22.00,314.00,1,31.40,'Completed'),
(1004,16,106,6, 1,5,3,'2026-07-04 21:10:00', 9.50,222.50,NULL,0.00,'Completed'),
(1005,1, 101,1, 1,4,1,'2026-07-18 19:05:00',16.00,242.00,4,36.30,'Completed'),
(1006,6, NULL,NULL,1,2,5,'2026-08-02 07:50:00', 0.00,  0.00,NULL,0.00,'Cancelled'),
(1007,11,106,6, 1,1,5,'2026-08-15 17:20:00', 6.00,170.00,NULL,0.00,'Completed'),
(1008,16,101,1, 1,3,2,'2026-09-05 10:45:00',25.50,356.00,2,71.20,'Completed'),
-- Mumbai
(1009,2, 102,2, 2,6,7,'2026-06-03 10:00:00', 8.00,200.00,3,100.00,'Completed'),
(1010,7, 107,7, 2,8,6,'2026-06-14 13:25:00',11.00,140.00,NULL,0.00,'Completed'),
(1011,12,102,2, 2,9,10,'2026-06-28 20:15:00', 7.50,192.50,NULL,0.00,'Completed'),
(1012,17,107,7, 2,6,8,'2026-07-09 08:40:00',12.00,150.00,1,15.00,'Completed'),
(1013,2, 102,2, 2,7,9,'2026-07-23 22:05:00',10.00,230.00,NULL,0.00,'Completed'),
(1014,7, NULL,NULL,2,10,6,'2026-08-06 09:30:00', 0.00,  0.00,NULL,0.00,'Cancelled'),
(1015,12,107,7, 2,9,7,'2026-08-19 18:55:00', 5.00, 80.00,NULL,0.00,'Completed'),
(1016,17,102,2, 2,8,10,'2026-09-10 19:30:00',19.00,365.00,2,73.00,'Completed'),
-- Bengaluru
(1017,3, 103,3, 3,11,12,'2026-06-05 09:20:00',15.00,180.00,NULL,0.00,'Completed'),
(1018,8, 108,8, 3,13,14,'2026-06-17 19:45:00',12.50,370.00,NULL,0.00,'Completed'),
(1019,13,103,3, 3,12,15,'2026-06-30 08:10:00',10.00,130.00,NULL,0.00,'Completed'),
(1020,18,108,8, 3,14,11,'2026-07-12 21:30:00',20.00,520.00,2,104.00,'Completed'),
(1021,3, 103,3, 3,15,13,'2026-07-26 17:00:00',18.00,210.00,NULL,0.00,'Completed'),
(1022,8, NULL,NULL,3,11,14,'2026-08-09 10:15:00', 0.00,  0.00,NULL,0.00,'Cancelled'),
(1023,13,108,8, 3,12,13,'2026-08-22 20:40:00',14.00,400.00,NULL,0.00,'Completed'),
(1024,18,103,3, 3,14,12,'2026-09-14 08:55:00', 6.00, 90.00,NULL,0.00,'Completed'),
-- Hyderabad
(1025,4, 104,4, 4,16,17,'2026-06-07 11:00:00', 9.00,300.00,NULL,0.00,'Completed'),
(1026,9, 109,9, 4,18,19,'2026-06-19 18:10:00',13.00,206.00,NULL,0.00,'Completed'),
(1027,14,104,4, 4,20,16,'2026-07-01 09:50:00', 7.00,260.00,4,39.00,'Completed'),
(1028,19,109,9, 4,17,18,'2026-07-15 20:20:00',16.50,248.00,NULL,0.00,'Completed'),
(1029,4, 104,4, 4,19,20,'2026-07-29 07:35:00',11.50,350.00,NULL,0.00,'Completed'),
(1030,9, NULL,NULL,4,16,18,'2026-08-12 14:00:00', 0.00,  0.00,NULL,0.00,'Cancelled'),
(1031,14,109,9, 4,18,16,'2026-08-25 19:15:00',21.00,302.00,2,60.40,'Completed'),
(1032,19,104,4, 4,17,20,'2026-09-18 21:45:00', 8.00,280.00,NULL,0.00,'Completed'),
-- Pune
(1033,5, 105,5, 5,21,22,'2026-06-09 08:25:00',17.00,254.00,NULL,0.00,'Completed'),
(1034,10,110,10,5,23,24,'2026-06-24 17:35:00', 6.50,177.50,NULL,0.00,'Completed'),
(1035,15,105,5, 5,25,21,'2026-07-07 10:30:00',19.50,284.00,1,28.40,'Completed'),
(1036,20,110,10,5,22,23,'2026-07-21 20:50:00',12.00,260.00,NULL,0.00,'Completed'),
(1037,5, 105,5, 5,24,25,'2026-08-04 09:05:00', 5.50,116.00,NULL,0.00,'Completed'),
(1038,10,NULL,NULL,5,21,24,'2026-08-17 18:25:00', 0.00,  0.00,NULL,0.00,'Cancelled'),
(1039,15,110,10,5,23,22,'2026-09-02 19:00:00',15.00,305.00,4,45.75,'Completed'),
(1040,20,105,5, 5,25,23,'2026-09-21 11:20:00',10.50,176.00,NULL,0.00,'Completed');

-- Payments only exist for completed rides. amount = fare - discount
INSERT INTO payments VALUES
(1,1001,1,224.00,'2026-06-02','Successful'),
(2,1002,2,350.00,'2026-06-10','Successful'),
(3,1003,1,282.60,'2026-06-21','Successful'),
(4,1004,4,222.50,'2026-07-04','Successful'),
(5,1005,1,205.70,'2026-07-18','Successful'),
(6,1007,5,170.00,'2026-08-15','Successful'),
(7,1008,3,284.80,'2026-09-05','Successful'),
(8,1009,1,100.00,'2026-06-03','Successful'),
(9,1010,1,140.00,'2026-06-14','Failed'),
(10,1011,4,192.50,'2026-06-28','Successful'),
(11,1012,1,135.00,'2026-07-09','Successful'),
(12,1013,2,230.00,'2026-07-23','Successful'),
(13,1015,4, 80.00,'2026-08-19','Successful'),
(14,1016,1,292.00,'2026-09-10','Successful'),
(15,1017,1,180.00,'2026-06-05','Successful'),
(16,1018,2,370.00,'2026-06-17','Successful'),
(17,1019,3,130.00,'2026-06-30','Successful'),
(18,1020,1,416.00,'2026-07-12','Successful'),
(19,1021,4,210.00,'2026-07-26','Successful'),
(20,1023,5,400.00,'2026-08-22','Successful'),
(21,1024,1, 90.00,'2026-09-14','Successful'),
(22,1025,2,300.00,'2026-06-07','Successful'),
(23,1026,1,206.00,'2026-06-19','Successful'),
(24,1027,1,221.00,'2026-07-01','Successful'),
(25,1028,1,248.00,'2026-07-15','Failed'),
(26,1029,3,350.00,'2026-07-29','Successful'),
(27,1031,5,241.60,'2026-08-25','Successful'),
(28,1032,1,280.00,'2026-09-18','Successful'),
(29,1033,4,254.00,'2026-06-09','Successful'),
(30,1034,1,177.50,'2026-06-24','Successful'),
(31,1035,2,255.60,'2026-07-07','Successful'),
(32,1036,1,260.00,'2026-07-21','Successful'),
(33,1037,4,116.00,'2026-08-04','Successful'),
(34,1039,3,259.25,'2026-09-02','Successful'),
(35,1040,1,176.00,'2026-09-21','Successful');

-- Reviews for some completed rides
INSERT INTO ratings_reviews VALUES
(1, 1001,1, 101,5,'Excellent service','2026-06-02'),
(2, 1002,6, 106,4,'Good ride experience','2026-06-10'),
(3, 1003,11,101,5,'Very polite driver','2026-06-21'),
(4, 1004,16,106,3,'Average, a bit late','2026-07-04'),
(5, 1005,1, 101,4,'Comfortable journey','2026-07-18'),
(6, 1007,11,106,4,'Smooth ride','2026-08-15'),
(7, 1008,16,101,5,'Excellent service','2026-09-05'),
(8, 1009,2, 102,5,'Great experience','2026-06-03'),
(9, 1011,12,102,4,'Good ride experience','2026-06-28'),
(10,1013,2, 102,3,'Took a longer route','2026-07-23'),
(11,1016,17,102,4,'Comfortable journey','2026-09-10'),
(12,1017,3, 103,5,'Excellent service','2026-06-05'),
(13,1018,8, 108,4,'Clean car','2026-06-17'),
(14,1020,18,108,2,'Driver was rude','2026-07-12'),
(15,1021,3, 103,5,'Polite driver','2026-07-26'),
(16,1023,13,108,4,'Good ride experience','2026-08-22'),
(17,1025,4, 104,5,'Excellent service','2026-06-07'),
(18,1026,9, 109,4,'Comfortable journey','2026-06-19'),
(19,1028,19,109,3,'Average experience','2026-07-15'),
(20,1029,4, 104,5,'Very smooth ride','2026-07-29'),
(21,1032,19,104,4,'Good ride experience','2026-09-18'),
(22,1033,5, 105,5,'Excellent service','2026-06-09'),
(23,1034,10,110,4,'Polite driver','2026-06-24'),
(24,1036,20,110,3,'Okay ride','2026-07-21'),
(25,1039,15,110,5,'Comfortable journey','2026-09-02');

USE ola_ride;

SELECT * FROM customers;

SELECT customer_name, age, city_id
FROM customers
WHERE age > 28;

SELECT ride_id, distance_km, fare
FROM rides
WHERE ride_status = 'Completed' AND fare > 300
ORDER BY fare DESC;

SELECT ride_id, fare
FROM rides
ORDER BY fare DESC
LIMIT 5;

SELECT driver_name, rating, city_id
FROM drivers
WHERE rating >= 4.7;

SELECT COUNT(*) AS total_rides
FROM rides;

SELECT
    COUNT(*)  AS completed_rides,
    SUM(fare) AS total_revenue,
    AVG(fare) AS average_fare,
    MAX(fare) AS highest_fare,
    MIN(fare) AS lowest_fare
FROM rides
WHERE ride_status = 'Completed';

SELECT COUNT(*) AS cancelled_rides
FROM rides
WHERE ride_status = 'Cancelled';

SELECT SUM(distance_km) AS total_distance_km
FROM rides
WHERE ride_status = 'Completed';

SELECT ride_status, COUNT(*) AS total_rides
FROM rides
GROUP BY ride_status;

SELECT gender, COUNT(*) AS total_customers
FROM customers
GROUP BY gender;

SELECT rating, COUNT(*) AS total_reviews
FROM ratings_reviews
GROUP BY rating
ORDER BY rating DESC;

SELECT driver_id, COUNT(*) AS completed_rides, SUM(fare) AS total_revenue
FROM rides
WHERE ride_status = 'Completed'
GROUP BY driver_id
ORDER BY total_revenue DESC;

SELECT driver_id, COUNT(*) AS completed_rides
FROM rides
WHERE ride_status = 'Completed'
GROUP BY driver_id
HAVING COUNT(*) >= 4;

SELECT customers.customer_name, cities.city_name
FROM customers
JOIN cities ON customers.city_id = cities.city_id;

SELECT cities.city_name, COUNT(rides.ride_id) AS total_rides
FROM cities
JOIN rides ON cities.city_id = rides.city_id
GROUP BY cities.city_name;

SELECT cities.city_name, SUM(rides.fare) AS total_revenue
FROM cities
JOIN rides ON cities.city_id = rides.city_id
WHERE rides.ride_status = 'Completed'
GROUP BY cities.city_name
ORDER BY total_revenue DESC;

SELECT drivers.driver_name, COUNT(rides.ride_id) AS completed_rides
FROM drivers
JOIN rides ON drivers.driver_id = rides.driver_id
WHERE rides.ride_status = 'Completed'
GROUP BY drivers.driver_name
ORDER BY completed_rides DESC;

SELECT payment_methods.method_name, COUNT(payments.payment_id) AS total_payments
FROM payment_methods
JOIN payments ON payment_methods.payment_method_id = payments.payment_method_id
GROUP BY payment_methods.method_name;

SELECT rides.ride_id, coupons.coupon_code, rides.fare, rides.discount_amount
FROM rides
JOIN coupons ON rides.coupon_id = coupons.coupon_id;

SELECT customers.customer_name, SUM(rides.fare) AS total_spent
FROM customers
JOIN rides ON customers.customer_id = rides.customer_id
WHERE rides.ride_status = 'Completed'
GROUP BY customers.customer_name
ORDER BY total_spent DESC
LIMIT 5;
