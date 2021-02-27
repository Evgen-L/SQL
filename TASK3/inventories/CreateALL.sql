USE MasterSport;

CREATE TABLE Company
(
	id INT PRIMARY KEY,
	name  VARCHAR(20),
	address VARCHAR(20),
	telephone VARCHAR(20)
)


CREATE TABLE  Inventory
(
	id    INT PRIMARY KEY,
	name  VARCHAR(20) UNIQUE,
	price VARCHAR(10),
	type  VARCHAR(10),
);

CREATE TABLE Client
(
	id        INT PRIMARY KEY,
	name      VARCHAR(20),
	age       INT,
	telephone VARCHAR(20) UNIQUE
);

CREATE TABLE  Hire_Inventory 
(
    id            INT PRIMARY KEY,
	id_client     INT,
	purchase_date DATE,
	id_company    INT,
	UNIQUE (id_client, purchase_date),
	FOREIGN KEY (id_company)   REFERENCES Company (id),
	FOREIGN KEY (id_client)    REFERENCES Client(id)
);


CREATE TABLE Payment
(
    id                INT,
	payment_Amount    INT,
	type              VARCHAR(10),
	id_hire_inventory INT UNIQUE,
	FOREIGN KEY (id_hire_inventory) REFERENCES Hire_Inventory (id),
)

CREATE TABLE Inventory_List
(
    id                INT PRIMARY KEY,
	id_inventory      INT UNIQUE,
	id_hire_inventory INT,
	FOREIGN KEY (id_inventory)      REFERENCES Inventory(id),
	FOREIGN KEY (id_hire_inventory) REFERENCES Hire_Inventory(id)

);




