from utils import *
MENU ="\nМеню\n\n"\
      "LINQ_to_Object\n"\
      "\t 1. Получить все лекарства \n"\
      "\t 2. Получить 10 самых больших партий наличия \n"\
      "\t 3. Получить все лекарства дешевле 500 рублей \n"\
      "\t 4. Для каждого лекарства по названию получить его суммарное количество во всех аптеках \n"\
      "\t 5. Получить поставщиков средняя цена у которых ниже средней цены всех препаратов \n\n"\
      "LINQ_to_JSON\n"\
      "\t 6. Запись в JSON документ. \n"\
      "\t 7. Чтение из JSON документа. \n"\
      "\t 8. Обновление JSON документа (обновить цену препарата). \n\n"\
      "LINQ_to_SQL\n"\
      "\t 9. Однотабличный запрос на выборку. Получить должности всех сотрудниц по имени Elizabeth. \n"\
      "\t 10. Многотабличный запрос на выборку. Для каждого лекарства по названию получить его суммарное количество во всех аптеках \n"\
      "\t 11. Добавление данных о препарате в базу данных. \n"\
      "\t 12. Обновление данных базе данных (обновить цену препарата). \n"\
      "\t 13. Удаление данных из базы данных. \n"\
      "\t 14. Получение доступа к данным, выполняя только хранимую процедуру. Удаление просроченных лекарств\n\n"\
      "\t 15. Защита \n" \
      "\t 0. Выход \n\n"\
      "Выбор: "

def input_command():
    print(MENU)
    c = int(input('Введите номер команды: '))
    if c < 0 or c > 15:
        print('Такой команды не существует.\n')
        return 0
    return c

if __name__ == "__main__":
    ENGINE = create_engine('postgresql://postgres:nasta090305@localhost:5432/postgres')
    try:
        ENGINE.connect()
        print('Соединение с БД установлено.')
    except Exception as e:
        print('Не удалось установить соединение с БД: ', e)
        exit(0)
    Session = sessionmaker(bind=ENGINE)
    session = Session()
    command = -1
    while command != 0:
        command = input_command()
        if command == 1:
            select_1(session)
        elif command == 2:
            select_2(session)
        elif command == 3:
            select_3(session)
        elif command == 4:
            select_4(session)
        elif command == 5:
            select_5(session)
        elif command == 6:
            write_to_json(session)
            print("Записано в JSON")
        elif command == 7:
            read_json()
        elif command == 8:
            try:
                key = int(input('Введите med_id: '))
                val = int(input('Введите новую цену: '))
                update_json(key, val)
                print("Значение обновлено")
            except Exception as e:
                print('Ошибка')
        elif command == 9:
            select_9(session)
        elif command == 10:
            select_10(session)
        elif command == 11:
            name = input('Введите название препарата: ')
            distributor = input('Введите поставщика: ')
            exp_date = input('Введите дату истечения срока годности (гггг-мм-дд): ')
            price = input('Введите цену: ')
            insert_data(session, name, distributor, exp_date, price)
        elif command == 12:
            try:
                key = int(input('Введите med_id: '))
                val = int(input('Введите новую цену: '))
                update_data(session, key, val)
                print("Значение обновлено")
            except Exception as e:
                print('Ошибка')
        elif command == 13:
            delete_data(session)
        elif command == 14:
            date = input("Введите дату, после которой лекарство считается просроченным (гггг-мм-дд): ")
            run_procedure(session, date)
        elif command == 15:
            defend(session)