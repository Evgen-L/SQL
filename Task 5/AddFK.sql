CREATE DATABASE Task5;
USE Task5;


--Это задание 1 
--соединяю с промежуточной таблицей room_in_booking room и booking
ALTER TABLE room_in_booking ADD 
                  FOREIGN KEY (id_room) 
                  REFERENCES room(id_room);


ALTER TABLE room_in_booking ADD   
                  FOREIGN KEY (id_booking) 
                  REFERENCES booking(id_booking);

--соединяю записную книжку с комнатой				  
ALTER TABLE booking ADD 
                  FOREIGN KEY (id_client) 
                  REFERENCES client(id_client);

--соединяю комнату с отелем
ALTER TABLE room ADD 
                  FOREIGN KEY (id_hotel) 
                  REFERENCES hotel(id_hotel);

--соединяю комнату с категорией комнаты				  
ALTER TABLE room ADD 
                  FOREIGN KEY (id_room_category) 
                  REFERENCES room_category(id_room_category);



--#2 Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г.
SELECT phone, client.name 
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date > '2019-04-01'  ) AND (room_category.name = 'Люкс') AND (hotel.name = 'Космос')

--#3 Дать список свободных номеров всех гостиниц на 22 апреля.
SELECT hotel.name AS hotel, room_category.name AS category, room.number
FROM booking 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE DAY(booking.booking_date) != '22' AND MONTH(booking.booking_date) != '04'

--#4 Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров                                                                                              
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
SELECT TOP 50 client.name AS Client, room.number AS room_number, room_category.name AS category, room_in_booking.checkout_date, hotel.name AS hotel  
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (MONTH(room_in_booking.checkout_date) = '04') AND (hotel.name = 'Космос')
ORDER BY room_in_booking.checkout_date DESC

--#6 Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая
SELECT client.name AS Client, room.number AS room_number, room_category.name AS category, room_in_booking.checkin_date, room_in_booking.checkout_date, hotel.name AS hotel
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date = '2019-05-10') AND (hotel.name = 'Космос') AND (room_category.name = 'Бизнес')
ORDER BY room_in_booking.checkout_date DESC

--добавить 2 дня к дате отъезда
UPDATE room_in_booking 
SET checkout_date = DATEADD(day, 2, checkout_date)
WHERE checkin_date = '2019-05-10'

--убрать 2 дня от даты отъезда
UPDATE room_in_booking
SET checkout_date = DATEADD(day, -2, checkout_date)
WHERE checkin_date = '2019-05-10'

--#7 Найти все "пересекающиеся" варианты проживания. 
--Правильное состояние: не может быть забронирован один номер на одну дату несколько раз, т.к. нельзя заселиться нескольким клиентам в один номер. 
--Записи в таблице room_in_booking с id_room_in_ booking = 5 и 2154 являются примером неправильного состояния, которые необходимо найти. 
--Результирующий кортеж выборки должен содержать информацию о двух конфликтующих номерах.

SELECT A.id_room_in_booking, A.id_booking, A.id_room, A.checkin_date, A.checkout_date, B.id_room_in_booking, B.id_booking, B.id_room, B.checkin_date, B.checkout_date 
FROM room_in_booking A 
JOIN room_in_booking B ON A.id_room = B.id_room
WHERE (A.id_room_in_booking != B.id_room_in_booking) AND ((A.checkin_date >= B.checkin_date AND A.checkin_date < B.checkout_date) OR (A.checkout_date > B.checkin_date))           

--#8 Создать бронирование в транзакции