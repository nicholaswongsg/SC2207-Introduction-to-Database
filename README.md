# SC2207-Introduction-to-Database

# About

<img src="img/er.png" alt="ER Diagram">

# Assumptions
<ul>
  <li>We will be using the ER approach. For nested subclasses, we only inherit the keys of the immediate parent.</li>
  <li>When a customer creates a complaint, it is recorded in a complaint table. However, employeeID is added when an employee decided to pick up the case.</li>
  <li>Each OrderDetail contains the aggregation of item price for easier query and instead of querying from PriceHistory from BookstorePublications</li>
  <li>Each complaint record consist of priority number (1-4 with 1 being the highest priority), status and timestamp. This allow company to track resolution time given each priority status.</li>
  <li>Bookstore have to fill in priceMemo - reason for price changes (eg. CNY Promo) and the price changes validity (start of promo to end of promo).</li>
  <li>Each order has its own deliveryDate. Each order can have several deliveryDates.</li>
</ul>  

<img src="img/Q1.png" alt="Question">
<img src="img/Q2.png" alt="Question">
<img src="img/Q3.png" alt="Question">
<img src="img/Q4.png" alt="Question">
<img src="img/Q5.png" alt="Question">
<img src="img/Q6.png" alt="Question">
<img src="img/Q7.png" alt="Question">
<img src="img/Q8.png" alt="Question">
<img src="img/Q9.png" alt="Question">
<img src="img/Q10.png" alt="Question">
<img src="img/Bonus1.png" alt="Question">
<img src="img/Bonus2.png" alt="Question">
<img src="img/Bonus3.png" alt="Question">
