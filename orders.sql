SELECT * FROM c4_project.orders;
-- Task 2
-- checks for any delivery date is before order data
SELECT 
    Order_ID, 
    Order_Date, 
    Actual_Delivery_Date
FROM 
    Orders
WHERE 
    Actual_Delivery_Date < Order_Date;
 --  calculate delivery delay days by datediff function   
SELECT 
    Order_ID,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) AS Delivery_Delay_Days
FROM 
    Orders
ORDER BY 
    Delivery_Delay_Days DESC;
-- this will Find Top 10 delayed routes based on average delay days by agv date diff function
SELECT 
    Route_ID,
    AVG(DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date)) AS Avg_Delay_Days
FROM 
    Orders
WHERE 
    Delivery_Status = 'Delayed'
GROUP BY 
    Route_ID
ORDER BY 
    Avg_Delay_Days DESC
LIMIT 10;

-- used window function Rank to rank all orders by delay within each warehouse
SELECT 
    Order_ID,
    Warehouse_ID,
    DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) AS Delay_Days,
    RANK() OVER(
        PARTITION BY Warehouse_ID 
        ORDER BY DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) DESC
    ) AS Delay_Rank
FROM 
    Orders
WHERE 
    Delivery_Status = 'Delayed';
    
-- Task 7: Advanced KPI Reporting
-- Average Delivery Delay per Region (Start_Location)
SELECT 
    r.Start_Location AS Region,
    AVG(DATEDIFF(o.Actual_Delivery_Date, o.Expected_Delivery_Date)) AS Avg_Delay_Days
FROM 
    Orders o
JOIN 
    Routes r ON o.Route_ID = r.Route_ID
WHERE 
    o.Delivery_Status = 'Delayed'
GROUP BY 
    r.Start_Location;
    
-- On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100
SELECT 
    (SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Global_On_Time_Percentage
FROM 
    Orders;
    
-- Average Traffic Delay per Route

SELECT 
    Route_ID,
    AVG(Traffic_Delay_Min) AS Avg_Traffic_Delay_Mins
FROM 
    Routes
GROUP BY 
    Route_ID
ORDER BY
    Avg_Traffic_Delay_Mins DESC;
