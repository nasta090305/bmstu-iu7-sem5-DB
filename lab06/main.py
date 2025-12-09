from tools import DB

menu = "\nМеню:\n" \
      "1. Выполнить скалярный запрос \n" \
      "2. Выполнить запрос с несколькими соединениями (JOIN) \n" \
      "3. Выполнить запрос с ОТВ(CTE) и оконными функциями \n" \
      "4. Выполнить запрос к метаданным \n" \
      "5. Вызвать скалярную функцию \n" \
      "6. Вызвать многооператорную функцию \n" \
      "7. Вызвать хранимую процедуру \n" \
      "8. Вызвать системную функцию \n" \
      "9. Создать таблицу в базе данных, соответствующую тематике БД \n" \
      "10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT \n" \
      "11. Защита. По названию лекарства определить аптеки, в которых находятся не менее 3 единиц лекарства этого типа, у которых срок годности истекает в 2026\n" \
      "0. Выход \n\n" \
      "Выбор: "


def main():
    db = DB()
    while True:
        command = int(input(menu))
        result = []
        if command == 1:
            result = db.execute("""
                        SELECT *
                        FROM medicines;
                        """)
        elif command == 2:
            result = db.execute("""
                        SELECT m.name, p.city, a.qnt
                        FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id join medicines m ON a.med_id = m.med_id
                        WHERE m.name = 'nurafen'; 
                        """)
        elif command == 3:
            result = db.execute("""
                        WITH dubles AS
                        (
                        SELECT *
                        FROM medicines
                        UNION ALL
                        SELECT *
                        FROM medicines 
                        )
                        SELECT med_id, name, distributor, price, exp_date
                        FROM  (SELECT *, ROW_NUMBER() OVER (PARTITION BY med_id) AS num FROM dubles)
                        WHERE num = 1
                        """)
        elif command == 4:
            result = db.execute("""
                            SELECT column_name, data_type
                            FROM information_schema.columns
                            WHERE table_name = 'medicines';
                            """)
        elif command == 5:
            result = db.execute(""" 
                            SELECT avg_salary('cashier');
                            """)
        elif command == 6:
            result = db.execute("""
                            SELECT *
                            FROM max_stock_pharmacies();
                            """)
        elif command == 7:
            db.execute("""
            INSERT INTO medicines
            VALUES (1005, 'adds', 'dsew', 546, '09.11.2024');

            INSERT INTO medicines
            VALUES (1015, 'adds', 'dsew', 546, '07.11.2024');
            """)
            result = db.execute("""
                                SELECT * 
                                FROM medicines m
                                ORDER BY m.exp_date
                                LIMIT 5;
                                """)
            print(result)
            db.execute("""
            CALL delete_expired_meds('09.11.2024');
            """)
            result = db.execute("""
                                SELECT * 
                                FROM medicines m
                                ORDER BY m.exp_date
                                LIMIT 5;
                            """)
        elif command == 8:
            result = db.execute("""
                            SELECT * FROM current_database();
                            """)
        elif command == 9:
            db.execute("""DROP TABLE IF EXISTS shifts""")
            db.execute("""
                            CREATE TABLE shifts (
                                shift_date        date,
                                empl_id           integer,
                                FOREIGN KEY(empl_id) REFERENCES employees(Empl_ID) ON DELETE CASCADE
                            );
                            """)
            result = db.execute("""
                                SELECT column_name, data_type
                                FROM information_schema.columns
                                WHERE table_name = 'shifts';
                                """)
        elif command == 10:
            db.execute("""
                            INSERT INTO shifts 
                            VALUES('20-12-2024', 1);
                            """)
            result = db.execute("""
                                SELECT *
                                FROM shifts;
                                """)
        elif command == 11:
            name = input("Введите название лекарства: ")
            print("Всё наличие препарата", name, ":")
            print(db.execute(f'''
            SELECT m.med_id, m.exp_date, p.pharm_id, a.qnt
            FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
            WHERE m.name = \'{name}\';
            '''))
            print("Аптеки: ")
            result = db.execute(f'''
            SELECT p.pharm_id
            FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
            WHERE m.name = \'{name}\' AND DATE_PART('year', m.exp_date) = 2026
            GROUP BY p.pharm_id
            HAVING SUM(a.qnt) >= 3
            ''')
        elif command == 0:
            break
        print(result)


if __name__ == '__main__':
    main()

    # по названию лекартсва определяет аптеки, в которых находятся не менее 3 единиц лекарства этого типа, у которых срок годности истекаеьв 2026

    # диаграмма которая определяет для первых 10 лекартсв по айди период окончания их сроков годности