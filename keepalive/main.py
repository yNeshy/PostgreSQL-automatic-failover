import time

from DBConnection import DBConnectionTester

class main:
        
    def __init__(self):
        self.db = DBConnectionTester()
        self.OK = True

    def test_write(self):
        if self.db.writeTest():
           self.OK = True
        else:
            print("WRITE : Problem occured")
            self.OK = False
        return self.OK

    def test_read(self):
        if self.db.checkConnection():
           self.OK = True
        else:
            print("READ : Problem occured")
            self.OK = False
        return self.OK

    def reconnect(self):
        self.db = DBConnectionTester()
        self.OK = False


def loop():
    m = main()
    while True:
        t = time.localtime()
        formatted_t = time.strftime("%H:%M:%S",t )
        m.test_read()
        if m.OK:
            print("{} : Read successful".format(formatted_t))
            time.sleep(2)
        else :
            print("{} : READ DOWN!!!!".format(formatted_t))
            
        m.test_write()
        if m.OK:
            print("{} : Write successful".format(formatted_t))
            time.sleep(2)
        else :
            print("{} : WRITE DOWN!!!!".format(formatted_t))
        
        death_time = time.time()
        while (not m.OK):
            print("Reconnecting")
            reconnected = False
            
            m.reconnect()
            time.sleep(0.5)
            
            reconnected = (m.test_read() & m.test_write() )
            
            if reconnected :
                downtime = time.time() - death_time
                print("Recconected.")
                #minutes = (downtime / 60) % 0.001
                #s = (downtime - (minutes * 60)) % 0.001
                
                print("Service has been down for : {:.2f}seconds".format(round(downtime,2)))


if __name__ == '__main__':
    loop()