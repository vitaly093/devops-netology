## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?

Ответ: в режиме replication сервис работает только на некоторых нодах кластера (количество нод можно задать вручную), а в режиме global сервис работает на всех нодах кластера.

- Какой алгоритм выбора лидера используется в Docker Swarm кластере?

Ответ: выбор лидера в docker swarm является частью алгоритма поддержания распределенного консенсуса Raft и выполняется следующим образом:
все ноды, которые должны принять участие в выборе лидера (followers) ждут истечения счетчика election timeout, после чего становятся кандидатами на роль лидера. этот отрезок времени выбирается произвольно и может быть в пределах от 150 мс до 300 мс. 
По истечению времени election timeout кандидат отсылает Request Vote сообщения другим нодам кластера. Для того, чтобы стать лидером, нода отославшая Request Vote должна получить наибольшее число "голосов". После этого она становится лидером.

- Что такое Overlay Network?

Overlay сеть - это логическая сеть, организованная "поверх" другой (underlay) сети. Такая сеть позволяет объединить несколько демонов докер в кластере между собой и таким образом организовать docker swarm кластер. Узлы такой сети могут связаны логическим соединением, для которого на уровне физической сети существуют соответствующие маршруты.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
[centos@node03 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
ci93sqn67hno3d653o9ou0lkg     node01.netology.yc   Ready     Active         Reachable        20.10.12
60vic25mlen7cs3ep552iewjo     node02.netology.yc   Ready     Active         Reachable        20.10.12
6gq0rzhe2udgdn3iz8tuu3rv2 *   node03.netology.yc   Ready     Active         Leader           20.10.12
p3eyme3tfc49tlc6d5vtwnvuo     node04.netology.yc   Ready     Active                          20.10.12
y0tksy9vtxsw5x4x2xb7ulnya     node05.netology.yc   Ready     Active                          20.10.12
pt9j74txf17x10epu1f56xsui     node06.netology.yc   Ready     Active                          20.10.12
[centos@node03 ~]$
```
![image](https://user-images.githubusercontent.com/60869933/154865414-1cade9c3-9ee8-4fac-9ae2-166f567712d3.png)


## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
[centos@node01 ~]$ sudo docker service ls
ID             NAME                             MODE         REPLICAS   IMAGE                                          PORTS
yj5lv4q371u4   swarm_monitoring_alertmanager    replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
mokb0gml29qx   swarm_monitoring_caddy           replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
0ztbmyktpzwa   swarm_monitoring_grafana         replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
4azxj5qurwgu   swarm_monitoring_node-exporter   global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
uri76p1rs3bn   swarm_monitoring_prometheus      replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
0p7k1t1yc624   swarm_monitoring_unsee           replicated   1/1        cloudflare/unsee:v0.8.0
```

![image](https://user-images.githubusercontent.com/60869933/154865443-5e3479c3-f731-4d7c-ac5c-527674bb722e.png)


## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true

[centos@node03 ~]$ sudo docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-3jfkjuG1Ij5YtzvoEJz3llPCW89RMn3p5u1Ejy9pWWM

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
[centos@node03 ~]$
```

Эта команда блокирует manager ноду docker swarm кластера после перезагрузки демона докера на ней. После перезагрузки демона докера будет невозможно выполнить какие-либо команды docker, например:
```
[centos@node03 ~]$ sudo docker service ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.
```

Это требуется для защиты ключа TLS и ключа, шифрующего raft-логи.
