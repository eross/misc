from kafka import KafkaProducer 
from time import sleep
from time import time
import timeit
producer = KafkaProducer(bootstrap_servers='192.168.247.225:32776', acks='all')

start = time()
for x in range(10):
    msg = b'message: '+str(x)
    producer.send('test', msg)
print time() - start
producer.flush()
print time() - start

