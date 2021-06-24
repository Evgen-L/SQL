CREATE DATABASE medicine
USE medicine

CREATE TABLE drug
(
	id_drug INT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	type TINYINT NOT NULL,
	cure_duration INT NOT NULL,
	country VARCHAR(20) NOT NULL,
	UNIQUE(name, type, country)
)

CREATE TABLE disease --болезнь
(
	id_disease INT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	incubation_period INT NOT NULL,
	duration_illness INT NOT NULL,
	type TINYINT NOT NULL
	UNIQUE(name, type)
)

CREATE TABLE sick --больной
(
	id_sick INT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	age DATE NOT NULL,
	telephone VARCHAR(20) NOT NULL,
	insurance_number INT UNIQUE NOT NULL,
	blood_type TINYINT NOT NULL,
	UNIQUE (name, insurance_number)
)

CREATE TABLE doctor --доктор
(
	id_doctor INT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	age DATE NOT NULL,
	specialty TINYINT NOT NULL,
	telephone VARCHAR(20) NOT NULL,
	education VARCHAR(20) NOT NULL,
	UNIQUE(name, age, telephone)
)

CREATE TABLE contraindications --противопоказания
(
	id_contraindications INT PRIMARY KEY,
	id_sick INT NOT NULL,
	id_drug INT NOT NULL,
	FOREIGN KEY (id_sick) REFERENCES sick (id_sick),
	FOREIGN KEY (id_drug) REFERENCES drug (id_drug),
	UNIQUE (id_sick, id_drug)
)

CREATE TABLE destination --назначения
(
	id_destination INT PRIMARY KEY,
	id_sick INT NOT NULL,
	id_drug INT NOT NULL,
	id_disease INT NOT NULL,
	id_doctor INT NOT NULL,
	destination_date DATE NOT NULL,
	period_destination INT NOT NULL,
	FOREIGN KEY (id_sick) REFERENCES sick (id_sick),
	FOREIGN KEY (id_drug) REFERENCES drug (id_drug),
	FOREIGN KEY (id_disease) REFERENCES disease (id_disease),
	FOREIGN KEY (id_doctor) REFERENCES doctor (id_doctor),
	UNIQUE(id_destination, id_sick, id_disease, destination_date, id_drug)
)