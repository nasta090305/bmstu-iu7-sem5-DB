import sqlalchemy as sal
from sqlalchemy.sql import text
from sqlalchemy.orm import relationship, query
from sqlalchemy import func
from sqlalchemy import Column, Integer, ForeignKey, Text, Numeric, CheckConstraint, Date, DateTime, JSON, Time, between
from sqlalchemy import PrimaryKeyConstraint
from sqlalchemy import create_engine, select, insert, delete, update, func
from sqlalchemy.orm import Session, sessionmaker, declarative_base, class_mapper
from json import dumps, dump, load, loads

from sqlalchemy.sql.functions import count

BASE = declarative_base()

class Medicines(BASE):
    __tablename__ = 'medicines'
    __table_args__ = {'schema': 'public'}
    med_id = Column('med_id', Integer, primary_key=True)
    name = Column('name', Text)
    distributor = Column('distributor', Text)
    price = Column('price', Integer)
    exp_date = Column('exp_date', Date)

class Pharmacies(BASE):
    __tablename__ = 'pharmacies'
    __table_args__ = {'schema': 'public'}
    pharm_id = Column('pharm_id', Integer, primary_key=True)
    city = Column('city', Text)
    street = Column('street', Text)
    house = Column('house', Integer)

class Employees(BASE):
    __tablename__ = 'employees'
    __table_args__ = {'schema': 'public'}
    empl_id = Column('empl_id', Integer, primary_key=True)
    pharm_id = Column('pharm_id', Integer, ForeignKey('public.pharmacies.pharm_id'))
    fio = Column('FIO', Text)
    job_title = Column('job_title', Text)
    salary = Column('salary', Integer)

    pharmacies = relationship('Pharmacies', foreign_keys=[pharm_id])

class Availability(BASE):
    __tablename__ = 'availability'
    __table_args__ = {'schema': 'public'}
    med_id = Column('med_id', Integer, ForeignKey('public.medicines.med_id'), primary_key=True)
    pharm_id = Column('pharm_id', Integer, ForeignKey('public.pharmacies.pharm_id'), primary_key=True)
    qnt = Column('qnt', Integer)

    meds = relationship('Medicines', foreign_keys=[med_id])
    pharms = relationship('Pharmacies', foreign_keys=[pharm_id])


# Получить все лекарства
def select_1(session):
    data = session.query(Medicines)
    for row in data:
        print(row.med_id, row.name, row.distributor, row.exp_date, row.price)

# Получить 10 самых больших партий наличия
def select_2(session):
    data = session.query(Availability).order_by(Availability.qnt.desc()).limit(10)
    for row in data:
        print(row.med_id, row.pharm_id, row.qnt)

# получить все лекарства дешевле 500 рублей
def select_3(session):
    data = session.query(Medicines).where(Medicines.price < 300)
    for row in data:
        print(row.name, row.price)


# Для каждого лекарства по названию получить его суммарное количество во всех аптеках
def select_4(session):
    data = session.query(Medicines.name, func.sum(Availability.qnt).label('sum_qnt')).join(Availability,
                                        Availability.med_id == Medicines.med_id).group_by(Medicines.name)
    for row in data:
        print(row.name, row.sum_qnt)


# Получить поставщиков средняя цена у которых ниже средней цены всех препаратов
def select_5(session):
    avg_price = session.query(func.avg(Medicines.price))
    data = session.query(Medicines.distributor, func.avg(Medicines.price).label('avg_distr'),
                         avg_price.label('avg_all')).group_by(Medicines.distributor).having(func.avg(Medicines.price) < avg_price)
    for row in data:
        print(row.distributor, row.avg_distr, row.avg_all)


# Чтение из JSON документа.
def read_json(path='D:/5sem/bd/lab5/json_data/medicines.json'):
    with open(path, 'r') as f:
        for p in load(f):
            print(p)


# Обновление JSON документа.
def update_json(key, val, path='D:/5sem/bd/lab5/json_data/medicines.json'):
    with open(path, 'r') as f:
        pl = load(f)
        for p in pl:
            if p['med_id'] == key:
                p['price'] = val
    with open(path, 'w') as f:
        dump(pl, f)


# Запись в JSON документ.
def write_to_json(session, path='D:/5sem/bd/lab5/json_data/medicines.json'):
    data = session.query(Medicines)
    columns = [c.key for c in Medicines.__table__.columns]
    json_data = [{c: getattr(row, c) for c in columns} for row in data]
    for row in json_data:
        row['exp_date'] = str(row['exp_date'])
    with open(path, 'w') as f:
        dump(json_data, f)


# Однотабличный запрос на выборку.
def select_9(session):
    query = '''
            SELECT *
            FROM employees 
            WHERE fio LIKE 'Elizabeth%';
            '''
    data = session.execute(text(query))
    for row in data:
        print(row.fio, row.job_title)


# Многотабличный запрос на выборку.
def select_10(session):
    query = '''
            SELECT m.name, SUM(a.qnt) as sum_qnt
            FROM medicines m JOIN availability a ON m.med_id = a.med_id
            GROUP BY m.name;
            '''
    data = session.execute(text(query))
    for row in data:
        print(row.name, row.sum_qnt)

# Добавить препарат/
# linq to sql процедура, которая принимает должность сотрудника, определяет по должности фио тех, которые работают в заданном городе и 5 препаратов у которых самое ранний срок годности и самый поздний
def insert_data(session, name, distributor, exp_date, price):
    try:
        max_id = session.query(func.max(Medicines.med_id))[0][0]
        session.execute(insert(Medicines).values(med_id=max_id + 1,
                                             name=name,
                                             distributor=distributor,
                                             exp_date=exp_date,
                                             price=price))
        session.commit()
        print('Значение добавлено.')
    except Exception as e:
        print('Ошибка:', e)
        return


# Изменить данные
def update_data(session, key, val):
    print('До обновления:')
    data = session.execute(text('''SELECT * FROM medicines WHERE med_id = ''' + str(key) + ";"))
    for row in data:
        print(row.med_id, row.price)
    query = f'''
            UPDATE medicines
            SET price = {val}
            WHERE med_id = {key};
            '''
    session.execute(text(query))
    print('После обновления:')
    data = session.execute(text('''SELECT * FROM medicines WHERE med_id = ''' + str(key) + ";"))
    for row in data:
        print(row.med_id, row.price)
    session.commit()
    print('Данные изменены.')


# удалить препарат
def delete_data(session):
    med_id = input("Введите med_id препарата, который необходимо удалить: ")
    query = f'''
            DELETE FROM medicines
            WHERE med_id = {med_id}
            '''
    session.execute(text(query))
    session.commit()
    print('Препарат удалён.')


# Получение доступа к данным, выполняя только хранимую процедуру. Удаление просроченных лекарств
def run_procedure(session, date):
    print("До вызова процедуры: ")
    data = session.execute(text('''SELECT * FROM medicines WHERE exp_date < \'''' + date + "\';"))
    for row in data:
        print(row.med_id, row.exp_date)
    session.execute(text(f'CALL delete_expired_meds(\'{date}\');'))
    print("После вызова процедуры: ")
    data = session.execute(text('''SELECT * FROM medicines WHERE exp_date < \'''' + date + "\';"))
    for row in data:
        print(row.med_id, row.exp_date)

def defend(session):
    job = input("Введите должность: ")
    session.execute(text(f'CALL def7(\'{job}\')'))
    empl_res = session.execute(text('''SELECT * FROM res_empl'''))
    print(f"Сотрудники должности {job} в Москве:")
    for row in empl_res:
        print(row.empl_id, row.fio, row.job_title, row.city)
    meds_res = session.execute(text('''SELECT * FROM res_meds'''))
    print(f"Топ-5 лекарств, которые испортятся быстрее всех:")
    for row in meds_res:
        print(row.med_id, row.exp_date)
    meds_desc_res = session.execute(text('''SELECT * FROM res_meds_desc'''))
    print(f"Топ-5 лекарств, которые испортятся позднее всех:")
    for row in meds_desc_res:
        print(row.med_id, row.exp_date)