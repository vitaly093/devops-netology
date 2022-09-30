# Домашнее задание к занятию "8.4 Работа с Roles"

## Подготовка к выполнению
1. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
2. Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```
Ответ: выполнено
```
~/netology/DevOps/devops-netology/HW8.3.1/playbook$ cat requirements.yml
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.11.0"
    name: clickhouse
```

2. При помощи `ansible-galaxy` скачать себе эту роль.
Ответ: выполнено

3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
Ответ: выполнено

4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
Ответ: заполнено (переменные не использовал)
```
~/netology/DevOps/devops-netology/HW8.3.1/playbook/roles/vector-role/tasks$ cat main.yml
---
#name: Install vector

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
```
5. Перенести нужные шаблоны конфигов в `templates`.
Ответ: шаблоны не использовал

6. Описать в `README.md` обе роли и их параметры.

Ответ:

Роль clickhouse устанавливает и настраивает БД clickhouse на указанный хост, роль взята из репозитория ролей - ansible-galaxy.
Роль vector-role устанавливает vector на указанный хост.

7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
Ответ: выполнено

8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.
Ответ: для ускорения выполнения задачи, разместил все роли в одном репозитории, но в разных папках. Поэтому данный пункт не получится выполнить. 
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
Ответ: выполнено

```
~/netology/DevOps/devops-netology/HW8.3.1/playbook$ cat site.yml
---
- name: Install Clickhouse
  hosts: clickhouse
  become: yes
  become_user: root
  remote_user: centos
  roles:
    - clickhouse

- name: Install vector
  hosts: vector
  become: yes
  become_user: root
  remote_user: ubuntu
  roles:
    - vector-role

- name: Install lighthouse
  hosts: lighthouse
  become: yes
  become_user: root
  remote_user: ubuntu
  roles:
    - lighthouse-role
```

10. Выложите playbook в репозиторий.
Ответ: выложил
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
