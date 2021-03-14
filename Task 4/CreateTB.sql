USE Literature;

CREATE TABLE publishing_house
(
    id_publh  INT PRIMARY KEY,
	name      VARCHAR(30) UNIQUE NOT NULL,
	type      VARCHAR(30)        NOT NULL,
	address   VARCHAR(30)        NOT NULL,
	telephone VARCHAR(20) UNIQUE NOT NULL
)

CREATE TABLE author
(
    id_author     INT PRIMARY KEY,
	name          VARCHAR(30) UNIQUE NOT NULL,
	age           INT                NOT NULL,
	date_birthday DATE               NOT NULL,
	number_books  INT                NOT NULL
)

CREATE TABLE book
(
    id_book          INT PRIMARY KEY,
	name             VARCHAR(50)  NOT NULL,
	id_author        INT          NOT NULL,
	genre            VARCHAR(30),
	id_publh         INT,
	publication_date DATE,
	UNIQUE (name, id_author),
	FOREIGN KEY (id_publh)  REFERENCES publishing_house (id_publh),
	FOREIGN KEY (id_author) REFERENCES author (id_author)
)

CREATE TABLE store
(
    id_store  INT PRIMARY KEY,
	name      VARCHAR(30)  NOT NULL,
	address   VARCHAR(30)  NOT NULL,
	telephone VARCHAR(20) UNIQUE NOT NULL,
	UNIQUE (name, address)
)


CREATE TABLE book_in_store
(
    id_store  INT,
	id_book   INT,
	PRIMARY KEY(id_store, id_book),
	UNIQUE (id_store, id_book),
	FOREIGN KEY (id_store) REFERENCES store(id_store),
	FOREIGN KEY (id_book)  REFERENCES book(id_book)
)

CREATE TABLE director
(
    id_director INT PRIMARY KEY,
	name        VARCHAR(30) UNIQUE NOT NULL,
	position    VARCHAR(30)        NOT NULL,
	earnings    MONEY              NOT NULL,
	id_publh    INT                NOT NULL,
	UNIQUE(name, id_publh),
	FOREIGN KEY (id_publh)  REFERENCES publishing_house (id_publh)
)

CREATE TABLE copy_publishing_house
(
    id_publh  INT PRIMARY KEY,
	name      VARCHAR(30) UNIQUE NOT NULL,
	type      VARCHAR(30)        NOT NULL,
	address   VARCHAR(30)        NOT NULL,
	telephone VARCHAR(20) UNIQUE NOT NULL
)