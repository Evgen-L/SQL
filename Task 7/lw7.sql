CREATE DATABASE university;
USE university;


--#1 Add FK's
 ALTER TABLE student ADD
	 FOREIGN KEY (id_group)
	 REFERENCES [group](id_group)

ALTER TABLE lesson ADD
    FOREIGN KEY (id_teacher)
	REFERENCES teacher(id_teacher)

ALTER TABLE lesson ADD
    FOREIGN KEY (id_subject)
	REFERENCES subject(id_subject)

ALTER TABLE lesson ADD
    FOREIGN KEY (id_group)
	REFERENCES [group](id_group)

ALTER TABLE mark ADD
    FOREIGN KEY (id_lesson)
	REFERENCES lesson(id_lesson)

ALTER TABLE mark ADD
    FOREIGN KEY (id_student)
	REFERENCES student(id_student)


--#2 ������ ������ ��������� �� ����������� ���� ��� ��������� ������� ��������. �������� ������ ������ � �������������� view.
CREATE VIEW studet_mark_inf AS
SELECT student.name AS student, mark.mark 
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE subject.name = '�����������'
GO

SELECT * FROM studet_mark_inf 


--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


--#3
--�� ���� ����� �������� ��� ���������:

--��������� ���������, �� ������� ������ ������ �������� ������������ ������ (1)
SELECT DISTINCT subject.id_subject, subject.name AS subject
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
WHERE [group].name = '��' 

--��������� ��������� ������������ ������ � ������� �� ������� ��� �������� ������ ������ (2)
SELECT LEFT(student.name, CHARINDEX(' ', student.name, 1)) AS student, subject_group.name AS subject
FROM student
JOIN (SELECT DISTINCT subject.id_subject, subject.name 
	  FROM mark
	  JOIN student ON mark.id_student = student.id_student
	  JOIN lesson ON mark.id_lesson = lesson.id_lesson
	  JOIN subject ON lesson.id_subject = subject.id_subject
	  JOIN [group] ON lesson.id_group = [group].id_group
	  WHERE [group].name = '��') AS subject_group 
ON student.id_student = subject_group.id_subject OR student.id_student != subject_group.id_subject
JOIN [group] ON student.id_group = [group].id_group  
WHERE [group].name = '��'
ORDER BY student.name

--��������� �� ������� id �������� ������������ ������ � id �������� �� ������� ���� ������� ����� (3)
 SELECT student.id_student AS student_id, subject.id_subject AS subject_id
	  FROM mark
	  JOIN student ON mark.id_student = student.id_student
	  JOIN lesson ON mark.id_lesson = lesson.id_lesson
	  JOIN subject ON lesson.id_subject = subject.id_subject
	  JOIN [group] ON lesson.id_group = [group].id_group
	  WHERE [group].name = '��'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE print_debtors
CREATE PROCEDURE print_debtors
@one_group nvarchar(50) 
AS
SELECT student_subject_of_group.student, student_subject_of_group.subject 
FROM 
(
	SELECT student.id_student, subject_group.id_subject, student.name AS student, subject_group.name AS subject
	FROM student
	JOIN (SELECT DISTINCT subject.id_subject, subject.name 
		  FROM mark
		  JOIN student ON mark.id_student = student.id_student
		  JOIN lesson ON mark.id_lesson = lesson.id_lesson
		  JOIN subject ON lesson.id_subject = subject.id_subject
		  JOIN [group] ON lesson.id_group = [group].id_group
		  WHERE [group].name = @one_group) AS subject_group 
	ON student.id_student = subject_group.id_subject OR student.id_student != subject_group.id_subject
	JOIN [group] ON student.id_group = [group].id_group  
	WHERE [group].name = @one_group
) AS student_subject_of_group

WHERE NOT EXISTS ( SELECT * FROM (
									  SELECT student.id_student AS student_id, subject.id_subject AS subject_id --(3)
									  FROM mark
									  JOIN student ON mark.id_student = student.id_student
									  JOIN lesson ON mark.id_lesson = lesson.id_lesson
									  JOIN subject ON lesson.id_subject = subject.id_subject
									  JOIN [group] ON lesson.id_group = [group].id_group
									  WHERE [group].name = @one_group
								  ) AS  book_visits_of_certain_group
					WHERE	student_subject_of_group.id_student = book_visits_of_certain_group.student_id AND	student_subject_of_group.id_subject = book_visits_of_certain_group.subject_id
				 )
ORDER BY student_subject_of_group.subject
GO

DECLARE @one_group nvarchar(50) = '���'
EXEC print_debtors @one_group
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--�����, ����� ����������, ��� �� ��� �����
SELECT student.name AS student, [group].name AS 'group', subject.name AS subject, mark.mark, date 
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
ORDER BY [group], subject, date
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


--#4 ���� ������� ������ ��������� �� ������� �������� ��� ��� ���������, �� ������� ���������� �� ����� 35 ���������.
SELECT subject.name AS subject, AVG(mark.mark) AS average_mark
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
GROUP BY subject.name
HAVING COUNT(DISTINCT student.name) >= 35

--#5 ���� ������ ��������� ������������� �� �� ���� ���������� ��������� � ��������� ������, �������, ��������, ����. ��� ���������� ������ ��������� ���������� NULL ���� ������.
DROP VIEW student_BM 
CREATE VIEW student_BM AS
SELECT student.name AS student, student.id_student, [group].name AS 'group'
FROM student
JOIN [group] ON student.id_group = [group].id_group 
WHERE [group].name = '��'
GO


SELECT * FROM student_BM
 
SELECT student, LEFT(student, CHARINDEX(' ', student, 1)) AS surname_student, [group], subject.name, mark.mark, lesson.date
FROM student_BM
LEFT JOIN mark ON student_BM.id_student = mark.id_student
LEFT JOIN lesson ON mark.id_lesson = lesson.id_lesson 
LEFT JOIN subject ON lesson.id_subject = subject.id_subject


--#6 ���� ��������� ������������� ��, ���������� ������ ������� 5 �� �������� �� �� 12.05, �������� ��� ������ �� 1 ����.
CREATE VIEW student_PS AS
SELECT student.name AS student, student.id_student, [group].name AS 'group'
FROM student
JOIN [group] ON student.id_group = [group].id_group 
WHERE [group].name = '��'
GO

SELECT student,  [group], subject.name, mark.mark, lesson.date
FROM student_PS
JOIN mark ON student_PS.id_student = mark.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson 
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE (subject.name = '��') AND (lesson.date < '2019-05-12')
ORDER BY lesson.date

CREATE VIEW book_student_PS AS
SELECT mark.id_mark
FROM student_PS
JOIN mark ON student_PS.id_student = mark.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson 
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE (subject.name = '��') AND (lesson.date < '2019-05-12')
GO

UPDATE mark 
SET mark.mark = mark.mark + 1
WHERE mark.mark < 5

--#7 Add required indexes.
--student
CREATE UNIQUE NONCLUSTERED INDEX [IU_student_name] ON
[student]
(
    [name] 
)
INCLUDE ([phone])

CREATE UNIQUE NONCLUSTERED INDEX [IU_student_phone] ON
[student]
(
    [phone] 
)
INCLUDE ([name])


--mark
CREATE NONCLUSTERED INDEX [IX_mark_mark] ON
[mark]
(
   [mark] ASC
)


--teacher
CREATE UNIQUE NONCLUSTERED INDEX [IU_teacher_name] ON
[teacher]
(
    [name] 
)
INCLUDE ([phone])

CREATE UNIQUE NONCLUSTERED INDEX [IU_teacher_phone] ON
[teacher]
(
    [phone] 
)
INCLUDE ([name])

--lesson
CREATE NONCLUSTERED INDEX [IX_lesson_date] ON
[lesson]
(
   [date] ASC
)


SELECT * FROM [group]
SELECT * FROM lesson
SELECT * FROM mark
SELECT * FROM subject
SELECT * FROM student