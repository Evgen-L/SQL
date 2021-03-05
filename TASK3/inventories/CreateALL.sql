USE MasterSport;

CREATE TABLE company
(
	id INT PRIMARY KEY,
	name  VARCHAR(20) NOT NULL,
	address VARCHAR(20) NOT NULL,
	telephone VARCHAR(20) NOT NULL
)


CREATE TABLE  inventory
(
	id    INT PRIMARY KEY,
	name  VARCHAR(20) UNIQUE NOT NULL,
	price MONEY NOT NULL,
	type  TINYINT NOT NULL
);

CREATE TABLE client
(
	id        INT PRIMARY KEY,
	name      VARCHAR(20) NOT NULL,
	age       DATE NOT NULL,
	telephone VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE  hire_inventory 
(
    id            INT PRIMARY KEY,
	id_client     INT NOT NULL,
	purchase_date DATE NOT NULL,
	id_company    INT NOT NULL,
	UNIQUE (id_client, purchase_date),
	FOREIGN KEY (id_company)   REFERENCES company (id),
	FOREIGN KEY (id_client)    REFERENCES client(id)
);


CREATE TABLE payment
(
    id                INT NOT NULL,
	payment_amount    INT NOT NULL,
	type              TINYINT NOT NULL,
	id_hire_inventory INT UNIQUE NOT NULL,
	FOREIGN KEY (id_hire_inventory) REFERENCES hire_inventory (id),
)

CREATE TABLE inventory_x_hire
(
    id                INT PRIMARY KEY,
	id_inventory      INT UNIQUE NOT NULL,
	id_hire_inventory INT NOT NULL,
	FOREIGN KEY (id_inventory)      REFERENCES inventory(id),
	FOREIGN KEY (id_hire_inventory) REFERENCES hire_Inventory(id)

);




