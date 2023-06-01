#!/bin/bash

help_flag=false
folder=""
format=""

while getopts ":d:f:h" opt; do
  case $opt in
    d) folder="$OPTARG"
    ;;
    f) format="$OPTARG"
    ;;
    h) help_flag=true
    ;;
    \?) echo "Несуществующий параметр -$OPTARG" >&2
    exit 1
    ;;
  esac
done

if $help_flag ; then
    echo "Параметры:"
    echo "-d - путь до папки. По умолчанию - рабочая директория"
    echo "-f - желаемый формат. По умолчанию - jpeg"
    exit 1
fi

if ! command -v convert &> /dev/null; then
    echo "ImageMagisk не установлен. Скрипт работать не будет."
    exit 1
fi

if [ -z "$folder" ]; then
    echo "Директория не указана, предполагаем рабочую директорию"
    folder=$(pwd)
fi

if [ -z "$format" ]; then
    echo "Формат не указан, предполагаем jpeg"
    format="jpeg"
fi

if ! convert -list format | grep -q "$format"; then
  echo "Ошибка: ImageMagisk не поддерживает такой формат, как $format"
  exit 1
fi

if [ ! -d "$folder" ]; then
    echo "Директория $folder не найдена!"
    exit 1
fi

files=$(find "$folder" -type f -iname "*.jpg")

for file in $files; do
    convert "$file" "${file%.*}.$format"
done
