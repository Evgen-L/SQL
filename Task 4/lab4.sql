USE Literature
--3.1 INSERT
--a
--INSERT INTO author VALUES (1, 'Peder Vparke', 35, '1986-02-01', 2)
INSERT INTO publishing_house VALUES (1, 'YOU MUST READ', 'Universal', 'Vosnesensk 3', '+79174670102'), 
									(2, 'Best books', 'Universal', 'Vosnesensk 4', '+79274670102'), 
									(3, 'Big books', 'Special', 'Snesensk 21', '+79374670102'),
									(4, 'No need to read', 'Special', 'Gadruchi', '+79374670111')
INSERT INTO publishing_house VALUES (9, '5 pages', 'Universal', 'New street', '+79344447011')

INSERT INTO author VALUES (1, 'Kan Dalinin', 20, '2001-02-02', 1)
INSERT INTO author VALUES (2, 'Legen Iakishev', 20, '2000-10-29', 2)

INSERT INTO copy_publishing_house VALUES (5, 'Lan', 'Special', 'Volshskai', '+79172270102'), 
									     (6, 'Lion', 'Universal', 'Vosnelit 79', '+79344670102'), 
									     (7, 'Small books', 'Special', 'Snesensk 23', '+79374670173'),
									     (8, 'Devil s book', 'Special', 'Demonsolsk', '666')

INSERT INTO store VALUES (1, 'Smart books','Retovo 37','88999888012'),
                         (2, 'Big Library','Retovo 38','88777888012'),
						 (3, 'World of books','Retovo 39','88666888000')

 						 

--b
INSERT INTO author (id_author, name, age, number_books, date_birthday) VALUES (3, 'Degor Rushinin', 35, 1, '1985-11-04')
INSERT INTO author (id_author, name, age, number_books, date_birthday) VALUES (4, 'Mukiva', 35, 1, '2001-07-22')
INSERT INTO author (id_author, name, age, number_books, date_birthday) VALUES (5, 'Lartem Ashmanov', 35, 1, '2000-11-01')
INSERT INTO book (id_book, name, id_author, genre, id_publh, publication_date) VALUES (1, 'Vesna Pridet...', 2, 'horror', 1, '2021-03-13')
INSERT INTO book (id_book, name, id_author, genre, id_publh, publication_date) VALUES (2, '...G. Vsplivet', 2, 'comedy', 2, '2021-03-14')
INSERT INTO book (id_book, name, id_author, genre, id_publh, publication_date) VALUES (3, 'Сollection of anecdotes', 1, 'comedy', 3, '2021-03-12')
INSERT INTO book (id_book, name, id_author, genre, id_publh, publication_date) VALUES (4, 'A guide to communication with boys', 3, 'male psychology', 4, '2021-03-12')
INSERT INTO book (id_book, name, id_author, genre, id_publh, publication_date) VALUES (5, 'A guide to seduce any girl', 4, 'female psychology', 2, '2021-03-10') 
INSERT INTO book (id_book, name, id_author, genre, id_publh, publication_date) VALUES (6, 'A guide not to seduce a girl', 5, 'female psychology', 2, '2021-03-10')

--for me
INSERT INTO book_in_store VALUES (1, 4), (1, 5), (1, 6), (2, 3), (2, 1), (2, 4), (2, 5)

--c
INSERT INTO publishing_house SELECT * FROM copy_publishing_house  

--3.2 DELETE
--a
DELETE FROM book

--b
DELETE FROM copy_publishing_house WHERE type = 'Special'


--3.3 UPDATE
--a
UPDATE copy_publishing_house SET name = 'bad book'

--b
UPDATE copy_publishing_house SET type = 'Special' WHERE type = 'Universal'

--c
UPDATE copy_publishing_house SET telephone = '89024567532', address = 'coper st.5' WHERE type = 'Special'

--3.4 SELECT
--a
SELECT id_author, name, age FROM author

--b
SELECT * FROM publishing_house

--c
SELECT name, genre, publication_date FROM book WHERE genre != 'horror'

--3.5 SELECT ORDER BY + TOP(LIMIT)
--a
SELECT TOP 2 name, age FROM author
ORDER BY age ASC

--b
SELECT name, age FROM author
ORDER BY age DESC

--c
SELECT TOP 2 name, age FROM author
ORDER BY name DESC, age ASC 

--d
SELECT name, age FROM author
ORDER BY name ASC 

--3.6 Работа с датами
--a
SELECT name, publication_date 
FROM book
WHERE publication_date = '2021-03-10'

--b
SELECT name, publication_date 
FROM book
WHERE publication_date BETWEEN '2021-03-10' AND '2021-03-12'

--c
SELECT name, YEAR(publication_date) AS year
FROM book

--3.7 Работа с агрегатными функциями
--a
SELECT COUNT(*) AS count_authors 
FROM author

--b
SELECT COUNT(DISTINCT genre) AS count_unique_genre FROM book 

--c
SELECT DISTINCT genre AS unique_genre FROM book 

--d
SELECT MAX(age) AS oldest_age_author FROM author

--e
SELECT MIN(age) AS youngest_age_author FROM author

--f
SELECT genre, COUNT(name) AS count_books FROM book
GROUP BY genre

--3.8 SELECT GROUP BY + HAVING
--Запрос находит все те жанры, которые попадаются во всех книгах больше 1 раза
SELECT genre, COUNT(name) AS count_books FROM book
GROUP BY genre
HAVING COUNT(name) > 1

--Запрос находит все тевозраста, которые встречаются менее 3 раз
SELECT age, COUNT(id_author) AS count_age FROM author
GROUP BY age
HAVING COUNT(id_author) IN (1, 2)

--Запрос находит все те Издательства, которые выпустили меньше 4 книг
SELECT publishing_house.name, COUNT(id_book) AS count_books FROM book JOIN publishing_house ON book.id_book = publishing_house.id_publh
GROUP BY publishing_house.name
HAVING COUNT(id_book) < 4

--3.9 SELECT JOIN
--LEFT JOIN
SELECT book.name, publishing_house.name FROM book LEFT JOIN publishing_house ON book.id_book = publishing_house.id_publh WHERE genre = 'comedy'

--RIGHT JOIN
SELECT book.name, publishing_house.name FROM publishing_house RIGHT JOIN book  ON book.id_book = publishing_house.id_publh WHERE genre = 'comedy'

--LEFT JOIN 3 tables
SELECT book_in_store.id_store, book_in_store.id_book, book.name AS name_book, publishing_house.name AS name_publ_house FROM book_in_store 
LEFT JOIN book ON  book_in_store.id_book = book.id_book 
LEFT JOIN publishing_house ON book.id_publh = publishing_house.id_publh
WHERE publishing_house.name = 'Best books'

--INNER JOIN
SELECT publishing_house.name, book.name FROM book JOIN publishing_house ON book.id_book = publishing_house.id_publh

--3.10 Подзапросы
--a
SELECT name FROM book
WHERE book.id_author IN (SELECT id_author FROM author WHERE age < 35)

--b
SELECT name, (SELECT COUNT(name) FROM book WHERE genre = 'comedy') AS count_comedy_books  FROM book

--c
SELECT * FROM (SELECT name, address, telephone FROM publishing_house WHERE type = 'Special') AS special_publishing_house

--d
SELECT * FROM book 
JOIN (SELECT name, address, telephone, id_publh FROM publishing_house WHERE type = 'Special') AS special_publishing_house ON book.id_publh = special_publishing_house.id_publh