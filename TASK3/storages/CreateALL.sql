USE Ikea;



CREATE TABLE Company
(
	id        INT PRIMARY KEY,    
	name      VARCHAR(20) UNIQUE,
	address   VARCHAR(20),
	telephone VARCHAR(20) UNIQUE
)

CREATE TABLE Storage
(
	id            INT PRIMARY KEY,
	name          VARCHAR(20),
	serial_number INT,
	address       VARCHAR(20),
	telephone     VARCHAR(20),
	id_company    INT,
	UNIQUE(name, id_company),
	FOREIGN KEY (id_company)  REFERENCES Company(id)
)

CREATE TABLE  Product
(
	id               INT PRIMARY KEY,
	name             VARCHAR(20) UNIQUE,
	price            VARCHAR(10),
	type             VARCHAR(15),
	date_manufacture DATE
); 

CREATE TABLE  Product_in_storage
(
    id           INT PRIMARY KEY,
    id_product   INT UNIQUE,
	id_storage   INT,
	date_arrival DATE,
    FOREIGN KEY (id_storage)  REFERENCES Storage (id),
	FOREIGN KEY (id_product)  REFERENCES Product (id)
);


CREATE TABLE Client
(
	id        INT PRIMARY KEY,
	name      VARCHAR(20),
	age       INT,
	telephone VARCHAR(20) UNIQUE
);

CREATE TABLE Order_history
(
    id                    INT PRIMARY KEY,
	id_client             INT,
	id_product_in_storage INT UNIQUE,
	date_order            DATE,
	FOREIGN KEY (id_client)              REFERENCES Client (id),
	FOREIGN KEY (id_product_in_storage)  REFERENCES Product_in_storage (id),
)



CREATE TABLE Payment
(
  id_order_history INT PRIMARY KEY REFERENCES Order_history (id),
  type             VARCHAR(10),
  payment_amount   INT
);



