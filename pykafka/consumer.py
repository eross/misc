from kafka import KafkaConsumer

consumer = KafkaConsumer('test',bootstrap_servers='192.168.247.225:32768')
for msg in consumer:
    #print(msg.offset, msg.value)
    pass