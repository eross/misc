from kafka import KafkaConsumer

consumer = KafkaConsumer('test',bootstrap_servers='192.168.247.225:32777')
for msg in consumer:
    print(msg.offset, msg.value)
