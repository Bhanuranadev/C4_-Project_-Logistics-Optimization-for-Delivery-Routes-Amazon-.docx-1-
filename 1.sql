use c4_project;
-- 1. Orders Table [cite: 17, 18]
CREATE TABLE Orders (
    Order_ID VARCHAR(10) PRIMARY KEY,
    Customer_ID VARCHAR(10),
    Warehouse_ID VARCHAR(10),
    Route_ID VARCHAR(10),
    Order_Date DATE,
    Expected_Delivery_Date DATE,
    Actual_Delivery_Date DATE,
    Delivery_Status VARCHAR(20)
);

-- 2. Routes Table [cite: 19, 20]
CREATE TABLE Routes (
    Route_ID VARCHAR(10) PRIMARY KEY,
    Start_Location VARCHAR(50),
    End_Location VARCHAR(50),
    Distance_KM DECIMAL(10, 2),
    Average_Travel_Time_Min INT,
    Traffic_Delay_Min INT,
    Delivery_Status VARCHAR(20) -- Note: This column seems redundant here, but is in the spec [cite: 20]
);

-- 3. Warehouses Table [cite: 21, 22]
CREATE TABLE Warehouses (
    Warehouse_ID VARCHAR(10) PRIMARY KEY,
    Location VARCHAR(50),
    Processing_Time_Min INT,
    Dispatch_Time TIME,
    Traffic_Delay_Min INT, -- Note: This column seems redundant here, but is in the spec [cite: 22]
    Delivery_Status VARCHAR(20) -- Note: This column seems redundant here, but is in the spec [cite: 22]
);

-- 4. DeliveryAgents Table 
CREATE TABLE DeliveryAgents (
    Agent_ID VARCHAR(10) PRIMARY KEY,
    Route_ID VARCHAR(10),
    Shift_Hours INT,
    Avg_Speed_KM_HR INT,
    On_Time_Percentage DECIMAL(5, 2)
);

-- 5. ShipmentTracking Table 
CREATE TABLE ShipmentTracking (
    Shipment_ID VARCHAR(10) PRIMARY KEY,
    Order_ID VARCHAR(10),
    Checkpoint VARCHAR(20),
    Checkpoint_Time DATE,
    Delay_Reason VARCHAR(30)
);


-- Identify and delete duplicate Order_ID records
DELETE o1 
FROM Orders o1
INNER JOIN Orders o2
WHERE
    o1.Order_ID = o2.Order_ID AND (
        o1.Order_Date > o2.Order_Date OR
        (o1.Order_Date = o2.Order_Date AND o1.Customer_ID > o2.Customer_ID)
    );


-- First, calculate the average and store it in a session variable
-- 1. Calculate the average, defaulting to 0 if the average is NULL
SET @AvgDelay = (SELECT COALESCE(AVG(Traffic_Delay_Min), 0) 
                 FROM Routes 
                 WHERE Traffic_Delay_Min IS NOT NULL);

-- 2. Update any NULL values with this average
UPDATE Routes
SET Traffic_Delay_Min = @AvgDelay
WHERE Traffic_Delay_Min IS NULL;