# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

Ответ:

Dockerfile:
```
vagrant@server1:~/HW6.5$ cat Dockerfile
FROM centos:7
ENV PATH=/usr/lib:/usr/lib/jvm/jre-11/bin:$PATH

COPY elasticsearch-8.1.1-linux-x86_64.tar /

RUN yum install java-11-openjdk -y
RUN yum install wget -y

#RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.3-linux-x86_64.tar.gz \
#    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512
#RUN yum install perl-Digest-SHA -y
RUN tar -xvf /elasticsearch-8.1.1-linux-x86_64.tar \
    && yum upgrade -y

ADD elasticsearch.yml /elasticsearch-8.1.1/config/
ENV JAVA_HOME=/elasticsearch-8.1.1/jdk/
ENV ES_HOME=/elasticsearch-8.1.1
RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch

RUN mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data \
    && chown -R elasticsearch:elasticsearch /elasticsearch-8.1.1/
RUN mkdir /elasticsearch-8.1.1/snapshots &&\
    chown elasticsearch:elasticsearch /elasticsearch-8.1.1/snapshots

USER elasticsearch
#CMD ["/usr/sbin/init"]
CMD ["/elasticsearch-8.1.1/bin/elasticsearch"]
vagrant@server1:~/HW6.5$
```

https://hub.docker.com/repository/docker/vitaly93/centos

```
vagrant@server1:~/HW6.5$ curl -k -X GET https://127.0.0.1:9200/ -u elastic
Enter host password for user 'elastic':
{
  "name" : "507b410e30ad",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "CEEtMHmDR0WKcE7xT9eOTA",
  "version" : {
    "number" : "8.1.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "d0925dd6f22e07b935750420a3155db6e5c58381",
    "build_date" : "2022-03-17T22:01:32.658689558Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
vagrant@server1:~/HW6.5
```


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

Ответ:

```
vagrant@server1:~/HW6.5$ curl -k -X PUT https://localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_repli
cas": 0 }}' -u elastic
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}vagrant@server1:~/HW6.5$
vagrant@server1:~/HW6.5$

vagrant@server1:~/HW6.5$ curl -k -X PUT https://localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_repli
cas": 1 }}' -u elastic
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}vagrant@server1:~/HW6.5$
vagrant@server1:~/HW6.5$

vagrant@server1:~/HW6.5$ curl -k -X PUT https://localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_repli
cas": 2 }}' -u elastic
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}vagrant@server1:~/HW6.5$
vagrant@server1:~/HW6.5$

vagrant@server1:~/HW6.5$ curl -k -X GET https://localhost:9200/_cat/indices?v -u elastic
Enter host password for user 'elastic':
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 6u32gD6mQ0yMO3ZsNZ0Cjg   1   0          0            0       225b           225b
yellow open   ind-3 2k_2F0x6TtGZ9GpMv8FHRA   4   2          0            0       900b           900b
yellow open   ind-2 3XzVhRyETkmKJpzA1x9nUg   2   1          0            0       450b           450b
vagrant@server1:~/HW6.5$


vagrant@server1:~/HW6.5$ curl -k -X GET https://localhost:9200/_cluster/health -u elastic | python3 -m json.tool
Enter host password for user 'elastic':
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   404  100   404    0     0   7087      0 --:--:-- --:--:-- --:--:--  7087
{
    "cluster_name": "netology_test",
    "status": "yellow",
    "timed_out": false,
    "number_of_nodes": 1,
    "number_of_data_nodes": 1,
    "active_primary_shards": 9,
    "active_shards": 9,
    "relocating_shards": 0,
    "initializing_shards": 0,
    "unassigned_shards": 10,
    "delayed_unassigned_shards": 0,
    "number_of_pending_tasks": 0,
    "number_of_in_flight_fetch": 0,
    "task_max_waiting_in_queue_millis": 0,
    "active_shards_percent_as_number": 47.368421052631575
}
vagrant@server1:~/HW6.5$
```

Часть индексов и кластер находятся в состоянии yellow, так как кластер состоит из всего одной ноды, соответственно и primary шарды и реплики находятся на одной и той же ноде. Это конфигурация без резервирования и не рекомендована к использованию в продуктивной среде.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

Ответ:

```
[elasticsearch@5fe07caceb5e snapshots]$ curl -k -XPOST https://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs",
 "settings": { "location":"/elasticsearch-8.1.1/snapshots" }}' -u elastic
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
[elasticsearch@5fe07caceb5e snapshots]$


vagrant@server1:~/HW6.5$ curl -k -X PUT https://localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replic
as": 0 }}' -u elastic
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}vagrant@server1:~/HW6.5$
vagrant@server1:~/HW6.5$

vagrant@server1:~/HW6.5$ curl -k -X PUT https://localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true -u elastic
Enter host password for user 'elastic':
{"snapshot":{"snapshot":"elasticsearch","uuid":"VEuhsET7QCKaqD84N63bLg","repository":"netology_backup","version_id":8010199,"version":"8.1.1","indices":["test",".security-7",".geoip_databases"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-08-11T00:19:16.235Z","start_time_in_millis":1660177156235,"end_time":"2022-08-11T00:19:17.438Z","end_time_in_millis":1660177157438,"duration_in_millis":1203,"failures":[],"shards":{"total":3,"failed":0,"successful":3},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]},{"feature_name":"security","indices":[".security-7"]}]}}vagrant@server1:~/HW6.5$
vagrant@server1:~/HW6.5$


[elasticsearch@5fe07caceb5e elasticsearch-8.1.1]$ cd snapshots/
[elasticsearch@5fe07caceb5e snapshots]$ ll
total 36
-rw-r--r-- 1 elasticsearch elasticsearch  1098 Aug 11 00:19 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Aug 11 00:19 index.latest
drwxr-xr-x 5 elasticsearch elasticsearch  4096 Aug 11 00:19 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18456 Aug 11 00:19 meta-VEuhsET7QCKaqD84N63bLg.dat
-rw-r--r-- 1 elasticsearch elasticsearch   389 Aug 11 00:19 snap-VEuhsET7QCKaqD84N63bLg.dat
[elasticsearch@5fe07caceb5e snapshots]$

vagrant@server1:~/HW6.5$ curl -k -X GET https://localhost:9200/_cat/indices?v -u elastic
Enter host password for user 'elastic':
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 -wQa2PIKS4-JtNErIdTBGg   1   0          0            0       225b           225b
vagrant@server1:~/HW6.5$


vagrant@server1:~/HW6.5$ curl -k -X POST https://localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"inc
lude_global_state":true}' -u elastic
Enter host password for user 'elastic':
{
  "accepted" : true
}
vagrant@server1:~/HW6.5$
vagrant@server1:~/HW6.5$
vagrant@server1:~/HW6.5$ curl -k -X GET https://localhost:9200/_cat/indices?v -u elastic
Enter host password for user 'elastic':
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 -wQa2PIKS4-JtNErIdTBGg   1   0          0            0       225b           225b
green  open   test   QAXhlqTGRtejYYtmDYdtCw   1   0          0            0       225b           225b
vagrant@server1:~/HW6.5$
```
