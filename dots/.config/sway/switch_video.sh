#!/bin/bash

# Получаем номер канала из первого аргумента
CHANNEL=$1

# Проверка: если канал не задан, используем по умолчанию 0
if [ -z "$CHANNEL" ]; then
    CHANNEL=0
fi

# Убиваем все процессы gst-launch-1.0
pkill -f gst-launch-1.0

# Ждём завершения потоков
sleep 1

# Формируем RTSP URL (замени на актуальный формат для своей камеры)
RTSP_URL="rtsp://192.168.137.10:554/user=reg&password=reg1234&channel=${CHANNEL}&stream=0.sdb?real_stream"

# Запускаем видеопоток
gst-launch-1.0 rtspsrc location="$RTSP_URL" latency=17 timeout=500000 ! queue ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink > /tmp/gst_rtsp_log.txt 2>&1 &
