# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | в таком виде как в скрипте переменной с не будет присвоено никакое значение, так как арифметическая операция сложения строковой и целочисленной переменной не выполнится с ошибкой о том, что строковую и целочисленную переменную складывать нельзя  |
| Как получить для переменной `c` значение 12?  | преобразовать "a" в строку: c = str(a) + b  |
| Как получить для переменной `c` значение 3?  | преобразовать "b" в число: c = a + int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd /home/vagrant/test_script", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
root@vagrant:/home/vagrant/test_script# git status
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   file2

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   file1
        modified:   script_4-2-2.py

root@vagrant:/home/vagrant/test_script#


root@vagrant:/home/vagrant/test_script# ./script_4-2-2.py
file1
script_4-2-2.py
root@vagrant:/home/vagrant/test_script#


```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

directory = sys.argv[1]
bash_command = [f"cd {directory}",  "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
root@vagrant:/home/vagrant/test_script# ./script_4-2-2.py /home/vagrant/test_script
file1
script_4-2-2.py
root@vagrant:/home/vagrant/test_script#
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import socket
import time
import os
respip_lst_cur = ['', '', '']
respip_lst_old = ['', '', '']
serv_lst = ['drive.google.com', 'mail.google.com', 'google.com']
for i in serv_lst:
    i_i = serv_lst.index(i)
    respip_lst_old[i_i] = socket.gethostbyname(serv_lst[i_i])
    #print(respip_lst_old[i_i])
    time.sleep(1)
while (1==1):
    for g in serv_lst:
        g_i = serv_lst.index(g)
        respip_lst_cur[g_i] = socket.gethostbyname(serv_lst[g_i])
        bash_command_out = [f"echo {serv_lst[g_i]} - {respip_lst_cur[g_i]}>&1"]
        os.popen(''.join(bash_command_out))
        output_normal = f'{serv_lst[g_i]} - {respip_lst_cur[g_i]}'
        print(output_normal)
        if respip_lst_old[g_i] != respip_lst_cur[g_i]:
            bash_command_err = [f"echo [ERROR] {serv_lst[g_i]} IP mismatch: {respip_lst_old[g_i]} - old IP, {respip_lst_cur[g_i]} - current IP>&1"]
            os.popen(''.join(bash_command_err))
            output_err = f'[ERROR] {serv_lst[g_i]} IP mismatch: {respip_lst_old[g_i]} - old IP, {respip_lst_cur[g_i]} - current IP'
            print(output_err)
        time.sleep(1)
    respip_lst_old = respip_lst_cur
```

### Вывод скрипта при запуске при тестировании:
```
root@vagrant:/home/vagrant/test_script# ./test_ip.py
drive.google.com - 142.251.1.194
mail.google.com - 64.233.165.19
[ERROR] mail.google.com IP mismatch: 64.233.165.83 - old IP, 64.233.165.19 - current IP
google.com - 64.233.161.113
[ERROR] google.com IP mismatch: 64.233.161.138 - old IP, 64.233.161.113 - current IP
drive.google.com - 142.251.1.194
mail.google.com - 64.233.165.19
google.com - 64.233.161.113
drive.google.com - 142.251.1.194
mail.google.com - 64.233.165.19
google.com - 64.233.161.113
drive.google.com - 142.251.1.194
^CTraceback (most recent call last):
  File "./test_ip.py", line 26, in <module>
    time.sleep(1)
KeyboardInterrupt
```
