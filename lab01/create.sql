CREATE TABLE IF NOT EXISTS Pharmacies
(
  Pharm_ID SERIAL,
  City TEXT,
  Street TEXT,
  House INT
);

CREATE TABLE IF NOT EXISTS Employees
(
  Empl_ID SERIAL,
  Pharm_ID SERIAL,
  FIO TEXT,
  Job_title TEXT,
  Salary INT
);

CREATE TABLE IF NOT EXISTS Medicines
(
  Med_ID SERIAL,
  Name TEXT,
  Distributor TEXT,
  Price INT,
  Exp_date DATE
);

CREATE TABLE IF NOT EXISTS Availability
(
  Med_ID SERIAL,
  Pharm_ID SERIAL,
  Qnt INT
);