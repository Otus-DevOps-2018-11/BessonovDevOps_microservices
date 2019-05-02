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
  * к сервисам в файле docker-compose.yml подключен файл с переменными окружения, с помощью которых задается версия образа, порт, пользователь, добавлено разделение по сетям.

## home work #18 gitlab-ci-1
1. Описание   
  * развернут docker-host gitlab-ci:
  ```bash
    docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    gitlab-ci
  ```
  * созданы рабочие каталоги сервера gitlab-ci, создана конфигурация docker-compose.yml, выполнен запуск
  ```bash
    cd /srv/giltab
    docker-compose up -d
  ```
  * после запуска и настройки gitlab-ci в docker, запщен контейнер gitlab-runner:
  ```bash
    docker run -d --name gitlab-runner --restart always \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest
  ```
  * выполнена регистрация раннера в gitlab
  * выполнено клонирование репозитория reddit, с последующим пушем в gitlab-ci-1
  * создан конфигурационный файл пайплайна .gitlab-ci.yml
  * в задание тестирования (test_unit_job:) добавлен вызов файла тестов simpletest.rb,
  * в Gemfile добавлен модуль 'rack-test'
  * в stages шаг deploy изменен на review, вы deploy_dev_job: добавлены параметры окружения - name, url
  * добавлены шаги и задания - staging и production, с запуском по требованию (when: manual)
  * в задания - staging и production добавлены условия запуска (only: - /^\d+\.\d+\.\d+/)
  * добавлено динамическое создание окружений branch review:, с условием - only: branches, с исключением ветки master.

## home work #20 monitoring-1
1. Описание   
  * Созданы правила фаервола для prometheus и puma
  ~~~bash
    gcloud compute firewall-rules create prometheus-default --allow tcp:9090
    gcloud compute firewall-rules create puma-default --allow tcp:9292
  ~~~
  * Создадан docker-host в GCP настроено локальное окружение
  ~~~bash
    export GOOGLE_PROJECT=docker-123456
    docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    docker-host
    eval $(docker-machine env docker-host)
    ~~~
    * выполнент тестовый запуск prometheus
    ~~~bash
      docker run --rm -p 9090:9090 -d --name prometheus prom/prometheus:v2.1.0
    ~~~
    * в корене репозитория создан каталог docker, в котрый перемещен каталог docker-monolith, docker-compose
    * в корне репозитория создан каталог monitoring/prometheus, создан Dockerfile для сборки контейнера prometheus с файлом конфгурации prometheus.yml
    * выполнена сборка prometheus и микросервисов (в каталоге src/)
    ~~~bash
      export USER_NAME=bessonovd
      docker build -t $USER_NAME/prometheus .
      for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done
    ~~~
    * из файла docker-compose.yml убраны директивы build, добавлен запуск prometheus, добавлены сети front, back
    * выполнен запуск мкросервисов, с проверкой отслеживания метрик и доступности (ui_health, ui_health_<service-name>)
    * в docker-compose.yml добавлен сервис node-exporter, контейнер prometheus пересобран с job node
    * выполено пересоздание сервисов, выполнена проверка метрики node_load1
    * созданные образы запушены в hub.docker.com https://cloud.docker.com/u/bessonovd/repository/list

## home work #21 logging-1

1. Описание.
  * обновлено содержимое каталогов ui, post, comment
  * выполнена пересборка образова контейнеров с помещением в hub.docker.com

  ```bash
    export USER_NAME=bessonovd
    cd src/ui
    docker_build.sh && docker push $USER_NAME/ui
    cd ../src/post-py
    docker_build.sh && docker push $USER_NAME/post
    cd ../src/comment
    docker_build.sh && docker push $USER_NAME/comment
  ```

  * создан докер хост с помощью docker-machine:

  ```bash
    export GOOGLE_PROJECT=docker-237108
    docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
  --google-machine-type n1-standard-1 \
  --google-open-port 5601/tcp \
  --google-open-port 9292/tcp \
  --google-open-port 9411/tcp \
  logging
  eval $(docker-machine env logging)
  docker-machine ip logging
  ```

