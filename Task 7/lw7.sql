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
drop VIEW studet_mark_inf
CREATE VIEW studet_mark_inf AS
SELECT student.name AS student, mark.mark 
FROM mark
JOIN student ON mark.id_student = student.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE subject.name = N'Информатика'
GO

SELECT * FROM studet_mark_inf 


--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


--#3 Дать информацию о должниках с указанием фамилии студента и названия предмета. 
--Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе.
--Оформить в виде процедуры, на входе идентификатор группы.

--Provide information about debtors, indicating the name of the student and the title of the subject.
--Debtors are students who do not have a grade in a subject taught in a group.
--Issue as a procedure, at the entrance to the group identifier.

DROP PROCEDURE print_debtors
CREATE PROCEDURE print_debtors
@one_group nvarchar(50) 
AS
SELECT all_students.student, all_students.subject  FROM
	(SELECT DISTINCT student.id_student AS student_id, student.name AS student, lesson.id_subject AS subject_id, subject.name AS subject
	FROM lesson
	JOIN [group] ON lesson.id_group = [group].id_group
	JOIN student ON [group].id_group = student.id_group
	JOIN subject ON lesson.id_subject = subject.id_subject
	WHERE [group].name = @one_group) AS  all_students
LEFT JOIN (
	SELECT DISTINCT student.id_student AS student_id, lesson.id_subject AS subject_id
	FROM mark
	JOIN student ON mark.id_student = student.id_student
	JOIN lesson ON mark.id_lesson = lesson.id_lesson
	JOIN [group] ON lesson.id_group = [group].id_group
	WHERE [group].name = @one_group
) AS stud_with_marks ON all_students.student_id = stud_with_marks.student_id 
	AND all_students.subject_id = stud_with_marks.subject_id 

WHERE   stud_with_marks.student_id is NULL
GO


DECLARE @one_group nvarchar(50) = 'ВМ'
EXEC print_debtors @one_group


--#4 Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 35 студентов.
--Give an average student grade in each subject for those subjects in which at least 35 students are engaged.
SELECT subject.name AS subject, COUNT (DISTINCT student.name) AS quantity_students, AVG(mark.mark) AS average_mark
FROM lesson
JOIN [group] ON lesson.id_group = [group].id_group
JOIN student ON [group].id_group = student.id_group
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN mark ON mark.id_lesson = lesson.id_lesson
GROUP BY subject.name
HAVING  COUNT  (DISTINCT student.name) >= 35 

--#5 Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить значениями NULL поля оценки.
--To give assessments of students of the specialty VM in all subjects with an indication of the group, surname, subject, date. If there is no assessment, fill in the assessment fields with NULL values.

--LEFT(student_BM.id_student, CHARINDEX(' ', student_BM.id_student, 1)) AS surname_student
SELECT DISTINCT student.name AS student, [group].name AS 'group', subject.name AS subject, mark.mark, lesson.date --task itself
FROM lesson
JOIN [group] ON lesson.id_group = [group].id_group --вопрос, а на что ориентируется LEFT JOIN в синтаксисе, на название таблицы или на равенство? на равенство
JOIN student ON student.id_group = [group].id_group
JOIN subject ON lesson.id_subject = subject.id_subject
LEFT JOIN mark ON student.id_student = mark.id_student
WHERE [group].name = 'ВМ' 
ORDER BY mark.mark DESC, subject.name, lesson.date DESC


--#6 Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05, повысить эти оценки на 1 балл.
--All students of the specialty PS, who received grades less than 5 in the subject of DB before 12.05, increase these grades by 1 point.
CREATE VIEW student_PS AS
SELECT student.name AS student, student.id_student, [group].name AS 'group'--all students from PS group
FROM student
JOIN [group] ON student.id_group = [group].id_group 
WHERE [group].name = 'ПС'
GO

--the log of visits of the PS group on the subject of Data Base before 12.05.2019
SELECT student,  [group], subject.name, mark.mark, lesson.date
FROM student_PS
LEFT JOIN mark ON student_PS.id_student = mark.id_student
JOIN lesson ON lesson.id_lesson = mark.id_lesson 
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE (subject.name = 'БД') AND (lesson.date < '2019-05-12')
ORDER BY lesson.date

DROP VIEW log_visits_PS_DB
CREATE VIEW log_visits_PS_DB AS
SELECT student,  [group], subject.name AS subject_name, mark.mark AS mark, lesson.date AS lesson_date
FROM student_PS
LEFT JOIN mark ON student_PS.id_student = mark.id_student
JOIN lesson ON lesson.id_lesson = mark.id_lesson 
JOIN subject ON lesson.id_subject = subject.id_subject
WHERE (subject.name = 'БД')
GO

UPDATE  log_visits_PS_DB
SET mark = mark + 1
WHERE (mark) < 5 AND (lesson_date < '2019-05-12')

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
ORDER BY mark.id_student, mark.id_lesson ASC
SELECT * FROM subject
SELECT * FROM student