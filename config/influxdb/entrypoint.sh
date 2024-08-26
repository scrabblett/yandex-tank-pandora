#!/bin/bash

check_influxdb() {
  SHOW DATABASES > /dev/null 2>&1
}

influxd

influx
echo "Ожидание запуска InfluxDB..."
until check_influxdb; do
  >&2 echo "InfluxDB еще не доступен. Ожидание 5 секунд..."
  sleep 5
done

# Создайте базу данных
echo "InfluxDB доступен. Создание базы данных..."
CREATE DATABASE influx
