USE Library;

CREATE TABLE library
(
	id        INT PRIMARY KEY,
	name      VARCHAR(20) NOT NULL,
	address   VARCHAR(20) NOT NULL,
	telephone VARCHAR(20) NOT NULL,
	email     VARCHAR(20) NOT NULL,
	UNIQUE (name, address)
)

CREATE TABLE author
(
    id            INT PRIMARY KEY NOT NULL, 
	name          VARCHAR(20) NOT NULL,
	age           DATE NOT NULL,
	date_birthday DATE NOT NULL,
	number_books  INT NOT NULL
)

CREATE TABLE  book
(
	id           INT PRIMARY KEY,
	name         VARCHAR(20) NOT NULL,
	price        MONEY NOT NULL,
	id_author    INT NOT NULL,
	genre        TINYINT NOT NULL,
	number_pages INT NOT NULL,
	UNIQUE(name, id_author),
	FOREIGN KEY (id_author)   REFERENCES author (id)
);

CREATE TABLE reader
(
	id        INT PRIMARY KEY,
	name      VARCHAR(20) NOT NULL,
	age       DATE NOT NULL,
	telephone VARCHAR(20) UNIQUE NOT NULL,
	gender    TINYINT NOT NULL
);


CREATE TABLE payment
(
    id                INT PRIMARY KEY NOT NULL,
	payment_amount    INT NOT NULL,
	type              TINYINT NOT NULL,
)

CREATE TABLE  issue_books
(
    id            INT PRIMARY KEY,
	id_reader     INT NOT NULL,
	purchase_date DATE NOT NULL,
	id_library    INT NOT NULL,
	id_payment    INT NOT NULL UNIQUE,
	UNIQUE (id_reader, purchase_date),
	FOREIGN KEY (id_library)   REFERENCES library (id),
	FOREIGN KEY (id_reader)    REFERENCES reader (id),
	FOREIGN KEY (id_payment)   REFERENCES payment (id),
);

CREATE TABLE book_x_issue
(
    id             INT PRIMARY KEY,
	id_book        INT UNIQUE NOT NULL,
	id_issue_books INT NOT NULL,
	FOREIGN KEY (id_book)        REFERENCES book(id),
	FOREIGN KEY (id_issue_books) REFERENCES issue_books(id)

);




