SELECT * FROM c4_project.deliveryagents;
-- Task 5: Delivery Agent Performance
-- Rank agents (per route) by on-time delivery percentage

SELECT 
    Agent_ID,
    Route_ID,
    On_Time_Percentage,
    RANK() OVER(
        PARTITION BY Route_ID 
        ORDER BY On_Time_Percentage DESC
    ) AS Agent_Rank_Per_Route
FROM 
    DeliveryAgents;
    
-- agents with on-time % < 80%
SELECT 
    Agent_ID,
    Route_ID,
    On_Time_Percentage
FROM 
    DeliveryAgents
WHERE 
    On_Time_Percentage < 80
ORDER BY
    On_Time_Percentage;
    
-- Compare average speed of top 5 vs bottom 5 agents using subqueries (or CTEs)

WITH Top5Agents AS (
    SELECT Agent_ID, Avg_Speed_KM_HR 
    FROM DeliveryAgents 
    ORDER BY On_Time_Percentage DESC
    LIMIT 5
),
Bottom5Agents AS (
    SELECT Agent_ID, Avg_Speed_KM_HR 
    FROM DeliveryAgents 
    ORDER BY On_Time_Percentage ASC
    LIMIT 5
)
SELECT 
    (SELECT AVG(Avg_Speed_KM_HR) FROM Top5Agents) AS Avg_Speed_Top_5_Agents,
    (SELECT AVG(Avg_Speed_KM_HR) FROM Bottom5Agents) AS Avg_Speed_Bottom_5_Agents;
