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

class Satellite(BASE):
    __tablename__ = 'satellite'
    __table_args__ = {'schema': 'public'}
    id = Column('id', Integer, primary_key=True)
    name = Column('name', Text)
    production_date = Column('production_date', Date)
    country = Column('country', Text)


 class Flight(BASE):
     __tablename__ = 'flight'
     __table_args__ = {'schema': 'public'}
     satellite_id = Column('satellite_id', Integer, ForeignKey('public.satellite.id'))
     launch_date = Column('launch_date', Date)
     launch_time = Column('launch_time', Time)
     week_day = Column('week_day', Text)
     type = Column('type', Integer)

     satellites = relationship('Satellite', foreign_keys=[satellite_id])


# найти все страны, в которых нет спутников со сроком эксплуатации менее 50 лет
def select_sql1(session):
    query = '''
            SELECT DISTINCT country
            FROM satellite
            WHERE country NOT IN (SELECT DISTINCT country
                                  FROM satellite
                                  WHERE (CURRENT_DATE - production_date) < (50 * 365));
            '''
    data = session.execute(text(query))
    for row in data:
        print(*row)

def select_orm1(session):
    _data = session.query(Satellite.country.distinct()).where((func.current_date - Satellite.production_date) < (50 * 365))
    data = session.query(Satellite.country.distinct()).where(Satellite.country not in _data)
    for row in data:
        print(*row)


# найти спутник, который был в этом году отправлен раньше всех
def select_sql2(session):
    query = '''
                SELECT satellite_id
                FROM flight 
                WHERE
                    DATE_PART('year', launch_date) = DATE_PART('year', now()) AND
                    type = 1
                ORDER BY launch_date, launch_time
                LIMIT(1);
                '''
    data = session.execute(text(query))
    for row in data:
        print(*row)

def select_orm2(session):
    data = session.query(Flight.satellite_id).where(Flight.type == 1 and
            func.extract('year', Flight.launch_date) == func.extract('year', func.current_date)).orderby(Flight.launch_date,
                                                                                                         Flight.launch_time).limit(1)


# найти все российские спутники, у которых состоялся вылет в 2024 году не позднее первого сентября
def select_sql3(session):
    query = '''
                SELECT DISTINCT s.id
                FROM satellite s JOIN flight f ON s.id = f.satellite_id
                WHERE s.country = 'Россия' AND 
                f.type = 1 AND f.launch_date >= '2024-09-01' AND f.launch_date < '2025-01-01';
                '''
    data = session.execute(text(query))
    for row in data:
        print(*row)

def select_orm3(session):
    data = session.query(Satellite.id.distinct()).join(Flight, Flight.satellite_id == Satellite.id).where(Satellite.country == 'Россия'
                            and Flight.type == 1 and Flight.launch_date >= '2024-09-01' and Flight.launch_date < '2025-01-01')
    for row in data:
        print(*row)


ENGINE = create_engine('postgresql://postgres:nasta090305@localhost:5432/postgres')
try:
    ENGINE.connect()
except Exception as e:
    print(e)
    exit(0)
Session = sessionmaker(bind=ENGINE)
session = Session()
select_sql1(session)