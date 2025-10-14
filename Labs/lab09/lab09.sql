DROP TABLE IF EXISTS Loan CASCADE;
DROP TABLE IF EXISTS BookAuthor CASCADE;
DROP TABLE IF EXISTS Member CASCADE;
DROP TABLE IF EXISTS Book CASCADE;
DROP TABLE IF EXISTS Author CASCADE;

CREATE TABLE Author (
    AuthorID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

CREATE TABLE Book (
    BookID SERIAL PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Year INT,
    ISBN VARCHAR(20) UNIQUE
);

CREATE TABLE Member (
    MemberID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    Email VARCHAR(100) UNIQUE
);

-- Many-to-Many: Author - Book
CREATE TABLE BookAuthor (
    BookID INT REFERENCES Book(BookID) ON DELETE CASCADE,
    AuthorID INT REFERENCES Author(AuthorID) ON DELETE CASCADE,
    PRIMARY KEY (BookID, AuthorID)
);

-- One-to-Many: Member - Loan - Book
CREATE TABLE Loan (
    LoanID SERIAL PRIMARY KEY,
    BookID INT REFERENCES Book(BookID) ON DELETE CASCADE,
    MemberID INT REFERENCES Member(MemberID) ON DELETE CASCADE,
    LoanDate DATE NOT NULL,
    ReturnDate DATE,
    Fee NUMERIC(5,2) DEFAULT 0
);

-- Наполнение тестовыми данными


INSERT INTO Author (Name) VALUES
    ('J.K. Rowling'),
    ('Leo Tolstoy'),
    ('Fyodor Dostoevsky');

INSERT INTO Book (Title, Year, ISBN) VALUES
    ('Harry Potter and the Philosopher''s Stone', 1997, '123-ABC'),
    ('War and Peace', 1869, '456-DEF'),
    ('Crime and Punishment', 1866, '789-GHI');

INSERT INTO Member (Name, Address, Email) VALUES
    ('Ivan Ivanov', 'Moscow, Red Square 1', 'ivan@example.com'),
    ('Anna Petrova', 'Saint Petersburg, Nevsky Ave 10', 'anna@example.com');

INSERT INTO BookAuthor (BookID, AuthorID) VALUES
    (1, 1), -- Rowling -> Harry Potter
    (2, 2), -- Tolstoy -> War and Peace
    (3, 3); -- Dostoevsky -> Crime and Punishment

INSERT INTO Loan (BookID, MemberID, LoanDate, Fee) VALUES
    (1, 1, '2025-10-01', 0),
    (2, 2, '2025-09-20', 15.50);

-- SELECT-запросы


-- все книги и их авторы
SELECT b.Title, a.Name AS Author
FROM Book b
JOIN BookAuthor ba ON b.BookID = ba.BookID
JOIN Author a ON ba.AuthorID = a.AuthorID;

-- все книги, которые взяли читатели
SELECT m.Name AS Member, b.Title, l.LoanDate, l.Fee
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID;

-- задолженности (Fee > 0)
SELECT m.Name, b.Title, l.Fee
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID
WHERE l.Fee > 0;
