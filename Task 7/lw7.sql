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
--Give grades to computer science students if they are studying a given subject. Checkout data output using view.
CREATE VIEW studet_mark_inf AS
SELECT student.name AS student, mark.mark 
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE subject.name = 'Информатика'
GO

SELECT * FROM studet_mark_inf 


--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


--#3 Дать информацию о должниках с указанием фамилии студента и названия предмета. 
--Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе.
--Оформить в виде процедуры, на входе идентификатор группы.

--Provide information about debtors, indicating the name of the student and the title of the subject.
--Debtors are students who do not have a grade in a subject taught in a group.
--Issue as a procedure, at the entrance to the group identifier.


--Из чего будет состоять процедура:
--What the procedure will consist of:

--получение предметов, на которые должны ходить студенты определенной группы (1)
--getting items that students of a certain group should attend (1)
SELECT DISTINCT subject.id_subject, subject.name AS subject
FROM lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
WHERE [group].name = 'ПС' 


--получение студентов определенной группы и занятий на которые эти студенты должны ходить (2)
--getting students of a certain group and classes to which these students should go (2)
SELECT student.name AS student, subject_group.subject AS subject
FROM student
JOIN (
		SELECT DISTINCT subject.id_subject, subject.name AS subject --(1)
		FROM lesson
		JOIN subject ON lesson.id_subject = subject.id_subject
		JOIN [group] ON lesson.id_group = [group].id_group
		WHERE [group].name = 'ПС'-------------------------------------(/1)
     ) AS subject_group 
ON student.id_student = subject_group.id_subject OR student.id_student != subject_group.id_subject
JOIN [group] ON student.id_group = [group].id_group  
WHERE [group].name = 'ПС' 


--получение из журнала id студента определенной группы и id предмета на которые этот студент ходил (3)
--obtaining from the journal the id of a student of a certain group and the id of the subject to which this student went (3)
SELECT student.id_student AS student_id, lesson.id_subject AS subject_id
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN [group] ON lesson.id_group = [group].id_group
WHERE [group].name = 'ПС'


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--task
DROP PROCEDURE print_debtors
CREATE PROCEDURE print_debtors
@one_group nvarchar(50) 
AS
SELECT LEFT(student_subject_of_group.student, CHARINDEX(' ', student_subject_of_group.student, 1)) AS student, student_subject_of_group.subject 
FROM 
(
	SELECT student.id_student AS student_id,subject_group.id_subject AS subject_id, student.name AS student, subject_group.subject AS subject----------(2)
	FROM student
	JOIN (
			SELECT DISTINCT subject.id_subject, subject.name AS subject --(1)
			FROM lesson
			JOIN subject ON lesson.id_subject = subject.id_subject
			JOIN [group] ON lesson.id_group = [group].id_group
			WHERE [group].name = @one_group-------------------------------(/1)
		 ) AS subject_group 
	ON student.id_student = subject_group.id_subject OR student.id_student != subject_group.id_subject
	JOIN [group] ON student.id_group = [group].id_group  
	WHERE [group].name = @one_group----------------------------------------------------------------------------------------------------------------------(/2)
	
) AS student_subject_of_group
WHERE NOT EXISTS ( SELECT * FROM (
									    SELECT student.id_student AS student_id, lesson.id_subject AS subject_id --(3)
										FROM mark
										JOIN student ON mark.id_student = student.id_student
										JOIN lesson ON mark.id_lesson = lesson.id_lesson
										JOIN [group] ON lesson.id_group = [group].id_group
										WHERE [group].name = @one_group--------------------------------------------(/3)
								  ) AS  book_visits_of_certain_group
					WHERE	student_subject_of_group.student_id = book_visits_of_certain_group.student_id AND student_subject_of_group.subject_id = book_visits_of_certain_group.subject_id
				 )
ORDER BY student_subject_of_group.subject
GO

DECLARE @one_group nvarchar(50) = 'ПС'
EXEC print_debtors @one_group
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--посмотреть, кто на какие предметы приходил по определенной группе
--see who came to what subjects for a certain group
SELECT student.name AS student, [group].name AS 'group', subject.name AS subject, mark.mark, date 
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
WHERE [group].name = @one_group
ORDER BY [group], subject, date
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


--#4 Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 35 студентов.
--Give an average student grade in each subject for those subjects in which at least 35 students are engaged.
SELECT subject.name AS subject, AVG(mark.mark) AS average_mark
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN [group] ON lesson.id_group = [group].id_group
GROUP BY subject.name
HAVING COUNT(DISTINCT student.name) >= 35

--#5 Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить значениями NULL поля оценки.
--To give assessments of students of the specialty VM in all subjects with an indication of the group, surname, subject, date. If there is no assessment, fill in the assessment fields with NULL values.
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
--All students of the specialty PS, who received grades less than 5 in the subject of DB before 12.05, increase these grades by 1 point.
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


SELECT * FROM [group]
SELECT * FROM lesson
SELECT * FROM mark
SELECT * FROM subject
SELECT * FROM student