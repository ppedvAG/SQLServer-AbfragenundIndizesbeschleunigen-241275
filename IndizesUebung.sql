--Du arbeitest mit einer Datenbank für eine Online-Buchhandlung. Die Datenbank enthält folgende Tabellen:

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author_id INT,
    genre VARCHAR(50),
    published_year INT,
    price DECIMAL(10, 2)
);

CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    book_id INT,
    order_date DATE,
    quantity INT
);

--Daten einfügen:
--Füge einige Beispiel-Datensätze in jede Tabelle ein, um realistische Szenarien zu simulieren.
INSERT INTO books (book_id, title, author_id, genre, published_year, price)
VALUES
(1, 'Herr Der Ring', 1, 'Fantasy', 2005, 18.99)
(1, 'Herr Der Ring', 1, 'Fantasy', 2005, 18.99)
(1, 'Herr Der Ring', 1, 'Fantasy', 2005, 18.99)
(1, 'Herr Der Ring', 1, 'Fantasy', 2005, 18.99)

--Abfragen analysieren:
--Schreibe drei Abfragen, die typische Anforderungen der Online-Buchhandlung simulieren. 
--Diese Abfragen sollen ohne Indizes langsam sein.

--Indizes erstellen:
--Analysiere die Abfragen und erstelle geeignete Indizes, um die Abfragen zu optimieren.

--Performance vergleichen:
--Vergleiche die Ausführungszeit der Abfragen vor und nach dem Hinzufügen der Indizes.