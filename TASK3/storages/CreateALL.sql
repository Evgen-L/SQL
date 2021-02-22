USE Ikea;



CREATE TABLE Company
(
	Id INT PRIMARY KEY,    /*IDENTITY(1,1)*/
	Name VARCHAR(20),
	Address VARCHAR(20),
	Telephone VARCHAR(20)
)

CREATE TABLE Storage
(
	Id INT PRIMARY KEY,
	Name VARCHAR(20),
	Serial_number INT,
	Address VARCHAR(20),
	Telephone VARCHAR(20),
	CompanyId INT,
	FOREIGN KEY (CompanyId)  REFERENCES Company(Id)
)

CREATE TABLE  Product
(
	Id INT IDENTITY,
	Name VARCHAR(20) UNIQUE,
	Price VARCHAR(10),
	Quantity INT, 
	PRIMARY KEY(Id)
); 

CREATE TABLE  Product_in_storage
(
    Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(20) UNIQUE,
    StorageId INT,
	ProductId INT,
    Type VARCHAR(20),
    FOREIGN KEY (StorageId)  REFERENCES Storage (Id)
);

CREATE TABLE Supplement_Product_In_Storage
(
	Product_in_storageId INT UNIQUE,
	ProductId INT UNIQUE,
	FOREIGN KEY (Product_in_storageId)  REFERENCES Product_in_storage (Id),
	FOREIGN KEY (ProductId)  REFERENCES Product (Id)
);

CREATE TABLE Client
(
	Id INT PRIMARY KEY,
	Name VARCHAR(20),
	Age INT,
	Telephone VARCHAR(20),
	ProductId INT
);

CREATE TABLE Payment
(
  ClientId INT,
  ProductId INT,
  Type VARCHAR(10),
  Payment_Amount INT,
  FOREIGN KEY (ClientId)  REFERENCES Client (Id),
  FOREIGN KEY (ProductId)  REFERENCES Product (Id),
);



