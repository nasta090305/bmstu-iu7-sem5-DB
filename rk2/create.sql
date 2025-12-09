CREATE TABLE IF NOT EXISTS Exch_Employees
(
  Empl_ID SERIAL PRIMARY KEY,
  FIO TEXT,
  Birth_year INT,
  Job_title TEXT
);

CREATE TABLE IF NOT EXISTS Currency
(
  Cur_ID SERIAL PRIMARY KEY,
  Name TEXT
);

CREATE TABLE IF NOT EXISTS Exchange_Rate
(
  Exch_ID SERIAL PRIMARY KEY,
  Cur_ID SERIAL UNIQUE,
  Sell NUMERIC,
  Buy NUMERIC,
  FOREIGN KEY(Cur_ID) REFERENCES Currency(Cur_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Transactions
(
  Trans_ID SERIAL PRIMARY KEY,
  Empl_ID SERIAL,
  Exch_ID SERIAL,
  Sum NUMERIC,
  FOREIGN KEY(Empl_ID) REFERENCES Employees(Empl_ID) ON DELETE CASCADE,
  FOREIGN KEY(Exch_ID) REFERENCES Exchange_Rate(Exch_ID) ON DELETE CASCADE
);

INSERT INTO Exch_Employees VALUES
(1, 'n1', 2001, 'j1'), 
(2, 'n2', 2000, 'j2'), 
(3, 'n3', 2002, 'j3'), 
(4, 'n4', 2000, 'j4'), 
(5, 'n5', 2000, 'j5'), 
(6, 'n6', 2004, 'j6'), 
(7, 'n7', 2007, 'j7'), 
(8, 'n8', 2007, 'j8'), 
(9, 'n9', 2004, 'j9'), 
(10, 'n10', 2005, 'j10'); 

INSERT INTO Currency VALUES
(1, 'cur1'),
(2, 'cur2'),
(3, 'cur3'),
(4, 'cur4'),
(5, 'cur5'),
(6, 'cur6'),
(7, 'cur7'),
(8, 'cur8'),
(9, 'cur9'),
(10, 'cur10');

INSERT INTO Exchange_Rate VALUES 
(1, 3, 100, 120),
(2, 2, 24, 25),
(3, 5, 0.22, 0.25),
(4, 8, 130, 156),
(5, 1, 324, 453),
(6, 6, 200, 230),
(7, 4, 43, 70),
(8, 7, 89, 100), 
(9, 10, 0.3, 0.7),
(10, 9, 13, 20);

INSERT INTO Transactions VALUES
(1, 6, 5, 5000), 
(2, 6, 4, 100000), 
(3, 2, 1, 50000), 
(4, 10, 4, 23000), 
(5, 10, 3, 10000), 
(6, 10, 10, 32000), 
(7, 1, 3, 10000), 
(8, 7, 5, 1200000),
(9, 5, 7, 45000),
(10, 5, 6, 456000);

SELECT * FROM transactions;