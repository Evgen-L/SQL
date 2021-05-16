CREATE DATABASE Task5;
USE Task5;


--Это задание 1 / This's task 1 
--добавить внешние ключи / Add foreign keys

--соединяю с промежуточной таблицей room_in_booking room и booking / connecting with the intermediate table room_in_booking room and booking
ALTER TABLE room_in_booking ADD 
                  FOREIGN KEY (id_room) 
                  REFERENCES room(id_room);

ALTER TABLE room_in_booking ADD   
                  FOREIGN KEY (id_booking) 
                  REFERENCES booking(id_booking);

--соединяю записную книжку с комнатой / connecting the notebook to the room				  
ALTER TABLE booking ADD 
                  FOREIGN KEY (id_client) 
                  REFERENCES client(id_client);

--соединяю комнату с отелем / connecting the room with the hotel
ALTER TABLE room ADD 
                  FOREIGN KEY (id_hotel) 
                  REFERENCES hotel(id_hotel);

--соединяю комнату с категорией комнаты / connecting a room to a room category				  
ALTER TABLE room ADD 
                  FOREIGN KEY (id_room_category) 
                  REFERENCES room_category(id_room_category);



--#2 Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г.
--   /
--   Issue information about the clients of the hotel "Cosmos" living in the rooms of the "Lux" category as of April 1, 2019.
SELECT phone, client.name 
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date > '2019-04-01'  ) AND (room_category.name = 'Люкс') AND (hotel.name = 'Космос')

--#3 Дать список свободных номеров всех гостиниц на 22 апреля. / Submit a list of available rooms of all hotels for April 22.
SELECT hotel.name AS hotel, room_category.name AS category, room.number, room_in_booking.checkin_date, room_in_booking.checkout_date
FROM booking 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE NOT((room_in_booking.checkin_date) <= '2019-04-22' AND room_in_booking.checkout_date > '2019-04-22')
ORDER BY room_in_booking.checkin_date

--#4 Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров / Give the number of people living in the Cosmos Hotel as of March 23 for each category of rooms                                                                                              
SELECT hotel.name AS hotel, room_category.name AS category, COUNT(client.name) AS Clients
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date <= '2019-03-23' AND room_in_booking.checkout_date > '2019-03-23'  ) AND (hotel.name = 'Космос')
GROUP BY room_category.name, hotel.name

--#5 Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда
--/
-- Provide a list of the last clients who stayed in all rooms of the Cosmos hotel who left in April, indicating the date of departure
drop view stud_in_apr
CREATE VIEW stud_in_apr AS
SELECT   room.number  AS room_number, MAX(room_in_booking.checkout_date) AS max_checkout_date
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (MONTH(room_in_booking.checkout_date) = '04') AND (hotel.name = 'Космос')
GROUP BY room.number
GO
Select * FROM stud_in_apr;
SELECT client.name AS Client, stud_in_apr.room_number, stud_in_apr.max_checkout_date
FROM room_in_booking
JOIN stud_in_apr  ON room_in_booking.checkout_date = stud_in_apr.max_checkout_date AND room_in_booking.id_room = stud_in_apr.room_number
JOIN booking ON room_in_booking.id_booking = booking.id_booking
JOIN client ON booking.id_client = client.id_client


--уникальный список комнат по последним датам проживания
--#6 Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая 
--  / 
--  Extend by 2 days the date of stay at the Cosmos Hotel for all clients of the Business rooms who checked in on May 10
SELECT client.name AS Client, room.number AS room_number, room_category.name AS category, room_in_booking.checkin_date, room_in_booking.checkout_date, hotel.name AS hotel
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date = '2019-05-10') AND (hotel.name = 'Космос') AND (room_category.name = 'Бизнес')
ORDER BY room_in_booking.checkout_date DESC

--добавить 2 дня к дате отъезда / add 2 days to the departure date
UPDATE room_in_booking 
SET checkout_date = DATEADD(day, 2, checkout_date)
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date = '2019-05-10') AND (hotel.name = 'Космос') AND (room_category.name = 'Бизнес')

--убрать 2 дня от даты отъезда / remove 2 days from the departure date
UPDATE room_in_booking
SET checkout_date = DATEADD(day, -2, checkout_date)
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE checkin_date = '2019-05-10'

--#7 Найти все "пересекающиеся" варианты проживания. 
--Правильное состояние: не может быть забронирован один номер на одну дату несколько раз, т.к. нельзя заселиться нескольким клиентам в один номер. 
--Записи в таблице room_in_booking с id_room_in_ booking = 5 и 2154 являются примером неправильного состояния, которые необходимо найти. 
--Результирующий кортеж выборки должен содержать информацию о двух конфликтующих номерах.
--/
--Find all overlapping accommodation options.
--Correct condition: one room cannot be booked for the same date several times, because several clients cannot be accommodated in one room.
--The entries in the room_in_booking table with id_room_in_booking = 5 and 2154 are examples of the wrong state to be found.
--The resulting selection tuple must contain information about the two conflicting numbers.


SELECT A.id_room_in_booking, A.id_booking, A.id_room, A.checkin_date, A.checkout_date, B.id_room_in_booking, B.id_booking, B.id_room, B.checkin_date, B.checkout_date 
FROM room_in_booking A 
JOIN room_in_booking B ON A.id_room = B.id_room
WHERE (A.id_room_in_booking != B.id_room_in_booking) AND ((A.checkin_date >= B.checkin_date AND A.checkin_date < B.checkout_date) OR ((A.checkout_date > B.checkin_date) AND (A.checkin_date < B.checkout_date)))

--#8 Создать бронирование в транзакции / Create a booking in a transaction
BEGIN TRANSACTION

INSERT INTO client VALUES ('Mushortov Vandex', '7(902)453-13-18')
INSERT INTO booking  VALUES (IDENT_CURRENT('client'), '2019-06-10'),
                            (IDENT_CURRENT('client'), '2019-12-05')
INSERT INTO room_in_booking VALUES (IDENT_CURRENT('booking'), 96, '2019-06-11', '2019-08-02'),
                                   (IDENT_CURRENT('booking'), 144, '2019-12-10', '2019-12-25')
                          
INSERT INTO client VALUES ('Vanshotov Mushort', '7(902)453-18-13')
INSERT INTO booking  VALUES (IDENT_CURRENT('client'), '2019-06-13'),
                            (IDENT_CURRENT('client'), '2019-12-23')
INSERT INTO room_in_booking VALUES (IDENT_CURRENT('booking'), 172, '2019-06-23', '2019-07-07'),
                                   (IDENT_CURRENT('booking'), 144, '2019-12-25', '2019-12-29')                                                                                                       
COMMIT
ROLLBACK

SELECT * FROM Client

SELECT * FROM booking
ORDER BY booking_date

SELECT * FROM room_in_booking
ORDER BY checkout_date

--#9 Добавить необходимые индексы для всех таблиц / Add required indexes for all tables
--client
CREATE UNIQUE NONCLUSTERED INDEX [IU_client_phone] ON
[client]
(
    [phone] 
)
INCLUDE ([name])

CREATE UNIQUE NONCLUSTERED INDEX [IU_client_name] ON
[client]
(
    [name] 
)
INCLUDE ([phone])

SELECT name, phone 
FROM client
WHERE name = 'Переверзев Онисим Никанорович'

--booking
CREATE NONCLUSTERED INDEX [IX_booking_booking_date] ON
[booking]
(
     [booking_date] ASC
)
INCLUDE ([id_client])

SELECT booking.id_client, client.name 
FROM booking JOIN client ON client.id_client = booking.id_client
WHERE booking.booking_date > '2019-01-15'

--room_in_booking
SELECT * FROM room_in_booking

CREATE NONCLUSTERED INDEX [IX_room_in_booking_checkin_date_checkout_date] ON
[room_in_booking]
(
   [checkin_date] ASC,
   [checkout_date] ASC
)

SELECT phone, client.name 
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date > '2019-04-01'  ) AND (room_category.name = 'Люкс')

--room
SELECT * FROM room
ORDER BY price

CREATE NONCLUSTERED INDEX [IX_room_price] ON
[room] 
(
    [price] ASC
)
INCLUDE ([number])

SELECT phone, client.name, room.number 
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date > '2019-04-01'  ) AND (room_category.name = 'Люкс') AND (room.price < 8000)

--room_category
CREATE NONCLUSTERED INDEX [IX_room_category_name] ON
[room_category]
(
   [name] ASC
)
INCLUDE ([square])

SELECT phone, client.name, room.number, square 
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date > '2019-04-01'  ) AND (room_category.name = 'Люкс')


CREATE NONCLUSTERED INDEX [IX_room_category_square] ON
[room_category]
(
   [square] ASC
)
INCLUDE ([name])

SELECT phone, client.name, room.number, room_category.name 
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE (room_category.square > 11)

--hotel
CREATE NONCLUSTERED INDEX [IX_hotel_stars] ON
[hotel]
(
   [stars] ASC
)
INCLUDE ([name])

SELECT phone, client.name, room.number, hotel.name, room_category.name 
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE (hotel.stars < 4)

CREATE NONCLUSTERED INDEX [IX_hotel_name] ON
[hotel]
(
   [name] ASC
)
INCLUDE ([stars])

SELECT client.name, phone, room.number
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE (hotel.name = 'Восход')