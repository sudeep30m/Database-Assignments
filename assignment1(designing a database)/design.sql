DROP TABLE IF EXISTS teaches;
DROP TABLE IF EXISTS registers;
DROP TABLE IF EXISTS section;
DROP TYPE IF EXISTS section_enum;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS teacher;


CREATE TYPE section_enum AS ENUM ('A', 'B', 'C', 'D');

CREATE TABLE IF NOT EXISTS student(
    student_id VARCHAR(255) NOT NULL UNIQUE PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS course(
    course_id VARCHAR(255) NOT NULL UNIQUE PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS teacher(
    teacher_id VARCHAR(255) NOT NULL UNIQUE PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);


CREATE TABLE IF NOT EXISTS teaches(
    teacher_id VARCHAR(255) NOT NULL ,
    course_id VARCHAR(255) NOT NULL ,
    PRIMARY KEY (teacher_id, course_id), 
    CONSTRAINT teaches_teacher_constraint
        FOREIGN KEY (teacher_id)
        REFERENCES teacher(teacher_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT teaches_course_constraint
        FOREIGN KEY (course_id)
        REFERENCES course(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS registers(
    student_id VARCHAR(255) NOT NULL,
    course_id VARCHAR(255) NOT NULL, 
    PRIMARY KEY (student_id, course_id)
    -- CONSTRAINT registers_student_constraint
    --     FOREIGN KEY (student_id)
    --     REFERENCES student(student_id)
    --     ON DELETE CASCADE
    --     ON UPDATE CASCADE,

    -- CONSTRAINT registers_course_constraint
    --     FOREIGN KEY (course_id)
    --     REFERENCES course(course_id)
    --     ON DELETE CASCADE
    --     ON UPDATE CASCADE
        
);

CREATE TABLE IF NOT EXISTS section(
    section_number section_enum NOT NULL UNIQUE PRIMARY KEY,
    course_id VARCHAR(255) NOT NULL, 
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

