# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

Ответ:
```
Выполнено

~/netology/DevOps/devops-netology/HW8.2/playbook/inventory$ cat prod.yml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 51.250.82.22
vector:
  hosts:
    vector-01:
      ansible_host: 51.250.70.108
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

Ответ:

```
~/netology/DevOps/devops-netology/HW8.2/playbook$ cat site.yml
---
- name: Install Clickhouse
  hosts: clickhouse
  become: yes
  become_user: root
  remote_user: centos
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Start clickhous serv
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted

    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0

- name: Install vector
  hosts: vector
  become: yes
  become_user: root
  remote_user: ubuntu
  tasks:
    - name: Make a directory for vector
      ansible.builtin.command: mkdir -p vector

    - name: Get vector distr
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/0.23.3/vector-0.23.3-x86_64-unknown-linux-musl.tar.gz"
        dest: "./vector/vector-0.23.3-x86_64-unknown-linux-musl.tar.gz"

    - name: Extract vector distr
      ansible.builtin.unarchive:
        remote_src: yes
        src: "/home/ubuntu/vector/vector-0.23.3-x86_64-unknown-linux-musl.tar.gz"
        dest: "/home/ubuntu/vector"
        extra_opts: [--strip-components=2]

    - name: Move Vector into Path environment variable
      ansible.builtin.shell: cd /home/ubuntu/ && echo "export PATH=\"$(pwd)/vector/bin:\$PATH\"" >> /home/ubuntu/.profile
      args:
        executable: /bin/bash

    - name: Enable user profile with additions to PATH
      ansible.builtin.shell: source /home/ubuntu/.profile
      args:
        executable: /bin/bash

    - name: Create user vector
      ansible.builtin.user:
         name: vector
         shell: /bin/bash
         append: yes

    - name: Create dir for vector config
      become: true
      ansible.builtin.file:
        path: /etc/vector
        owner: vector
        state: directory
        mode: 0755

    - name: Create dir for vector data
      become: true
      ansible.builtin.file:
        path: /var/lib/vector
        owner: vector
        state: directory
        mode: 0755


    - name: status check
      become: true
      ansible.builtin.shell: systemctl status vector
      args:
        executable: /bin/bash
      register: result

    - name: Copy exec and config files
      ansible.builtin.shell: cp /home/ubuntu/vector/bin/vector /usr/bin && cp /home/ubuntu/vector/etc/systemd/vector.default /etc/default && cp /home/ubuntu/vector/config/vector.toml /etc/vector
      args:
        executable: /bin/bash
      when: result is failed

    - name: Start Vector
      become: true
      ansible.builtin.shell: cp -av /home/ubuntu/vector/etc/systemd/vector.service /etc/systemd/system && systemctl start vector
      args:
        executable: /bin/bash
```
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

Ответ:
```
Было несколько ошибок, но они исправлены:

~/netology/DevOps/devops-netology/HW8.2/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml

PLAY [Install Clickhouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Start clickhous serv] *********************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] **************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install vector] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Make a directory for vector] **************************************************************************************************************************************************************
changed: [vector-01]

TASK [Get vector distr] *************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Extract vector distr] *********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Move Vector into Path environment variable] ***********************************************************************************************************************************************
changed: [vector-01]

TASK [Enable user profile with additions to PATH] ***********************************************************************************************************************************************
changed: [vector-01]

TASK [Create user vector] ***********************************************************************************************************************************************************************
[WARNING]: 'append' is set, but no 'groups' are specified. Use 'groups' for appending new groups.This will change to an error in Ansible 2.14.
ok: [vector-01]

TASK [Create dir for vector config] *************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create dir for vector data] ***************************************************************************************************************************************************************
changed: [vector-01]

TASK [Copy exec and config files] ***************************************************************************************************************************************************************
changed: [vector-01]

TASK [Start Vector] *****************************************************************************************************************************************************************************
changed: [vector-01]

PLAY RECAP **************************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=11   changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

Ответ:

```
~/netology/DevOps/devops-netology/HW8.2/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Start clickhous serv] *********************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] **************************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install vector] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Make a directory for vector] **************************************************************************************************************************************************************
skipping: [vector-01]

TASK [Get vector distr] *************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Extract vector distr] *********************************************************************************************************************************************************************
skipping: [vector-01]

TASK [Move Vector into Path environment variable] ***********************************************************************************************************************************************
skipping: [vector-01]

TASK [Enable user profile with additions to PATH] ***********************************************************************************************************************************************
skipping: [vector-01]

TASK [Create user vector] ***********************************************************************************************************************************************************************
[WARNING]: 'append' is set, but no 'groups' are specified. Use 'groups' for appending new groups.This will change to an error in Ansible 2.14.
ok: [vector-01]

TASK [Create dir for vector config] *************************************************************************************************************************************************************
skipping: [vector-01]

TASK [Create dir for vector data] ***************************************************************************************************************************************************************
skipping: [vector-01]

TASK [Copy exec and config files] ***************************************************************************************************************************************************************
skipping: [vector-01]

TASK [Start Vector] *****************************************************************************************************************************************************************************
skipping: [vector-01]

PLAY RECAP **************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=1    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=6    rescued=0    ignored=0
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Ответ:

```
~/netology/DevOps/devops-netology/HW8.2/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Start clickhous serv] *********************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] **************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install vector] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Make a directory for vector] **************************************************************************************************************************************************************
changed: [vector-01]

TASK [Get vector distr] *************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Extract vector distr] *********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Move Vector into Path environment variable] ***********************************************************************************************************************************************
changed: [vector-01]

TASK [Enable user profile with additions to PATH] ***********************************************************************************************************************************************
changed: [vector-01]

TASK [Create user vector] ***********************************************************************************************************************************************************************
[WARNING]: 'append' is set, but no 'groups' are specified. Use 'groups' for appending new groups.This will change to an error in Ansible 2.14.
ok: [vector-01]

TASK [Create dir for vector config] *************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create dir for vector data] ***************************************************************************************************************************************************************
ok: [vector-01]

TASK [status check] *****************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Copy exec and config files] ***************************************************************************************************************************************************************
skipping: [vector-01]

TASK [Start Vector] *****************************************************************************************************************************************************************************
changed: [vector-01]

PLAY RECAP **************************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=11   changed=5    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

vfkuhtenko@SC-WS-00042:~/netology/DevOps/devops-netology/HW8.2/playbook$
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

Ответ: плейбук идемпотентен

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
