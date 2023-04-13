/*Q1*/
SELECT p.title, AVG(ph.price) as average_price
FROM Publication p
JOIN AssignedPublicationWarehouse apw ON p.publicationID = apw.publicationID
JOIN priceHistory ph ON apw.bookstorePublicationID = ph.bookstorePublicationID
WHERE p.title = 'Harry Porter Finale'
AND ph.startDate >= '2022-08-01' AND ph.endDate <= '2022-08-31'
GROUP BY p.title;

/*Q2*/
SELECT p.title, AVG(r.rating) as average_rating, COUNT(*) as num_ratings
FROM Publication p
JOIN AssignedPublicationWarehouse apw ON p.publicationID = apw.publicationID
JOIN Review r ON apw.bookstorePublicationID = r.bookstorePublicationID
WHERE r.rating = 5
AND r.ratingTimestamp >= '2022-08-01' AND r.ratingTimestamp <= '2022-08-31'
GROUP BY p.title
HAVING COUNT(*) >= 10
ORDER BY average_rating DESC;

/*Q3*/
SELECT p.title,p.publicationID, AVG(DATEDIFF(Minute, o.orderTimestamp, ip.deliveryDate)) as average_delivery_time
FROM Publication p
JOIN AssignedPublicationWarehouse apw ON p.publicationID = apw.publicationID
JOIN ItemPurchased ip ON apw.bookstorePublicationID = ip.bookstorePublicationID
JOIN CustomerOrder o ON ip.orderID = o.orderID
WHERE o.orderTimestamp >= '2022-06-01' AND o.orderTimestamp <= '2022-06-30'
AND ip.deliveryDate IS NOT NULL
GROUP BY p.title,p.publicationID;


/*Q4*/
SELECT TOP 1 e.name, AVG(DATEDIFF(HOUR, c.complaintTimestamp, cr.timestamp)) as average_latency
FROM Employee e
JOIN AssignedComplaints ac ON e.employeeID = ac.employeeID
JOIN Complaints c ON ac.complaintID = c.complaintID
JOIN ComplaintRecord cr ON c.complaintID = cr.complaintID
WHERE cr.status = 'Resolved'
GROUP BY e.name
ORDER BY average_latency ASC

/*Q5*/
SELECT p.title, COUNT(apw.bookstoreID) as num_bookstores
FROM Publication p
JOIN AssignedPublicationWarehouse apw ON p.publicationID = apw.publicationID
WHERE p.publisher = 'Nanyang Publisher Company'
GROUP BY p.title;

/*Q6*/
SELECT TOP 1 b.bookstoreName, SUM(ip.price * ip.quantity) as total_revenue
FROM Bookstore b
JOIN AssignedPublicationWarehouse apw ON b.bookstoreID = apw.bookstoreID
JOIN ItemPurchased ip ON apw.bookstorePublicationID = ip.bookstorePublicationID
JOIN CustomerOrder o ON ip.orderID = o.orderID
WHERE o.orderTimestamp >= '2022-08-01' AND o.orderTimestamp <= '2022-08-31'
GROUP BY b.bookstoreName
ORDER BY total_revenue DESC

/*Q7*/
WITH MostComplaintsCustomer AS (
  SELECT TOP 1 c.customerID
  FROM Complaints c
  GROUP BY c.customerID
  ORDER BY COUNT(*) DESC
)
SELECT TOP 1 p.title,mcc.customerid, MAX(ip.price) as max_price
FROM MostComplaintsCustomer mcc
JOIN CustomerOrder o ON mcc.customerID = o.customerID
JOIN ItemPurchased ip ON o.orderID = ip.orderID
JOIN AssignedPublicationWarehouse apw ON ip.bookstorePublicationID = apw.bookstorePublicationID
JOIN Publication p ON apw.publicationID = p.publicationID
GROUP BY p.title,mcc.customerid
ORDER BY max_price DESC

/**
8.Find publications that have never been purchased by any customer in July 2022, but are the top 3
most purchased publications in August 2022.**/
WITH JulyPurchases AS (
  SELECT p.publicationID
  FROM Publication p
  JOIN AssignedPublicationWarehouse apw ON p.publicationID = apw.publicationID
  JOIN ItemPurchased ip ON apw.bookstorePublicationID = ip.bookstorePublicationID
  JOIN CustomerOrder o ON ip.orderID = o.orderID
  WHERE o.orderTimestamp >= '2022-07-01' AND o.orderTimestamp <= '2022-07-31'
),
AugustTopPurchases AS (
  SELECT p.publicationID, COUNT(ip.orderID) as num_purchases
  FROM Publication p
  JOIN AssignedPublicationWarehouse apw ON p.publicationID = apw.publicationID
  JOIN ItemPurchased ip ON apw.bookstorePublicationID = ip.bookstorePublicationID
  JOIN CustomerOrder o ON ip.orderID = o.orderID
  WHERE o.orderTimestamp >= '2022-08-01' AND o.orderTimestamp <= '2022-08-31' AND p.publicationID NOT IN(
    SELECT publicationid FROM JulyPurchases
    )
  GROUP BY p.publicationID
)
SELECT TOP 3 publicationID, num_purchases FROM AugustTopPurchases ORDER BY num_purchases DESC
/**9. Find publications that are increasingly being purchased over at least 3 months
**/
/*Q9*/
SELECT apw.publicationID, t4.publisher as 'Publisher Name'
FROM ItemPurchased ip
JOIN AssignedPublicationWarehouse apw ON apw.bookstorePublicationID = ip.bookstorePublicationID
JOIN (
    SELECT YEAR(deliveryDate) AS year, MONTH(deliveryDate) AS month, bookstorePublicationID, SUM(quantity) AS total_quantity
    FROM ItemPurchased
    GROUP BY YEAR(deliveryDate), MONTH(deliveryDate), bookstorePublicationID
) t1 ON t1.bookstorePublicationID = ip.bookstorePublicationID AND t1.year = YEAR(ip.deliveryDate) AND t1.month = MONTH(ip.deliveryDate)
JOIN (
    SELECT YEAR(deliveryDate) AS year, MONTH(deliveryDate) AS month, bookstorePublicationID, SUM(quantity) AS total_quantity
    FROM ItemPurchased
    GROUP BY YEAR(deliveryDate), MONTH(deliveryDate), bookstorePublicationID
) t2 ON t2.bookstorePublicationID = ip.bookstorePublicationID AND t2.year = t1.year AND t2.month = t1.month + 1
JOIN (
    SELECT YEAR(deliveryDate) AS year, MONTH(deliveryDate) AS month, bookstorePublicationID, SUM(quantity) AS total_quantity
    FROM ItemPurchased
    GROUP BY YEAR(deliveryDate), MONTH(deliveryDate), bookstorePublicationID
) t3 ON t3.bookstorePublicationID = ip.bookstorePublicationID AND t3.year = t2.year AND t3.month = t2.month + 1
JOIN (
    SELECT *
	FROM Publication
) t4 ON t4.publicationID = apw.publicationID

WHERE t1.total_quantity < t2.total_quantity AND t2.total_quantity < t3.total_quantity;


/*Q10*/
/* repeated customers for all bookstore that purchased at least 3 in 2022*/
WITH RepeatedCustomers AS (
SELECT
customerID,
COUNT(*) AS num_orders
FROM CustomerOrder
WHERE YEAR(orderTimestamp) = 2022 GROUP BY
customerID HAVING
COUNT(*) >= 3 ),
/* join all the relevant table together */ BookstoreOrders AS (
SELECT b.bookstoreID, b.bookstoreName, co.customerID
FROM Bookstore b
JOIN PublicationWarehouse pw ON b.bookstoreID = pw.bookstoreID
JOIN ItemPurchased ip ON pw.bookstorePublicationID = ip.bookstorePublicationID JOIN CustomerOrder co ON ip.orderID = co.orderID
WHERE YEAR(co.orderTimestamp) = 2022 ),
/* to determine number of repeated customers of each bookstore*/ RepeatedCustomerBookstores AS (
SELECT
bo.bookstoreID,
bo.bookstoreName,
COUNT(DISTINCT bo.customerID) AS num_repeated_customers
24
FROM BookstoreOrders bo
JOIN RepeatedCustomers rc ON bo.customerID = rc.customerID GROUP BY
bo.bookstoreID,
bo.bookstoreName )
SELECT TOP 1 bookstoreID, bookstoreName, num_repeated_customers
FROM RepeatedCustomerBookstores
ORDER BY num_repeated_customers DESC
