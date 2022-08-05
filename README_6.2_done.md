# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

Ответ:
```
vagrant@server1:~/HW6.2$ cat docker-compose.yaml
version: '2.1'

networks:
  pg-net:
    driver: bridge

volumes:
    data: {}
    backup: {}

services:

  db:
    image: postgres
    container_name: postgres
    volumes:
      - /home/vagrant/HW6.2/data:/data
      - /home/vagrant/HW6.2/backup:/backup
    restart: always
    environment:
      POSTGRES_PASSWORD: admin
    networks:
      - pg-net
    ports:
      - 5432:5432

  adminer:
    image: adminer
    restart: always
    ports:
     - 8080:8080
    networks:
      - pg-net
vagrant@server1:~/HW6.2$ 
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
Ответ:
```
postgres=# CREATE USER test_admin_user  WITH LOGIN;
CREATE ROLE

postgres=# CREATE DATABASE test_db;
CREATE DATABASE
```
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
```
test_db=# CREATE TABLE orders (id SERIAL PRIMARY KEY, наименование text, цена INTEGER);
CREATE TABLE

test_db=# CREATE TABLE clients (id SERIAL, фамилия text, страна_проживания text, заказ serial references orders (id));
CREATE TABLE

test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)
```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
```
postgres=# grant all on database test_db to test_admin_user;
GRANT

```
- создайте пользователя test-simple-user  
```
postgres=# create user test_simple_user;
CREATE ROLE
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```
test_db=# grant select, insert, update, delete on table clients, orders to test_simple_user;
GRANT
```

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
![image](https://user-images.githubusercontent.com/60869933/183134667-4f9de30f-68a7-437c-90e7-ff9d1ed0bc74.png)

![image](https://user-images.githubusercontent.com/60869933/183134691-cf4bf991-f147-4ecc-99ff-0ede8f82eb05.png)

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```
test_db=#
select * from information_schema.table_privileges i where i.grantee in ('test_admin_user', 'test_simple_user');
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test_admin_user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | DELETE         | NO           | NO
(22 rows)

test_db=#
```
- список пользователей с правами над таблицами test_db
Предоставил выше

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

Ответ:

```
test_db=# insert into orders values (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# insert into clients values (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио',
'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=#

test_db=# select count (*) from orders;
 count
-------
     5
(1 row)

test_db=# select count (*) from clients;
 count
-------
     5
(1 row)

test_db=#
```
## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

Ответ:
```
update clients set заказ = 3 where id = 1;
update clients set заказ = 4 where id = 2;
update clients set заказ = 5 where id = 3;

test_db=# select * from clients as c where c.заказ != c.id ;
 id |       фамилия        | страна_проживания | заказ
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)

test_db=#
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

Ответ:
```
test_db=# explain select * from clients as c where c.заказ != c.id ;
                         QUERY PLAN
-------------------------------------------------------------
 Seq Scan on clients c  (cost=0.00..20.12 rows=806 width=72)
   Filter: ("заказ" <> id)
(2 rows)
test_db=#
```
Вывод explain показывает, что для выполнения запроса не потребовалось много ресурсов (0.00). Также указывается, что в запросе используется фильтр.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

Ответ: Для создания бэкапа будет использована утилита pg_dump.
```
root@b1b4f7797016:/# pg_dump -U postgres -f /backup/test_db.sql test_db
```
Согласно документации PostgreSQL для восстановления базы требуется воспользоваться функционалом psql, например так: psql имя_базы < файл_дампа. Однако перед этим должны быть созданы все пользователи, которые ранее имели доступ к объектам базы. А также создана сама база (без наполнения).

Контейнер с ранее созданной базой остановлен:
```
vagrant@server1:~/HW6.2$ docker-compose stop
Stopping postgres       ... done
vagrant@server1:~/HW6.2$
```
А также удаляем данные о старом контейнере.
```
vagrant@server1:~/HW6.2$ docker-compose down
Stopping postgres ... done
Removing postgres ... done
Removing network hw62_pg-net
vagrant@server1:~/HW6.2$
```
Создаем базу:
```
root@31b5e40eb47d:/# createdb -T template0 test_db
```
Создаем в ней пользователей:
```
test_db=# CREATE USER test_admin_user;
CREATE ROLE
test_db=# create user test_simple_user;
CREATE ROLE
test_db=#
```
Восстанавливаем базу:
```
root@31b5e40eb47d:/# psql -d test_db -f /backup/test_db.sql -U postgres
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
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      1
(1 row)

 setval
--------
      5
(1 row)

 setval
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
root@31b5e40eb47d:/#
```
Проверяем список таблиц:
```
test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)

test_db=#
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
