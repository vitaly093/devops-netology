# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

С исправлениями:

```
{
        "info" : "Sample JSON output from our service\t",
        "elements" :[
            { 
                "name" : "first",
                "type" : "server",
                "ip" : 7175 
            },
            { 
                "name" : "second",
                "type" : "proxy",
                "ip" : "71.78.22.43"
            }
        ]
    }
```
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import json
import yaml
import socket
import time
import os
respip_lst_cur = ['', '', '']
respip_lst_old = ['', '', '']
serv_lst = ['drive.google.com', 'mail.google.com', 'google.com']
serv_dict = { "drive.google.com": 'ip', "mail.google.com": 'ip', "google.com": 'ip' }
for i in serv_lst:
    i_i = serv_lst.index(i)
    respip_lst_old[i_i] = socket.gethostbyname(serv_lst[i_i])
    #print(respip_lst_old[i_i])
    time.sleep(1)
while (1==1):
    for g in serv_lst:
        g_i = serv_lst.index(g)
        respip_lst_cur[g_i] = socket.gethostbyname(serv_lst[g_i])
        serv_dict[g] = socket.gethostbyname(serv_lst[g_i])
        output_normal = f'{serv_lst[g_i]} - {respip_lst_cur[g_i]}'
        print(output_normal)
        if respip_lst_old[g_i] != respip_lst_cur[g_i]:
            bash_command_err = [f"echo [ERROR] {serv_lst[g_i]} IP mismatch: {respip_lst_old[g_i]} - old IP, {respip_lst_cur[g_i]} - current IP>&1"]
            os.popen(''.join(bash_command_err))
            output_err = f'[ERROR] {serv_lst[g_i]} IP mismatch: {respip_lst_old[g_i]} - old IP, {respip_lst_cur[g_i]} - current IP'
            print(output_err)
        time.sleep(1)
    respip_lst_old = respip_lst_cur
    with open('serv_dict_j.json', 'w') as f:
        json.dump(serv_dict, f)
    with open('serv_dict_y.yml', 'w') as y:
        y.write(yaml.dump(serv_dict))
```

### Вывод скрипта при запуске при тестировании:
```
root@vagrant:/home/vagrant/test_script# ./j_y.py
drive.google.com - 142.250.150.194
mail.google.com - 64.233.165.17
[ERROR] mail.google.com IP mismatch: 64.233.165.18 - old IP, 64.233.165.17 - current IP
google.com - 64.233.163.139
[ERROR] google.com IP mismatch: 64.233.163.113 - old IP, 64.233.163.139 - current IP
drive.google.com - 142.250.150.194
mail.google.com - 64.233.165.17
google.com - 64.233.163.139
drive.google.com - 142.250.150.194
mail.google.com - 64.233.165.17
^CTraceback (most recent call last):
  File "./j_y.py", line 28, in <module>
    time.sleep(1)
KeyboardInterrupt
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
root@vagrant:/home/vagrant/test_script# cat serv_dict_j.json
{"drive.google.com": "142.250.150.194", "mail.google.com": "64.233.165.17", "google.com": "64.233.163.139"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
root@vagrant:/home/vagrant/test_script# cat serv_dict_y.yml
drive.google.com: 142.250.150.194
google.com: 64.233.163.139
mail.google.com: 64.233.165.17
root@vagrant:/home/vagrant/test_script#
```
