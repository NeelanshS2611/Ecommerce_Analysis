Select * from suppliers;

-- Find the Supplier country to Customer Country route based on the total orders delivered in that route, 
-- totalOrders on that route Output should contain SupplierCountry, CustomerCountry,
-- rank based on total orders on that route and average delivery time. Order by popularity Rank
WITH RouteDetails AS (
    SELECT 
        s.Country AS SupplierCountry,
        c.Country AS CustomerCountry,
        COUNT(o.OrderID) AS TotalOrders,
        AVG(datediff(o.DeliveryDate, o.ShipDate)) AS AvgDeliveryTime
    FROM 
        Orders o
    INNER JOIN 
        OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN 
        Suppliers s ON od.SupplierID = s.SupplierID
    INNER JOIN 
        Customers c ON o.CustomerID = c.CustomerID
    WHERE 
        o.DeliveryDate IS NOT NULL AND o.ShipDate IS NOT NULL
    GROUP BY 
        s.Country, c.Country
),
RankedRoutes AS (
    SELECT 
        SupplierCountry,
        CustomerCountry,
        TotalOrders,
        AvgDeliveryTime,
        RANK() OVER (ORDER BY TotalOrders DESC) AS PopularityRank
    FROM 
        RouteDetails
)
SELECT 
    SupplierCountry,
    CustomerCountry,
    PopularityRank,
    AvgDeliveryTime
FROM 
    RankedRoutes
ORDER BY 
    PopularityRank ASC, 
    SupplierCountry ASC, 
    CustomerCountry ASC;
    


-- Classify orders into 3 different categories. 1.Regular Order - when the order amount is less than or equal to 10,000.
-- 2.Not So Expensive Order - when the order amount is less than or equal to 60,000 and greater than 10,000.
-- 3.Expensive Order - when the order amount is greater than 60,000.
-- Print the name of the category in which the orders have been categorized into in the first column followed by Count of such orders in the second column.
-- Sort the result set in descending order of Count of orders.
select case when total_order_amount <= 10000 then 'Regular Order' 
			when total_order_amount > 10000 and total_order_amount <= 60000 then 'Not So Expensive Order' 
            Else 'Expensive Order' end as Order_type, count(*) as Count from orders
Group by Order_type
order by count;


-- Calculate the total transaction value processed for each Payment type.Print Payment Type, Allowed, followed by total transaction value.
-- Consider Total Order Amount to calculate the total transaction value. Sort the result in alphabetical order of Payment Type.

select p.PaymentType, p.Allowed ,round(sum(o.Total_order_amount),2) as Total_transaction_value  from payments p 
left join orders o
on p.paymentID = o.paymentID
Group by p.PaymentType, p.Allowed
order by  p.PaymentType
