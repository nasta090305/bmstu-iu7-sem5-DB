import psycopg2


class DB:
    def __init__(self, database='postgres', user='postgres', password='nasta090305', host='localhost', port='5432'):
        try:
            self._connection = psycopg2.connect(
                database=database,
                user=user,
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
            query = None
        if query is not None:
            try:
                return self._cursor.fetchall()
            except:
                return ''
        return None
