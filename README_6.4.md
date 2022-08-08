# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

Ответ:
```
postgres=# \l			#вывод списка БД
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=#

postgres=# \c			#подключение к БД
You are now connected to database "postgres" as user "postgres".
postgres=#

postgres=# \dt			#вывод списка таблиц
Did not find any relations.
postgres=#

\d[S+] NAME			#вывод содержимого таблиц

postgres=# \q
root@b740b59e3232:/data/test_data#

```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

Ответ:

```

root@b740b59e3232:/data/test_data# psql -d test_database -f /data/test_data/test_dump.sql -U postgres
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
root@b740b59e3232:/data/test_data#


test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#

test_database=#  select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)

test_database=# 		#получается второй столбец вышел самый большой
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Ответ: Для выполнения задания, необходимо преобразовать существующую таблицу в партиционированную и далее разбить ее на два сегмента, после чего заполнить данными.

```
test_database=# alter table orders rename to orders_old;
ALTER TABLE
test_database=#
test_database=#
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_1 partition of orders for values from (0) to (500);
CREATE TABLE
test_database=# create table orders_2 partition of orders for values from (501) to (999999999);
CREATE TABLE
test_database=#

test_database=# insert into orders (id, title, price) select * from orders_old;
INSERT 0 8
test_database=#
```
Вероятно на этап проектирования стоило сделть таблицу сразу партиционированной.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

Ответ:
```
root@b740b59e3232:/data/test_data# pg_dump -U postgres -d test_database >test_database_dump.sql
root@b740b59e3232:/data/test_data# ll
bash: ll: command not found
root@b740b59e3232:/data/test_data# ls -l
total 8
-rw-r--r-- 1 root root 3287 Aug  8 22:11 test_database_dump.sql
-rw-rw-r-- 1 1000 1000 2082 Feb  8  2021 test_dump.sql
root@b740b59e3232:/data/test_data#
```

Для столбца Title можно создать первичный ключ или индекс.
---
