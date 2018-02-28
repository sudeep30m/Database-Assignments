
INSERT INTO student VALUES('2015CS50295' , 'Sudeep Agarwal');
INSERT INTO student VALUES('2015CS50296' , 'Surya Kalia');
INSERT INTO student VALUES('2015CS50278' , 'Ankur Sharma');
INSERT INTO student VALUES('2015CS50280' , 'Chakshu Goyal');
INSERT INTO student VALUES('2015CS50286' , 'Nikhil Goyal');

INSERT INTO course VALUES('COL380' , 'Distributed Computing');
INSERT INTO course VALUES('COL362' , 'Database Management' );
INSERT INTO course VALUES('COL331' , 'Operating System' );
INSERT INTO course VALUES('COL774' , 'Machine Learning');
INSERT INTO course VALUES('COL352' , 'Theory of Automata');
INSERT INTO course VALUES('COL202' , 'Discrete Mathematics');
INSERT INTO course VALUES('COL215' , 'Digital Logic');
INSERT INTO course VALUES('COL216' , 'Computer Architecture');
INSERT INTO course VALUES('COL106' , 'Data Structures');
INSERT INTO course VALUES('SIL765' , 'Network Security');
INSERT INTO course VALUES('COV884' , 'Uncertainity in AI');
INSERT INTO course VALUES('COL771' , 'NLP');

INSERT INTO teacher VALUES('1' , 'Parag Singla');
INSERT INTO teacher VALUES('2' , 'Mausam');
INSERT INTO teacher VALUES('3' , 'Sayan Ranu');
INSERT INTO teacher VALUES('4' , 'B.N. Jain');
INSERT INTO teacher VALUES('5' , 'Smruti Ranjan Sarangi');
INSERT INTO teacher VALUES('6' , 'Subodh Kumar Sharma');
INSERT INTO teacher VALUES('7' , 'Naveen Garg');
INSERT INTO teacher VALUES('8' , 'Amitabha Bagchi');
INSERT INTO teacher VALUES('9' , 'Anshul Kumar');
INSERT INTO teacher VALUES('10' ,'Saroj Kaushik');

INSERT INTO registers(student_id, course_id) VALUES('2015CS50296' , 'COL215');
INSERT INTO registers(student_id, course_id) VALUES('2015CS50296' , 'COL362' );
INSERT INTO registers(student_id, course_id) VALUES('2015CS50296' , 'COL331');
INSERT INTO registers(student_id, course_id) VALUES('2015CS50296' , 'COL380');
INSERT INTO registers(student_id, course_id) VALUES('2015CS50296' , 'COL774');
INSERT INTO registers(student_id, course_id) VALUES('2015CS50295' , 'COL362');
INSERT INTO registers(student_id, course_id) VALUES('2015CS50295' , 'COL331');
INSERT INTO registers(student_id, course_id) VALUES('2015CS50295' , 'COL380');
INSERT INTO registers(student_id, course_id) VALUES('2015CS50295' , 'COL774');
INSERT INTO registers(student_id, course_id) VALUES('2015CS50295' , 'COL215');


INSERT INTO teaches(course_id, teacher_id) VALUES('COL106' , '7');
INSERT INTO teaches(course_id, teacher_id) VALUES('COL106' , '8');
INSERT INTO teaches(course_id, teacher_id) VALUES('COL352' , '7');
INSERT INTO teaches(course_id, teacher_id) VALUES('COL202' , '8');
INSERT INTO teaches(course_id, teacher_id) VALUES('COL215' , '9');
INSERT INTO teaches(course_id, teacher_id) VALUES('COL216' , '9');
INSERT INTO teaches(course_id, teacher_id) VALUES('COL216' , '5');
INSERT INTO teaches(course_id, teacher_id) VALUES('COL331' , '5');

INSERT INTO section(section_number, course_id) VALUES('A', null);
INSERT INTO section(section_number, course_id) VALUES('A', 'COL106');
INSERT INTO section(section_number, course_id) VALUES('A', 'COL352');
INSERT INTO section(section_number, course_id) VALUES('B', 'COL362');
INSERT INTO section(section_number, course_id) VALUES('C', 'COL106');
INSERT INTO section(section_number, course_id) VALUES('D', 'COL106');

-- SELECT name from course;

SELECT course.name 
FROM (course natural join section) WHERE section_number = 'A';


SELECT course.name 
FROM (course natural join teaches) join teacher using (teacher_id) WHERE
    teacher.name = 'Naveen Garg' ; 

SELECT course.name 
FROM (course natural join teaches) join teacher using (teacher_id) WHERE
    teacher.name = 'Anshul Kumar' ; 

SELECT course.name 
FROM (course natural join registers) join student using (student_id) WHERE
    student.name = 'Sudeep Agarwal' ; 

DELETE from course where course_id = 'COL215'; 

SELECT course.name 
FROM (course natural join teaches) join teacher using (teacher_id) WHERE
    teacher.name = 'Anshul Kumar' ; 

SELECT course.name 
FROM (course natural join registers) join student using (student_id) WHERE
    student.name = 'Sudeep Agarwal' ; 

UPDATE course
SET name = 'Theory of Automata and Computation'
WHERE course_id = 'COL352'; 

SELECT course.name
FROM (course natural join teaches) join teacher using (teacher_id) WHERE
    teacher.name = 'Naveen Garg' ;

SELECT teacher.name
FROM (course natural join teaches) join teacher using (teacher_id) WHERE
    course.name = 'Data Structures' ;

DELETE from teacher where teacher.name = 'Amitabha Bagchi';

SELECT teacher.name
FROM (course natural join teaches) join teacher using (teacher_id) WHERE
    course.name = 'Data Structures';

SELECT * FROM teacher;
SELECT * FROM teaches;
DELETE FROM teaches where teaches.teacher_id = '9';
SELECT * FROM teacher;
SELECT * FROM teaches;

SELECT * FROM course;
UPDATE teaches 
SET course_id = 'COL107'
WHERE course_id = 'COL106'; 

SELECT * FROM course;

SELECT * FROM student;
UPDATE student 
SET student_id = '2015CS50296'
WHERE student_id = '2015CS50295'; 

SELECT * FROM student;

DELETE FROM course where course.course_id = 'COL106';
DELETE FROM course where course.course_id = 'COL380';
SELECT * FROM section
