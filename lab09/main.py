from tasks import *
import time
import pandas as pd
from matplotlib import pyplot as plt

if __name__ == "__main__":
    pool = redis.ConnectionPool(host='localhost', port=6379, db=0)
    r = redis.Redis(connection_pool=pool)
    db = DB()

    load_employees("./employees.json", r)
    df = pd.DataFrame()
    sum_sql_t, sum_rds_t = 0, 0
    cnt = 0
    while cnt < 10:
        #if cnt % 2 == 0:
        #insert_redis(r)
        #insert_sql(db)
        rds = query_redis(r)
        sql = query_sql(db)
        sum_sql_t += sql
        sum_rds_t += rds
        #print(f"{rds}\n{sql}")
        time.sleep(5)
        cnt += 1
    print("No changes avg query time: ")
    print("SQL: ", sum_sql_t / cnt)
    print("RDS: ", sum_rds_t / cnt)

    sum_sql_t, sum_rds_t = 0, 0
    cnt = 0
    while cnt < 10:
        if cnt % 2 == 0:
            insert_redis(r)
            insert_sql(db)
        rds = query_redis(r)
        sql = query_sql(db)
        sum_sql_t += sql
        sum_rds_t += rds
        #print(f"{rds}\n{sql}")
        time.sleep(5)
        cnt += 1
    print("Inserts into table every 10 secs avg query time: ")
    print("SQL: ", sum_sql_t / cnt)
    print("RDS: ", sum_rds_t / cnt)

    sum_sql_t, sum_rds_t = 0, 0
    cnt = 0
    while cnt < 10:
        if cnt % 2 == 0:
            update_redis(r)
            update_sql(db)
        rds = query_redis(r)
        sql = query_sql(db)
        sum_sql_t += sql
        sum_rds_t += rds
        #print(f"{rds}\n{sql}")
        time.sleep(5)
        cnt += 1
    print("Updates table every 10 secs avg query time: ")
    print("SQL: ", sum_sql_t / cnt)
    print("RDS: ", sum_rds_t / cnt)

    sum_sql_t, sum_rds_t = 0, 0
    cnt = 0
    while cnt < 10:
        if cnt % 2 == 0:
            del_redis(r)
            del_sql(db)
        rds = query_redis(r)
        sql = query_sql(db)
        sum_sql_t += sql
        sum_rds_t += rds
        #print(f"{rds}\n{sql}")
        time.sleep(5)
        cnt += 1
    print("Deletes from table every 10 secs avg query time: ")
    print("SQL: ", sum_sql_t / cnt)
    print("RDS: ", sum_rds_t / cnt)
    #df = pd.DataFrame.from_dict({"sql": arr_sql, "rds": arr_rds})
    #plt.figure(figsize=(10, 8))
    #plt.plot(df, label=df.columns)
    #plt.xlabel('measurement number')
    #plt.ylabel('elapsed time')
    #plt.title('Nothing changes')
    #plt.legend()
    #plt.savefig("no_change.png")
    #plt.show()
