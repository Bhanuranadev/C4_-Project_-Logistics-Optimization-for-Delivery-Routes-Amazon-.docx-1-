SELECT * FROM c4_project.routes;

-- Task 3: Route Optimization Insights
-- For each route, calculate: Average delivery time (in days) & Average traffic delay
-- used join for orders table and avg of delivery time and avg of traffic delay
SELECT 
    r.Route_ID,
    -- Avg delivery time from order placed to actual delivery
    AVG(DATEDIFF(o.Actual_Delivery_Date, o.Order_Date)) AS Avg_Delivery_Time_Days,
    AVG(r.Traffic_Delay_Min) AS Avg_Traffic_Delay_Mins
FROM 
    Routes r
JOIN 
    Orders o ON r.Route_ID = o.Route_ID
GROUP BY 
    r.Route_ID;
    
 -- Distance-to-time efficiency ratio & Identify 3 routes with the worst efficiency ratio   
SELECT 
    Route_ID,
    Start_Location,
    End_Location,
    (Distance_KM / Average_Travel_Time_Min) AS Efficiency_Ratio
FROM 
    Routes
WHERE 
    Average_Travel_Time_Min > 0 -- Avoid division by zero
ORDER BY 
    Efficiency_Ratio ASC -- 'Worst' = Low distance per minute
LIMIT 3;

-- routes with >20% delayed shipments
SELECT 
    Route_ID,
    (SUM(CASE WHEN Delivery_Status = 'Delayed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Pct_Delayed
FROM 
    Orders
GROUP BY 
    Route_ID
HAVING 
    Pct_Delayed > 20
ORDER BY
    Pct_Delayed DESC;