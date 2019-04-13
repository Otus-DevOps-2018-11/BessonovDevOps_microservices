# BessonovDevOps_microservices
BessonovDevOps microservices repository
## home work #14 docker-1

1. Описание
  * Создана ветка docker-1
  * настроена интеграция с travis-ci
  * установлен docker
  * создан образ докер контейнера
  * добвлено описание работ

## home work #15 docker-2

1. Описание
  * создан проект docker в GCP, перенастроено подключение по умолчанию
  * в GCP развернут docker host с использованием docker-machine
  * для сборки образа docker созданы файлы Dockerfile, mongod.conf, db_config, start.sh
  * выполнена сборка образа reddit на docker-host в GCP
  * зарегистрирована учетая запись hub.docker.com (bessonovd)
  * образ bessonovd/otus-reddit:1.0 сохранен в hub.docker.com
  * выполнено развертывание приложения в локальном docker

## home work #16 docker-3

1. Описание
  * создан каталог scr из архива reddit-microservices
  * в каталогах comment, post-py, ui, созданы Dockerfile для сборки образов контейнеров микросервисной архтектуры
  * выполнена оптимизация сборки в Dockerfile, синтаксис проверен линтером (docker run --rm -i hadolint/hadolint < ./ui/Dockerfile)
  * выполнено развертывание контейнеров в отдельной bridge сети reddit
  * проверена работоспособность приложения
