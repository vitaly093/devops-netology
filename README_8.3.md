# Домашнее задание к занятию "08.03 Использование Yandex Cloud"

## Подготовка к выполнению

1. (Необязательно) Познакомтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)
2. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

Ответ: хосты подготовлены. информация о них в конфигурации терраформ.

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
Ответ: плейбук дописан
```
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

    - block:
        - name: status check
          become: true
          ansible.builtin.shell: systemctl status vector
          args:
            executable: /bin/bash
      rescue:
        - name: Copy exec and config files
          ansible.builtin.shell: cp /home/ubuntu/vector/bin/vector /usr/bin && cp /home/ubuntu/vector/etc/systemd/vector.default /etc/default && cp /home/ubuntu/vector/config/vector.toml /etc/vector 
          args:
            executable: /bin/bash
    
    - name: Start Vector
      become: true
      ansible.builtin.shell: cp -av /home/ubuntu/vector/etc/systemd/vector.service /etc/systemd/system && systemctl start vector
      args:
        executable: /bin/bash
       
- name: Install lighthouse
  hosts: lighthouse
  become: yes
  become_user: root
  remote_user: ubuntu
  tasks:
    - name: Upgrade the OS
      become: true
      ansible.builtin.apt:
        upgrade: dist

    - name: Install nginx
      become: true
      ansible.builtin.apt:
        name: nginx
        update_cache: yes

    - name: Install subversion
      become: true
      ansible.builtin.apt:
        name: subversion

    - name: Export lighthouse
      become: true
      ansible.builtin.shell: svn export https://github.com/VKCOM/lighthouse/trunk /home/ubuntu/lighthouse
      args:
        executable: /bin/bash

    - name: Change Config NGINX
      become: true
      ansible.builtin.shell: sed -i 's/root \/var\/www\/html;/root \/home\/ubuntu\/lighthouse;/' /etc/nginx/sites-enabled/default
      args:
        executable: /bin/bash

    - name: Reload nginx
      become: true
      ansible.builtin.shell: sudo nginx -s reload
      args:
        executable: /bin/bash
```

2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.
Ответ: inventory файл готов
```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 51.250.91.254 
vector:
  hosts:
    vector-01:
      ansible_host: 51.250.4.253
lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: 51.250.6.106
```
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
Ответ: ошибки проверил, лишние пробелы убрал

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
Ответ: выполнено

```
~/netology/DevOps/devops-netology/HW8.3/playbook$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] **************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 4, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Start clickhous serv] ************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] *****************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install vector] ******************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************
ok: [vector-01]

TASK [Make a directory for vector] *****************************************************************************************************************************************
skipping: [vector-01]

TASK [Get vector distr] ****************************************************************************************************************************************************
ok: [vector-01]

TASK [Extract vector distr] ************************************************************************************************************************************************
skipping: [vector-01]

TASK [Move Vector into Path environment variable] **************************************************************************************************************************
skipping: [vector-01]

TASK [Enable user profile with additions to PATH] **************************************************************************************************************************
skipping: [vector-01]

TASK [Create user vector] **************************************************************************************************************************************************
[WARNING]: 'append' is set, but no 'groups' are specified. Use 'groups' for appending new groups.This will change to an error in Ansible 2.14.
ok: [vector-01]

TASK [Create dir for vector config] ****************************************************************************************************************************************
ok: [vector-01]

TASK [Create dir for vector data] ******************************************************************************************************************************************
ok: [vector-01]

TASK [status check] ********************************************************************************************************************************************************
skipping: [vector-01]

TASK [Start Vector] ********************************************************************************************************************************************************
skipping: [vector-01]

PLAY [Install lighthouse] **************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Upgrade the OS] ******************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install nginx] *******************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install subversion] **************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Export lighthouse] ***************************************************************************************************************************************************
skipping: [lighthouse-01]

TASK [Change Config NGINX] *************************************************************************************************************************************************
skipping: [lighthouse-01]

TASK [Reload nginx] ********************************************************************************************************************************************************
skipping: [lighthouse-01]

PLAY RECAP *****************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=1    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0
lighthouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=6    rescued=0    ignored=0
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Ответ:
```
выполнено
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
