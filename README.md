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

## home work #17 docker-4
1. Описание
  * выполнен разбор принципов работы сетей docker
  ```bash
   docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
   # контенеру доступен только интерфейс lo
   docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig
   docker-machine ssh docker-host ifconfig
   # вывод команд идентичен, т.к. сетевой драйвер docker - host использует сеть хостовой системы
   docker run --network host -d nginx
   # при многократном запуске выше приведенной команды, создается и запускается один контейнер,
   # который присоединяется к сети host, повтроный запуск приводит к ошибке,
   # т.к. tcp порт 80 уже занять в хостовой системе
    sudo ln -s /var/run/docker/netns /var/run/netns # на docker-host
   # при запуске контейнера с сетью none, в сетевом пространстве имен docker-host:
   # RTNETLINK answers: Invalid argument
   # при запуске контейнера с сетью host, в сетевом пространстве имен новых сущностей не появляется,
   # т.к. используется сеть docker-host
  ```
  * созданы сети для запуска контейнеров в отдельных подсетях:
  ```bash
    docker network create back_net --subnet=10.0.2.0/24
    docker network create front_net --subnet=10.0.1.0/24
   # запущены контейнеры в созданных подсетях
    docker run -d --network=front_net -p 9292:9292 --name ui bessonovd/ui:1.0$
    docker run -d --network=back_net --name comment bessonovd/comment:1.0$
    docker run -d --network=back_net --name post bessonovd/post:1.0$
    docker run -d --network=back_net --name mongo_db --network-alias=post_db \
     --network-alias=comment_db mongo:latest$
   # после запуска контейнеров выше приведенной командой, приложение не работает,
   # т.к. у контенеров post и comment отсутствует сетевая связанность с mongodb
    docker network connect front_net post
    docker network connect front_net comment
   # post и comment подключены к сети mongodb, приложение работает
  ```
  * на docker-host установлен docker-compose
  ```bash
    sudo apt install python-dev python-pip
    pip install --upgrade pip
    pip install docker-compose
  ```
  * в каталоге src создан docker-compose.yml, при запуске docker-compose up -d, контенеры создаются с префиксом src, который является имененем проекта по умолчанию (каталог в котором хранится файл docker-compose.yml), именеим сервиса и номером контенера, например: src_ui_1. Для переопределения префикса (имени проекта):  ```docker-compose up -d -p $(project_name)```
  * к сервиса в файле docker-compose.yml подключен файл с переменными окружения, с помощью которых задается версия образа, порт, пользователь, добавлено разделение по сетям.
