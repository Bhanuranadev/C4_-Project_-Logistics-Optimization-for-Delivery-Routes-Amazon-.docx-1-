SELECT * FROM c4_project.warehouses;
TRUNCATE TABLE warehouses;

-- Task 4: Warehouse Performance
-- top 3 warehouses with the highest average processing time
SELECT 
    Warehouse_ID,
    Location,
    Processing_Time_Min
FROM 
    Warehouses
ORDER BY 
    Processing_Time_Min DESC
LIMIT 3;

-- Calculate total vs. delayed shipments for each warehouse
SELECT 
    Warehouse_ID,
    COUNT(Order_ID) AS Total_Shipments,
    SUM(CASE WHEN Delivery_Status = 'Delayed' THEN 1 ELSE 0 END) AS Delayed_Shipments
FROM 
    Orders
GROUP BY 
    Warehouse_ID
ORDER BY
    Delayed_Shipments DESC;
    
-- Use CTEs to find bottleneck warehouses where processing time > global average
WITH GlobalAvg AS (
    -- 1. Find the single global average
    SELECT AVG(Processing_Time_Min) AS Global_Avg_Processing 
    FROM Warehouses
)


-- 2. Compare each warehouse to that average

SELECT 
    w.Warehouse_ID, 
    w.Location, 
    w.Processing_Time_Min
FROM 
    Warehouses w, GlobalAvg ga
WHERE 
    w.Processing_Time_Min > ga.Global_Avg_Processing
ORDER BY
    w.Processing_Time_Min DESC;
    
-- Rank warehouses based on on-time delivery percentage

SELECT 
    Warehouse_ID,
    (SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS On_Time_Percentage
FROM 
    Orders
GROUP BY 
    Warehouse_ID
ORDER BY 
    On_Time_Percentage ASC; -- Ranking from worst to best