CREATE DATABASE Task5;
USE Task5;


--��� ������� 1 
--�������� � ������������� �������� room_in_booking room � booking
ALTER TABLE room_in_booking ADD 
                  FOREIGN KEY (id_room) 
                  REFERENCES room(id_room);


ALTER TABLE room_in_booking ADD   
                  FOREIGN KEY (id_booking) 
                  REFERENCES booking(id_booking);

--�������� �������� ������ � ��������				  
ALTER TABLE booking ADD 
                  FOREIGN KEY (id_client) 
                  REFERENCES client(id_client);

--�������� ������� � ������
ALTER TABLE room ADD 
                  FOREIGN KEY (id_hotel) 
                  REFERENCES hotel(id_hotel);

--�������� ������� � ���������� �������				  
ALTER TABLE room ADD 
                  FOREIGN KEY (id_room_category) 
                  REFERENCES room_category(id_room_category);



--#2 ������ ���������� � �������� ��������� �������, ����������� � ������� ��������� ����� �� 1 ������ 2019�.
SELECT phone, client.name 
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date > '2019-04-01'  ) AND (room_category.name = '����') AND (hotel.name = '������')

--#3 ���� ������ ��������� ������� ���� �������� �� 22 ������.
SELECT hotel.name AS hotel, room_category.name AS category, room.number
FROM booking 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE DAY(booking.booking_date) != '22' AND MONTH(booking.booking_date) != '04'

--#4 ���� ���������� ����������� � ��������� ������� �� 23 ����� �� ������ ��������� �������                                                                                              
SELECT hotel.name AS hotel, room_category.name AS category, COUNT(client.name) AS Clients
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date <= '2019-03-23' AND room_in_booking.checkout_date > '2019-03-23'  ) AND (hotel.name = '������')
GROUP BY room_category.name, hotel.name

--#5 ���� ������ ��������� ����������� �������� �� ���� �������� ��������� �������, ��������� � ������ � ��������� ���� ������
SELECT TOP 50 client.name AS Client, room.number AS room_number, room_category.name AS category, room_in_booking.checkout_date, hotel.name AS hotel  
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (MONTH(room_in_booking.checkout_date) = '04') AND (hotel.name = '������')
ORDER BY room_in_booking.checkout_date DESC

--#6 �������� �� 2 ��� ���� ���������� � ��������� ������� ���� �������� ������ ��������� �������, ������� ���������� 10 ���
SELECT client.name AS Client, room.number AS room_number, room_category.name AS category, room_in_booking.checkin_date, room_in_booking.checkout_date, hotel.name AS hotel
FROM client 
JOIN booking ON client.id_client = booking.id_client 
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE  (room_in_booking.checkin_date = '2019-05-10') AND (hotel.name = '������') AND (room_category.name = '������')
ORDER BY room_in_booking.checkout_date DESC

--�������� 2 ��� � ���� �������
UPDATE room_in_booking 
SET checkout_date = DATEADD(day, 2, checkout_date)
WHERE checkin_date = '2019-05-10'

--������ 2 ��� �� ���� �������
UPDATE room_in_booking
SET checkout_date = DATEADD(day, -2, checkout_date)
WHERE checkin_date = '2019-05-10'

--#7 ����� ��� "��������������" �������� ����������. 
--���������� ���������: �� ����� ���� ������������ ���� ����� �� ���� ���� ��������� ���, �.�. ������ ���������� ���������� �������� � ���� �����. 
--������ � ������� room_in_booking � id_room_in_ booking = 5 � 2154 �������� �������� ������������� ���������, ������� ���������� �����. 
--�������������� ������ ������� ������ ��������� ���������� � ���� ������������� �������.

SELECT A.id_room_in_booking, A.id_booking, A.id_room, A.checkin_date, A.checkout_date, B.id_room_in_booking, B.id_booking, B.id_room, B.checkin_date, B.checkout_date 
FROM room_in_booking A 
JOIN room_in_booking B ON A.id_room = B.id_room
WHERE (A.id_room_in_booking != B.id_room_in_booking) AND ((A.checkin_date >= B.checkin_date AND A.checkin_date < B.checkout_date) OR (A.checkout_date > B.checkin_date))           

--#8 ������� ������������ � ����������
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





