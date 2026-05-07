USE foodtruck
GO

-- CREATES

-- Object: Table [dbo].[TruckLocation] 4/27/2026 @ 2:38PM

CREATE TABLE [dbo].[TruckLocation]
(
	[TruckLocationID] [int] PRIMARY KEY NOT NULL,
	[TruckID] [int],
	[StreetID] [int],
	[TimestampID] [int]
);
GO

-- Object: Table [dbo].[Truck] 4/27/2026 @ 2:38PM

CREATE TABLE  [dbo].[Truck]
(
	[TruckID] [int] PRIMARY KEY NOT NULL,
	[LicensePlate] [VARCHAR](50)
);
GO

-- Object: Table [dbo].[LocationByTime] 4/27/2026 @ 2:38PM

CREATE TABLE [dbo].[LocationByTime]
(
	[TimestampID] [int] PRIMARY KEY NOT NULL,
	[StartDate] [date] NOT NULL,
	[StartTime] [time] NOT NULL,
	[LeaveTime] [time],
	[EndDate] [date]
);
GO

-- Object: Table [dbo].[Street] 4/27/2026 @ 2:38PM

CREATE TABLE [dbo].[Street]
(
	StreetID [int] PRIMARY KEY NOT NULL,
	CityID [int],
	StreetName [VARCHAR](100)
);
GO

-- Object: Table [dbo].[City] 4/27/2026 @ 2:38PM

CREATE TABLE [dbo].[City]
(
	CityID [int] PRIMARY KEY NOT NULL,
	TerritoryID [int],
	ZipcodeID [int],
	CityName [VARCHAR](100)
);
GO

-- Object: Table [dbo].[Territory] 4/27/2026 @ 2:38PM

CREATE TABLE [dbo].[Territory]
(
	TerritoryID [int] PRIMARY KEY NOT NULL,
	CountryID [int],
	TerritoryName [VARCHAR](100)
);
GO

-- Object: Table [dbo].[Country] 4/27/2026 @ 2:38PM

CREATE TABLE [dbo].[Country]
(
	CountryID [int] PRIMARY KEY NOT NULL,
	CountryName [VARCHAR](100)
);
GO

-- Object: Table [dbo].[Zipcode] 4/27/2026 @ 2:39PM

CREATE TABLE [dbo].[Zipcode]
(
	ZipcodeID [int] PRIMARY KEY NOT NULL,
	ZipcodeEntry [VARCHAR](10) NOT NULL
);
GO

-- Altering tables and assigning the empty INTs to be a Foreign Key

EXEC sp_rename 'Recipes.Name', 'RecipeName', 'COLUMN';
EXEC sp_rename 'Ingredients.Name', 'IngredientName', 'COLUMN';

ALTER TABLE [dbo].[Orders]
ADD [DateOfOrder] DATE NULL;
GO

ALTER TABLE [dbo].[Ingredients] 
ADD [IngredientLocationID] INT NULL;
GO

ALTER TABLE [dbo].[RecipeIngredients] 
ADD [RecipeIngredientLocationID] INT NULL;
GO

ALTER TABLE [dbo].[Orders] 
ADD [OrderLocationID] INT NULL;
GO

ALTER TABLE [dbo].[Recipes] 
ADD [RecipeLocationID] INT NULL;

ALTER TABLE [dbo].[Territory] WITH CHECK ADD 
    CONSTRAINT [FK_CountryID] FOREIGN KEY ([CountryID])
    REFERENCES [dbo].[Country] ([CountryID]);
GO

ALTER TABLE [dbo].[City] WITH CHECK ADD 
    CONSTRAINT [FK_TerritoryID] FOREIGN KEY ([TerritoryID])
    REFERENCES [dbo].[Territory] ([TerritoryID]);
GO

ALTER TABLE [dbo].[City] WITH CHECK ADD 
    CONSTRAINT [FK_City_Zipcode] FOREIGN KEY ([ZipcodeID])
    REFERENCES [dbo].[Zipcode] ([ZipcodeID]);
GO

ALTER TABLE [dbo].[Street] WITH CHECK ADD 
    CONSTRAINT [FK_CityID] FOREIGN KEY ([CityID])
    REFERENCES [dbo].[City] ([CityID]);
GO

ALTER TABLE [dbo].[TruckLocation] WITH CHECK ADD 
    CONSTRAINT [FK_TruckID] FOREIGN KEY ([TruckID])
    REFERENCES [dbo].[Truck] ([TruckID]);
GO

ALTER TABLE [dbo].[TruckLocation] WITH CHECK ADD 
    CONSTRAINT [FK_TruckLocation_Street] FOREIGN KEY ([StreetID])
    REFERENCES [dbo].[Street] ([StreetID]);
GO

ALTER TABLE [dbo].[TruckLocation] WITH CHECK ADD 
    CONSTRAINT [FK_TruckLocation_Timestamp] FOREIGN KEY ([TimestampID])
    REFERENCES [dbo].[LocationByTime] ([TimestampID]);
GO

ALTER TABLE [dbo].[Ingredients] WITH CHECK ADD CONSTRAINT 
    [FK_IngredientLocationID] FOREIGN KEY ([IngredientLocationID]) 
    REFERENCES [dbo].[Truck] ([TruckID]);
GO

ALTER TABLE [dbo].[RecipeIngredients] WITH CHECK ADD CONSTRAINT 
    [FK_RecipeIngredientLocationID] FOREIGN KEY ([RecipeIngredientLocationID]) 
    REFERENCES [dbo].[Truck] ([TruckID]);
GO

ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT 
    [FK_OrderLocationID] FOREIGN KEY ([OrderLocationID]) 
    REFERENCES [dbo].[Truck] ([TruckID]);
GO

ALTER TABLE [dbo].[Recipes] WITH CHECK ADD CONSTRAINT 
    [FK_RecipeLocationID] FOREIGN KEY ([RecipeLocationID]) 
    REFERENCES [dbo].[Truck] ([TruckID]);
GO

ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [DateOfOrder]
GO

-- Table Altering and Creation Ends here

-- INSERTS
USE foodtruck
GO

INSERT INTO Zipcode (ZipcodeID, ZipcodeEntry)
VALUES
	(1, 'V8B 1A1'), --British Columbia
	(2, 'M5V 3L9'), --Ontario
	(3, '48219'), -- USA
	(4, '76108'); -- USA
GO

INSERT INTO Country (CountryID, CountryName)
VALUES
(1, 'United States Of America'),
(2, 'Canada');
GO

INSERT INTO Territory (TerritoryID, TerritoryName, CountryID)
VALUES
	(1, 'Michigan', 1),
	(2, 'Texas', 1),
	(3, 'British Columbia', 2),
	(4, 'Ontario', 2);
GO

INSERT INTO City (CityID, CityName, TerritoryID, ZipcodeID)
VALUES
	(1, 'Detroit', 1, 3),
	(2, 'Fort Worth', 2, 4),
	(3, 'Squamish', 3, 1),
	(4, 'Toronto', 4, 2);
GO

INSERT INTO Street (StreetID, StreetName, CityID)
VALUES
	(1, '12345 Evergreen St', 1),
	(2, '8421 Silver Ridge Blvd', 2),
	(3, '2100 Mamquam Rd' ,3),
	(4, '375 King St W', 4);
GO

INSERT INTO Truck (TruckID, LicensePlate)
VALUES
	(2, 'KTR 9M2'), -- Squamish
	(1, 'BQP 7284'), -- Detroit
	(3, '573 LQH'), -- Toronto
	(4, 'RNV-4827'); -- Fort Worth
GO

INSERT INTO LocationByTime (TimestampID, StartDate, StartTime, LeaveTime, EndDate)
VALUES
    (1, '2024-01-01', '08:00', '17:00', '2024-01-11'),
    (2, '2024-01-02', '09:00', '18:00', '2024-01-12'),
    (3, '2024-01-03', '07:30', '16:30', '2024-01-13'),
    (4, '2024-01-04', '11:00', '19:00', '2024-01-14');
GO

INSERT INTO TruckLocation (TruckLocationID, TruckID, StreetID, TimestampID)
VALUES 
	(1, 4, 2, 1), -- Fort Worth
	(2, 1, 1, 2), -- Detroit
	(3, 2, 3, 3), -- Squamish
	(4, 3, 4, 4); -- Toronto
GO

INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES
('Michael', 'Smith', 'michael.smith@example.com', '111-222-3333'),
('Emily', 'Johnson', 'emily.johnson@example.com', '222-333-4444'),
('David', 'Williams', 'david.williams@example.com', '333-444-5555'),
('Sarah', 'Brown', 'sarah.brown@example.com', '444-555-6666'),
('Christopher', 'Jones', 'chris.jones@example.com', '555-666-7777'),
('Amanda', 'Garcia', 'amanda.garcia@example.com', '666-777-8888'),
('Matthew', 'Miller', 'matt.miller@example.com', '777-888-9999'),
('Olivia', 'Davis', 'olivia.davis@example.com', '888-999-0001'),
('Daniel', 'Rodriguez', 'daniel.rod@example.com', '999-000-1111'),
('Sophia', 'Martinez', 'sophia.martinez@example.com', '000-111-2222'),
('Andrew', 'Hernandez', 'andrew.hernandez@example.com', '101-202-3030'),
('Grace', 'Lopez', 'grace.lopez@example.com', '202-303-4040'),
('Joshua', 'Gonzalez', 'josh.gonzalez@example.com', '303-404-5050'),
('Chloe', 'Wilson', 'chloe.wilson@example.com', '404-505-6060'),
('Ethan', 'Anderson', 'ethan.anderson@example.com', '505-606-7070'),
('Natalie', 'Thomas', 'natalie.thomas@example.com', '606-707-8080'),
('Ryan', 'Taylor', 'ryan.taylor@example.com', '707-808-9090'),
('Ava', 'Moore', 'ava.moore@example.com', '808-909-0101'),
('Jacob', 'Jackson', 'jacob.jackson@example.com', '909-010-1212'),
('Lily', 'Martin', 'lily.martin@example.com', '010-121-2323'),
('Anthony', 'Lee', 'anthony.lee@example.com', '121-232-3434'),
('Hannah', 'Perez', 'hannah.perez@example.com', '232-343-4545'),
('Samuel', 'Thompson', 'samuel.thompson@example.com', '343-454-5656'),
('Ella', 'White', 'ella.white@example.com', '454-565-6767'),
('Joseph', 'Harris', 'joseph.harris@example.com', '565-676-7878'),
('Zoe', 'Sanchez', 'zoe.sanchez@example.com', '676-787-8989');
GO

INSERT INTO Ingredients (IngredientName, UnitCost, InventoryCount, IngredientLocationID)
VALUES
('Beef', 0.30, 18, 1),
('Lettuce', 0.25, 24, 1),
('Tomato', 0.35, 14, 1),
('HamburgerBun', 0.25, 25, 1);
GO

UPDATE Recipes
SET Price='3.74', RecipeLocationID='1'
WHERE RecipeID = '1';

INSERT INTO Recipes (RecipeName, Price, RecipeLocationID)
VALUES
('Hamburger', 3.10, 1);
GO

UPDATE RecipeIngredients
SET RecipeIngredientLocationID ='1'
WHERE Ingredient = '1'

INSERT INTO RecipeIngredients (Recipe, Ingredient, Amount, RecipeIngredientLocationID)
VALUES
(
	(SELECT RecipeID from Recipes WHERE RecipeName='Hamburger'), 
	(SELECT IngredientID FROM Ingredients WHERE IngredientName='HamburgerBun'),
	2.0, 1
),
(
	(SELECT RecipeID from Recipes WHERE RecipeName='Hamburger'), 
	(SELECT IngredientID FROM Ingredients WHERE IngredientName='Beef'),
	3.0, 1
),
(
	(SELECT RecipeID from Recipes WHERE RecipeName='Hamburger'), 
	(SELECT IngredientID FROM Ingredients WHERE IngredientName='Lettuce'),
	4.0, 1
),
(
	(SELECT RecipeID from Recipes WHERE RecipeName='Hamburger'), 
	(SELECT IngredientID FROM Ingredients WHERE IngredientName='Tomato'),
	2.0, 1
),
(
	(SELECT RecipeID from Recipes WHERE RecipeName='Taco'), 
	(SELECT IngredientID FROM Ingredients WHERE IngredientName='Beef'),
	3.0, 1
),
(
	(SELECT RecipeID from Recipes WHERE RecipeName='Taco'), 
	(SELECT IngredientID FROM Ingredients WHERE IngredientName='Lettuce'),
	4.0, 1
),
(
	(SELECT RecipeID from Recipes WHERE RecipeName='Taco'), 
	(SELECT IngredientID FROM Ingredients WHERE IngredientName='Tomato'),
	2.4, 1
)
GO

-- TACOS

UPDATE Orders
SET TotalPrice = '3.74', OrderLocationID ='1', DateOfOrder = GETDATE()
WHERE OrderID = '1';


INSERT INTO Orders (CustomerID, TotalPrice, OrderLocationID)
VALUES
(2, 7.48, 1),    -- Qty 2
(3, 11.22, 1),   -- Qty 3
(4, 14.96, 1),   -- Qty 4
(5, 18.70, 1),   -- Qty 5
(6, 7.48, 1),    -- Qty 2
(7, 22.44, 1),   -- Qty 6
(8, 29.92, 1),   -- Qty 8
(9, 29.92, 1),   -- Qty 8
(10, 11.22, 1);  -- Qty 3
GO

-- BURGERS

INSERT INTO Orders (CustomerID, TotalPrice, OrderLocationID)
VALUES (11, 3.10, 1),    -- Qty 1
(12, 6.20, 1),    -- Qty 2
(13, 9.30, 1),    -- Qty 3
(14, 12.40, 1),   -- Qty 4
(15, 15.50, 1),   -- Qty 5
(16, 6.20, 1),    -- Qty 2
(17, 18.60, 1),   -- Qty 6
(18, 24.80, 1),   -- Qty 8
(19, 24.80, 1),   -- Qty 8
(20, 9.30, 1);    -- Qty 3
GO

INSERT INTO LineItem (OrderID, RecipeID, Quantity)
SELECT 
    O.OrderID,
    1 AS RecipeID,
    CAST(O.TotalPrice / 3.74 AS INT) AS Quantity
FROM Orders O
WHERE O.CustomerID BETWEEN 2 AND 10;
GO

INSERT INTO LineItem (OrderID, RecipeID, Quantity)
SELECT 
    O.OrderID,
    2 AS RecipeID,
    CAST(O.TotalPrice / 3.10 AS INT) AS Quantity
FROM Orders O
WHERE O.CustomerID BETWEEN 11 AND 20;
GO

-- SELECTS

-- Truck Location by time and address parked at, ordered from 1-4
CREATE OR ALTER VIEW [dbo].TruckInformation AS
SELECT 
    tr.TruckID, 
    tr.LicensePlate,
    m.Menu,
    s.StreetName AS [Street Address], 
    ci.CityName AS [City], 
    t.TerritoryName AS [Territory], 
    z.ZipcodeEntry AS [Zipcode], 
    c.CountryName AS [Country], 
    FORMAT(lbt.StartDate, 'MM/dd/yyyy') AS [Arrival Date], 
    FORMAT(lbt.EndDate, 'MM/dd/yyyy') AS [Departure Date], 
    FORMAT(CONVERT(datetime, lbt.StartTime), 'hh:mm:ss tt') AS [Started Service],
    FORMAT(CONVERT(datetime, lbt.LeaveTime), 'hh:mm:ss tt') AS [Ended Service]
FROM Country c
LEFT JOIN Territory t ON t.CountryID = c.CountryID
LEFT JOIN City ci ON t.TerritoryID = ci.TerritoryID
LEFT JOIN Zipcode z ON ci.ZipcodeID = z.ZipcodeID
LEFT JOIN Street s ON s.CityID = ci.CityID
LEFT JOIN TruckLocation tl ON s.StreetID = tl.StreetID
LEFT JOIN Truck tr ON tl.TruckID = tr.TruckID
LEFT JOIN LocationByTime lbt ON tl.TimestampID = lbt.TimestampID

OUTER APPLY (
    SELECT STRING_AGG(r.RecipeName, ', ') WITHIN GROUP (ORDER BY r.RecipeName) AS Menu
    FROM (
        SELECT DISTINCT r2.RecipeName
        FROM Recipes r2
        INNER JOIN RecipeIngredients ri2 ON r2.RecipeID = ri2.Recipe
        WHERE ri2.RecipeIngredientLocationID = tr.TruckID
    ) AS r
) AS m

ORDER BY tr.TruckID OFFSET 0 ROWS;
GO

-- View Orders and Customers AKA SALES
CREATE OR ALTER VIEW [dbo].[CustomerOrders] AS
SELECT 
    o.OrderID,
    STRING_AGG(CONCAT(c.FirstName, ' ', c.LastName), ', ') AS [Customer Name],
    r.RecipeName AS [Bought],
    l.Quantity,
    FORMAT(o.TotalPrice, 'C') AS [Total Price], 
    FORMAT(o.DateOfOrder, 'MM/dd/yyyy') AS [Date Of Order],
    FORMAT(CONVERT(datetime, o.TimeOfOrder), 'hh:mm:ss tt') AS [Time of Order], 
    o.OrderLocationID AS [TruckID]
FROM Orders o
    LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
    LEFT JOIN LineItem l ON o.OrderID = l.OrderID
    LEFT JOIN Recipes r ON r.RecipeID = l.RecipeID
GROUP BY 
    o.OrderID, 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    r.RecipeName,
    l.Quantity,
    o.TotalPrice,
    o.DateOfOrder,
    o.TimeOfOrder,
    o.OrderLocationID;
GO

-- View the Ingredients, their parent that is a RECIPE and what a truck has in stock
CREATE OR ALTER VIEW [dbo].[IngredientStock] AS
SELECT
    i.IngredientID,
    i.IngredientName AS [Ingredient Name],
    ri.Amount AS [Amount Used in 1],
    i.UnitCost AS [Ingredient Cost],
    i.InventoryCount AS [Ingredients in Inventory],
    r.RecipeID, 
    r.RecipeName AS [Menu Item], 
    r.Price AS [Total Price],  
    r.RecipeLocationID AS [TruckID],
    tr.LicensePlate AS [Truck License Plate]
FROM Recipes r
    LEFT JOIN Truck tr ON r.RecipeLocationID = tr.TruckID
    LEFT JOIN RecipeIngredients ri ON r.RecipeID = ri.Recipe
    LEFT JOIN Ingredients i ON ri.Ingredient = i.IngredientID
ORDER BY r.RecipeID OFFSET 0 ROWS;
GO