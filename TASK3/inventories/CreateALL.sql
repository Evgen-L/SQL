USE MasterSport;

CREATE TABLE Company
(
	Id INT PRIMARY KEY,
	Name VARCHAR(20),
	Address VARCHAR(20),
	Telephone VARCHAR(20)
)

CREATE TABLE  Inventory
(
	Id INT IDENTITY,
	Name VARCHAR(20),
	Price VARCHAR(10),
	Number_Persons INT, 
	PRIMARY KEY(Id)
); 

CREATE TABLE  Hire_Inventory 
(
    Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(20),
    InventoryId INT,
	CompanyId INT,
    Type VARCHAR(20),
	FOREIGN KEY (CompanyId)  REFERENCES Company (Id)
);

CREATE TABLE Supplement_Inventory_Hire 
(
	Hire_InventoryId  INT UNIQUE,
	InventoryId INT UNIQUE,
	FOREIGN KEY (Hire_InventoryId)  REFERENCES Hire_Inventory (Id),
	FOREIGN KEY (InventoryId)  REFERENCES Inventory (Id)
);

CREATE TABLE Client
(
	Id INT PRIMARY KEY,
	Name VARCHAR(20),
	Age INT,
	Telephone VARCHAR(20),
	InventoryId INT
);

CREATE TABLE Payment
(
	ClientId INT,
	InventoryId INT,
	Type VARCHAR(10),
	Payment_Amount INT,
	FOREIGN KEY (ClientId) REFERENCES Client (Id),
	FOREIGN KEY (InventoryId) REFERENCES Inventory (Id),
)


