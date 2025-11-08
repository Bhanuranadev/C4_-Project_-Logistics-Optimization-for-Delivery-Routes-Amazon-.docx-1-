SELECT * FROM c4_project.shipmenttracking;
-- Task 6: Shipment Tracking Analytics
-- For each order, list the last checkpoint and time

WITH RankedCheckpoints AS (
    SELECT 
        Order_ID,
        Checkpoint,
        Checkpoint_Time,
        -- Find the latest checkpoint for each order
        ROW_NUMBER() OVER(
            PARTITION BY Order_ID 
            ORDER BY Checkpoint_Time DESC, Shipment_ID DESC
        ) as rn
    FROM 
        ShipmentTracking
)
SELECT 
    Order_ID, 
    Checkpoint, 
    Checkpoint_Time
FROM 
    RankedCheckpoints
WHERE 
    rn = 1; -- Select only the latest one
    
-- the most common delay reasons (excluding None)
SELECT 
    Delay_Reason,
    COUNT(*) AS Reason_Count
FROM 
    ShipmentTracking
WHERE 
    Delay_Reason != 'None'
GROUP BY 
    Delay_Reason
ORDER BY 
    Reason_Count DESC;

-- Identifying  orders with >2 delayed checkpoints
SELECT 
    Order_ID,
    COUNT(*) AS Delayed_Checkpoints_Count
FROM 
    ShipmentTracking
WHERE 
    Delay_Reason != 'None'
GROUP BY 
    Order_ID
HAVING 
    COUNT(*) > 2 -- Use HAVING to filter group results
ORDER BY
    Delayed_Checkpoints_Count DESC;
    
