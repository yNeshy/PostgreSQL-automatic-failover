import psycopg2


class DBConnectionTester :

    def __init__(self):
        self.uniq_int = 10
        self.test_id = 1
        try:
            # Edit next lines.
            self.connection = psycopg2.connect(
                                            user="postgres",
                                            password="admin",
                                            host="127.0.0.1",
                                            port="5432",
                                            database="test"
                            )
            
            
            self.cursor = self.connection.cursor()
        except (Exception, psycopg2.Error) :
            #print ("Error while fetching data from PostgreSQL", error)
            pass

    
    def writeTest(self):
        try:
            statement = "UPDATE test_table set stuff = {} where id={}"
            postgreSQL_easy_write = statement.format(self.uniq_int, self.test_id)
            
            self.cursor.execute(postgreSQL_easy_write)
            self.connection.commit()
            fetch = "SELECT stuff from test_table where id = 1"
            self.cursor.execute(fetch)
            res = self.cursor.fetchone()[0]
            
            if res == self.uniq_int:
                done = True
            else :
                done = False
            self.uniq_int = self.uniq_int + 1
            return done
        except (Exception, psycopg2.Error) as error :
            #print ("Error in writeTest while fetching data from PostgreSQL", error)
            return False

    def dropTest_Value(self,value):
        pass


    def fetchTest_Value(self, value):
        try:
            statement = "SELECT id from test_table WHERE (stuff={})".format(value)
            self.cursor.execute(statement)

            return self.cursor.fetchall()
        except (Exception, psycopg2.Error) as error :
            #print ("Error while fetching data from PostgreSQL", error)
            return False


    def checkConnection(self):
        try:
            postgreSQL_select_Query = "select * from test_table where id={}".format(self.test_id)
            self.cursor.execute(postgreSQL_select_Query)
            records = self.cursor.fetchall() 
            
            if not (records is None) :
                return True
            return False
            

    
        except (Exception, psycopg2.Error) :
            #print ("Error in checkConnection.")
            return False
   

    def __del__(self):
    #closing database connection.
        try:
            if(self.connection):
                self.cursor.close()
                self.connection.close()
                print("PostgreSQL connection is closed")
        except (Exception, psycopg2.Error) :
            #print ("Error while closing connecton.")
            return False
