import psycopg2 as psy
import redis
import json
import time

employee_idx = 10000
class DB:
    def __init__(self, database='postgres', user='postgres', password='nasta090305', host='localhost', port='5432'):
        try:
            self._connection = psy.connect(user=user,
                        database=database,
                        password=password,
                        host=host,
                        port=port)
            self._connection.autocommit = True
            self._cursor = self._connection.cursor()
            print("PostgreSQL connection opened\n")        
        except Exception as ex:
            print("Error while connecting with PostgreSQL\n", ex)
            return
    
    def __del__(self):
        if self._connection:
            self._cursor.close()
            self._connection.close()
            print("PostgreSQL connection closed\n")
            
    def execute(self, query):
        try:
            self._cursor.execute(query)
        except Exception as err:
            print("Error while get query - PostgreSQL\n", err)
            return
    
        return query

    def get_one(self, query):
        if self.execute(query) is not None:
            return self._cursor.fetchone()
        return None

    def get_all(self, query):
        if self.execute(query) is not None:
            return self._cursor.fetchall()
        return None
    

def load_employees(path, redis_sesh):
    data = {}
    with open(path, 'r') as file:
        data = json.load(file)
    for idx, data in enumerate(data):
        data["json_data"] = None
        rc = redis_sesh.hset(f"employee:{idx}",
                    mapping={
                        "empl_id": int(data["empl_id"]),
                        "pharm_id": int(data["pharm_id"]),
                        "fio": data["fio"],
                        "job_title": data["job_title"],
                        "salary" : int(data["salary"])
                        }
                    )

# ========================================================================================= #

def insert_redis(redis_sesh):
    global employee_idx
    employee_idx += 1
    redis_sesh.hset(f"employee:{employee_idx}",
                    mapping={
                        "empl_id": employee_idx,
                        "pharm_id": 12,
                        "fio": "A.A.A.",
                        "job_title": "aaaaaa",
                        "salary": 10000
                        }
                    )
    
def insert_sql(Db_sesh):
    global employee_idx
    employee_idx += 1
    Db_sesh.execute(f"INSERT INTO employees VALUES({employee_idx}, 12, 'A.A.A.', 'aaaaaa', 10000);")

def update_redis(redis_sesh):
    global employee_idx
    employee_idx += 1
    redis_sesh.hset(f"employee:{employee_idx}",
                    mapping={
                        "empl_id": employee_idx,
                        "pharm_id": 12,
                        "fio": "A.A.A.",
                        "job_title": "aaaaaa",
                        "salary": 10000
                    }
                )
    
def update_sql(Db_sesh):
    global employee_idx
    employee_idx += 1
    Db_sesh.execute(f"INSERT INTO employees VALUES({employee_idx}, 12, 'A.A.A.', 'aaaaaa', 10000);")

def del_redis(redis_sesh):
    global employee_idx
    employee_idx += 1
    redis_sesh.delete(f"employee:{employee_idx}")
    
def del_sql(Db_sesh):
    global employee_idx
    employee_idx += 1
    Db_sesh.execute(f"DELETE FROM employees WHERE empl_id = {employee_idx};")

# ========================================================================================= #

def query_redis(redis_sesh):
    start = time.time()
    all_employees = {}
    
    for key in redis_sesh.scan_iter(match="employees:*"):
        employees_data = redis_sesh.hgetall(key)
        # print(key, user_data)
        all_employees[key.decode("utf-8")] = {k.decode("utf-8"): v.decode("utf-8") for k, v in employees_data.items()}
    res = sorted(all_employees.items(), key=lambda v: int(v[1]["salary"]))[:10]
    end = time.time()
    # print(res)
    return end - start

def query_sql(Db_sesh):
    start = time.time()
    rc = Db_sesh.get_all("""SELECT * FROM employees ORDER BY salary ASC LIMIT 10;""")
    end = time.time()
    # print(rc)
    return end - start
