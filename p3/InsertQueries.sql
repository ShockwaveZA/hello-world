INSERT INTO Uni.DegreeProgram VALUES
    (nextval('uni.degreeseq'), 'BSc', 'Bachelor of Science', 3, 'EBIT'),
    (nextval('uni.degreeseq'), 'BIT', 'Bachelor of IT', 4, 'EBIT'),
    (nextval('uni.degreeseq'), 'PhD', 'Philosophiae Doctor', 5, 'EBIT');
    
INSERT INTO Uni.Course VALUES
    (nextval('uni.courseseq'), 'COS301', 'Software Engineering', 'Computer Science', 40),
    (nextval('uni.courseseq'), 'COS326', 'Database Systems', 'Computer Science', 20),
    (nextval('uni.courseseq'), 'MTH301', 'Discrete Mathematics', 'Mathematics', 15),
    (nextval('uni.courseseq'), 'PHL301', 'Logical Reasoning', 'Philosophy', 15);
    
INSERT INTO Uni.Undergraduate VALUES
    (nextval('uni.studentseq'), '140010', 'Mr Minal Pramlall', '10-01-1996', 'BSc', 3, 'COS301,COS326,MTH301'),
    (nextval('uni.studentseq'), '140015', 'Ms Leandra Methven', '25-05-1995', 'BSc', 3, 'COS301,PHL301,MTH301'),
    (nextval('uni.studentseq'), '131120', 'Mr Kurt Lourens', '30-01-1995', 'BIT', 3, 'COS301,COS326,PHL301'),
    (nextval('uni.studentseq'), '131140', 'Mr Keith Kinsey', '20-02-1996', 'BIT', 4, 'COS301,COS326,MTH301,PHL301');
     
INSERT INTO Uni.Postgraduate VALUES
    (nextval('uni.studentseq'), '101122', 'Mr Tristan Bowman', '15-06-1987', 'PhD', 2, 'full time', 'Mr Emilio Singh'),
    (nextval('uni.studentseq'), '121101', 'Mr Jason van Eck', '27-04-1985', 'PhD', 3, 'part time', 'Mr Emilio Singh');