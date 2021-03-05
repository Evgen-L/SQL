USE Ikea;



CREATE TABLE company
(
	id        INT PRIMARY KEY,    
	name      VARCHAR(20) UNIQUE NOT NULL,
	address   VARCHAR(20) NOT NULL,
	telephone VARCHAR(20) UNIQUE NOT NULL,
)

CREATE TABLE storage
(
	id            INT PRIMARY KEY,
	name          VARCHAR(20) NOT NULL,
	serial_number INT NOT NULL,
	address       VARCHAR(20) NOT NULL,
	telephone     VARCHAR(20) NOT NULL,
	id_company    INT NOT NULL,
	UNIQUE(name, id_company),
	FOREIGN KEY (id_company)  REFERENCES company(id)
)

CREATE TABLE  product
(
	id               INT PRIMARY KEY,
	name             VARCHAR(20) UNIQUE NOT NULL,
	price            MONEY NOT NULL,
	type             TINYINT NOT NULL,
	date_manufacture DATE NOT NULL
); 

CREATE TABLE  product_in_storage
(
    id           INT PRIMARY KEY,
    id_product   INT UNIQUE NOT NULL,
	id_storage   INT NOT NULL,
	date_arrival DATE NOT NULL,
    FOREIGN KEY (id_storage)  REFERENCES storage (id),
	FOREIGN KEY (id_product)  REFERENCES product (id)
);

CREATE TABLE product_x_storage
(
    id                    INT PRIMARY KEY,
	id_product            INT UNIQUE NOT NULL,
	id_product_in_storage INT NOT NULL,
	FOREIGN KEY (id_product)            REFERENCES product(id),
	FOREIGN KEY (id_product_in_storage) REFERENCES product_in_storage(id)
)




CREATE TABLE client
(
	id        INT PRIMARY KEY,
	name      VARCHAR(20) NOT NULL,
	age       DATE NOT NULL,
	telephone VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE orderH
(
    id                    INT PRIMARY KEY,
	id_client             INT NOT NULL,
	id_product_in_storage INT UNIQUE NOT NULL,
	date_order            DATE NOT NULL,
	FOREIGN KEY (id_client)              REFERENCES client (id),
	FOREIGN KEY (id_product_in_storage)  REFERENCES product_in_storage (id),
)



CREATE TABLE payment
(
  id_order_history INT PRIMARY KEY REFERENCES orderH (id),
  type             TINYINT,
  payment_amount   INT
);



