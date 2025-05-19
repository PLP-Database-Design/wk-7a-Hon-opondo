-- The SQL query to transform the table into 1NF:
SELECT
    pd.OrderID,
    pd.CustomerName,
    TRIM(product_item) AS Product
-- TRIM removes any leading/trailing spaces from the split items
FROM
    ProductDetail pd,
    LATERAL UNNEST(string_to_array
(pd.Products, ',')) AS product_item;

- Table 1: Orders
(or CustomerOrders)
-- This table will store information that depends solely on OrderID.
-- The primary key is OrderID. CustomerName depends fully on OrderID.
CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Populate the Orders table using distinct OrderID and CustomerName from the original table
INSERT INTO Orders
    (OrderID, CustomerName)
SELECT DISTINCT
    OrderID,
    CustomerName
FROM
    OrderDetails;

-- Table 2: Order_Items (or ProductOrderDetails)
-- This table will store information that depends on the combination of OrderID and Product.
-- The composite primary key is (OrderID, Product). Quantity depends fully on this composite key.
CREATE TABLE Order_Items
(
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    -- Composite Primary Key
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
    -- Links back to the Orders table
);

-- Populate the Order_Items table
INSERT INTO Order_Items
    (OrderID, Product, Quantity)
SELECT
    OrderID,
    Product,
    Quantity
FROM
    OrderDetails;

-- To show the transformed tables as per the question:
-- (These SELECT statements are just to view the result,
-- the CREATE TABLE and INSERT INTO statements above are the core transformation)

SELECT 'Orders Table (2NF)' AS Table_Name;
SELECT *
FROM Orders;

SELECT 'Order_Items Table (2NF)' AS Table_Name;
SELECT *
FROM Order_Items;