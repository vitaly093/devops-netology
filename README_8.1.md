# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

Ответ:
```
~/netology/DevOps/HW8.1/playbook$ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *********************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


Переменная some_fact имеет значение "12"
```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

Ответ:

```
~/netology/DevOps/HW8.1/playbook$ cat group_vars/all/examp.yml
---
  some_fact: "all default fact"


~/netology/DevOps/HW8.1/playbook$ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *********************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

Ответ:

```
Поднята ВМ, внутри которой создано и запущено два контейнера с соответствующими названиями (centos7 и ubuntu) и версиями ОС.
```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

Ответ:
```
vagrant@server1:~/HW8.1/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb"
}
ok: [centos7] => {
    "msg": "el"
}

PLAY RECAP **********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@server1:~/HW8.1/playbook$

some_fact для ubuntu = deb
some_fact для centos7 = el

```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

Ответ:

```
Выполнено
```
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

Ответ:

```
vagrant@server1:~/HW8.1/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@server1:~/HW8.1/playbook$
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

Ответ:

```
vagrant@server1:~/HW8.1/playbook$ ansible-vault encrypt ./group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
vagrant@server1:~/HW8.1/playbook$
vagrant@server1:~/HW8.1/playbook$
vagrant@server1:~/HW8.1/playbook$ ansible-vault encrypt ./group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
vagrant@server1:~/HW8.1/playbook$
vagrant@server1:~/HW8.1/playbook$
vagrant@server1:~/HW8.1/playbook$ cat ./group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
36353965646561343231643535623239643235393866356664383762633462376439316262616433
6236653433656635316566373532333635393562656633350a353034363566613265303365316535
35383831326362613363306633363865306138323735336637316237323866636130373330333266
3561616362623963370a333366346537386531626137313466636263326130613764653834623238
62626335366238346562663932313434343362613634646235366530653336356230383761313531
3034373434363932663465303762386638363261633336653162
vagrant@server1:~/HW8.1/playbook$
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

Ответ:

```
vagrant@server1:~/HW8.1/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@server1:~/HW8.1/playbook$
```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

Ответ:

```
требуется local
```
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

Ответ:
```
Выполнено
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

Ответ:

```
vagrant@server1:~/HW8.1/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@server1:~/HW8.1/playbook$
```
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

Ответ:

```
Выполнено
```

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

