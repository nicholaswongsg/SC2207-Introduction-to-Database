CREATE TABLE Bookstore (
    bookstoreID INT PRIMARY KEY,
    bookstoreName VARCHAR(255) NOT NULL
);

CREATE TABLE priceHistory (
    bookstorePublicationID VARCHAR(255) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    priceMemo VARCHAR(255) NOT NULL,
    PRIMARY KEY (bookstorePublicationID, startDate)
);

CREATE TABLE Customers (
    customerID INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Complaints (
    complaintID INT PRIMARY KEY,
    complaintTimestamp DATETIME NOT NULL,
    comments TEXT NOT NULL,
    customerID INT NOT NULL,
    FOREIGN KEY (customerID) REFERENCES Customers(customerID) ON DELETE CASCADE
);

CREATE TABLE CustomerOrder (
    orderID INT PRIMARY KEY,
    orderTimestamp DATETIME NOT NULL,
    shippingAddress VARCHAR(255) NOT NULL,
    shippingCost DECIMAL(10, 2) NOT NULL,
    customerID INT NOT NULL,
    FOREIGN KEY (customerID) REFERENCES Customers(customerID) ON DELETE CASCADE
);

CREATE TABLE OrderItem (
    orderItemID INT PRIMARY KEY,
    orderID INT NOT NULL,
    bookstorePublicationID INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (orderID) REFERENCES CustomerOrder(orderID) ON DELETE CASCADE
);

CREATE TABLE ItemPurchased (
    bookstorePublicationID VARCHAR(255) NOT NULL,
    orderID INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    deliveryDate DATETIME NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (bookstorePublicationID, orderID)
);

CREATE TABLE Review (
    bookstorePublicationID VARCHAR(255) NOT NULL,
    orderID INT NOT NULL,
    rating DECIMAL(10, 2) NOT NULL,
    comment TEXT NOT NULL,
    ratingTimestamp DATETIME NOT NULL,
    customerID INT NOT NULL,
    PRIMARY KEY (bookstorePublicationID, orderID),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID) ON DELETE CASCADE
);

CREATE TABLE AssignedOrder (
    orderID INT NOT NULL,
    customerID INT NOT NULL,
    PRIMARY KEY (orderID),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID) ON DELETE CASCADE
);

CREATE TABLE Publication (
    publicationID VARCHAR(255) PRIMARY KEY,
    publisher VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    yearOfPublication INT NOT NULL,
    issueNumber VARCHAR(255) NULL
);

CREATE TABLE OrderDetailsStatus (
    bookstorePublicationID VARCHAR(255) NOT NULL,
    orderID INT NOT NULL,
    statusTimestamp DATETIME NOT NULL,
    itemStatus VARCHAR(255) NOT NULL,
    PRIMARY KEY (bookstorePublicationID, orderID, statusTimestamp)
);

CREATE TABLE Complaints_Bookstore (
    complaintID INT PRIMARY KEY,
    bookstoreID INT NOT NULL,
    FOREIGN KEY (complaintID) REFERENCES Complaints(complaintID) ON DELETE CASCADE,
    FOREIGN KEY (bookstoreID) REFERENCES Bookstore(bookstoreID) ON DELETE CASCADE
);

CREATE TABLE ComplaintRecord (
    complaintID INT NOT NULL,
    timestamp DATETIME NOT NULL,
    status VARCHAR(255) NOT NULL,
    complaintPriority INT NOT NULL,
    PRIMARY KEY (complaintID, timestamp),
    FOREIGN KEY (complaintID) REFERENCES Complaints(complaintID) ON DELETE CASCADE
);

CREATE TABLE Employee (
    employeeID INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE EmployeeSalary (
employeeID INT NOT NULL,
salaryDatetime DATETIME NOT NULL,
monthlySalary DECIMAL(10, 2) NOT NULL,
PRIMARY KEY (employeeID, salaryDatetime),
FOREIGN KEY (employeeID) REFERENCES Employee(employeeID) ON DELETE CASCADE
);

CREATE TABLE PublicationWarehouse (
    bookstorePublicationID VARCHAR(255) PRIMARY KEY,
    inventoryBalance INT NOT NULL,
    itemPrice DECIMAL(10, 2) NOT NULL,
    bookstoreID INT NOT NULL,
    FOREIGN KEY (bookstoreID) REFERENCES Bookstore(bookstoreID) ON DELETE CASCADE
);

CREATE TABLE AssignedPublicationWarehouse (
    bookstoreID INT NOT NULL,
    publicationID VARCHAR(255) NOT NULL,
    bookstorePublicationID VARCHAR(255) NOT NULL,
    PRIMARY KEY (bookstoreID, publicationID),
    FOREIGN KEY (bookstoreID) REFERENCES Bookstore(bookstoreID) ON DELETE NO ACTION,
    FOREIGN KEY (publicationID) REFERENCES Publication(publicationID) ON DELETE NO ACTION,
    FOREIGN KEY (bookstorePublicationID) REFERENCES PublicationWarehouse(bookstorePublicationID) ON DELETE CASCADE
);

CREATE TABLE Complaints_Publication (
    complaintID INT NOT NULL,
    publicationID VARCHAR(255) NOT NULL,
    PRIMARY KEY (complaintID, publicationID), 
    FOREIGN KEY (complaintID) REFERENCES Complaints(complaintID) ON DELETE CASCADE,
    FOREIGN KEY (publicationID) REFERENCES Publication(publicationID) ON DELETE CASCADE
);
CREATE TABLE AssignedComplaints (
    complaintID INT NOT NULL,
    employeeID INT NOT NULL,
    PRIMARY KEY (complaintID),
    FOREIGN KEY (employeeID) REFERENCES Employee(employeeID) ON DELETE CASCADE
);