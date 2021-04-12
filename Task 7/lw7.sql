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


--#2 Выдать оценки студентов по информатике если они обучаются данному предмету. Оформить выдачу данных с использованием view.
CREATE VIEW studet_mark_inf AS
SELECT student.name AS student, mark.mark 
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE subject.name = 'Информатика'
GO

SELECT * FROM studet_mark_inf 


--#3

CREATE PROCEDURE print_debtors
@one_group nvarchar(50) 
AS
SELECT student.name, subject.name
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
WHERE ([group].name =  @one_group)--mark.mark = NULL
GO

ALTER PROCEDURE print_debtors
@one_group nvarchar(50) 
AS
SELECT LEFT(student.name, CHARINDEX(' ', student.name, 1)) AS surname_student, subject.name AS subject, [group].name
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
WHERE ([group].name =  @one_group) AND (mark.mark IS NULL)--mark.mark = NULL
GO

DECLARE @one_group nvarchar(50) = 'ПС'
EXEC print_debtors 'ПС'




SELECT student.name AS student, [group].name AS 'group', subject.name AS subject, mark.mark, date 
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
ORDER BY [group], subject, date

SELECT * FROM [group]
SELECT * FROM lesson
SELECT * FROM mark
SELECT * FROM subject
SELECT * FROM student



--#4 Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 35 студентов.
SELECT subject.name AS subject, AVG(mark.mark) AS average_mark
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
GROUP BY subject.name
HAVING COUNT(DISTINCT student.name) >= 35

--#5 Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить значениями NULL поля оценки.
DROP VIEW student_BM 
CREATE VIEW student_BM AS
SELECT student.name AS student, student.id_student, [group].name AS 'group'
FROM student
JOIN [group] ON student.id_group = [group].id_group 
WHERE [group].name = 'ВМ'
GO


SELECT * FROM student_BM
 
SELECT student, LEFT(student, CHARINDEX(' ', student, 1)) AS surname_student, [group], subject.name, mark.mark, lesson.date
FROM student_BM
LEFT JOIN mark ON student_BM.id_student = mark.id_student
LEFT JOIN lesson ON mark.id_lesson = lesson.id_lesson 
LEFT JOIN subject ON lesson.id_subject = subject.id_subject


--#6 Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05, повысить эти оценки на 1 балл.
CREATE VIEW student_PS AS
SELECT student.name AS student, student.id_student, [group].name AS 'group'
FROM student
JOIN [group] ON student.id_group = [group].id_group 
WHERE [group].name = 'ПС'
GO

SELECT student,  [group], subject.name, mark.mark, lesson.date
FROM student_PS
JOIN mark ON student_PS.id_student = mark.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson 
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE (subject.name = 'БД') AND (lesson.date < '2019-05-12')
ORDER BY lesson.date

CREATE VIEW book_student_PS AS
SELECT mark.id_mark
FROM student_PS
JOIN mark ON student_PS.id_student = mark.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson 
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE (subject.name = 'БД') AND (lesson.date < '2019-05-12')
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
