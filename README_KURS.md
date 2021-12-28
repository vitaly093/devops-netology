1. ВМ создана


2. ufw установлен и настроен:


```bash

apt install ufw

sudo ufw allow in 443/tcp

sudo ufw allow in 22/tcp

sudo ufw allow out on lo from any to any

sudo ufw allow in on lo from any to any

root@vagrant:~# ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
443/tcp                    ALLOW IN    Anywhere
22/tcp                     ALLOW IN    Anywhere
Anywhere on lo             ALLOW IN    Anywhere
443/tcp (v6)               ALLOW IN    Anywhere (v6)
22/tcp (v6)                ALLOW IN    Anywhere (v6)
Anywhere (v6) on lo        ALLOW IN    Anywhere (v6)

Anywhere                   ALLOW OUT   Anywhere on lo
Anywhere (v6)              ALLOW OUT   Anywhere (v6) on lo
```

3. Ответ: Установлено:

```bash

apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

apt-get update && sudo apt-get install vault

root@vagrant:~/cert_gen# vault
Usage: vault <command> [args]

Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit          Interact with audit devices
    auth           Interact with auth methods
    debug          Runs the debug command
    kv             Interact with Vault's Key-Value storage
    lease          Interact with leases
    monitor        Stream log messages from a Vault server
    namespace      Interact with namespaces
    operator       Perform operator-specific tasks
    path-help      Retrieve API help for paths
    plugin         Interact with Vault plugins and catalog
    policy         Interact with policies
    print          Prints runtime configurations
    secrets        Interact with secrets engines
    ssh            Initiate an SSH session
    token          Interact with tokens

```

4. Ответ: центр сертификации создан, сертификат выпущен:

```bash

root@vagrant:~/cert_gen# openssl crl2pkcs7 -nocrl -certfile /etc/ssl/chain_test_1.crt | openssl pkcs7 -print_certs -noout
subject=CN = course.vitaly.ru

issuer=CN = vitaly.ru Intermediate Authority


subject=CN = vitaly.ru Intermediate Authority

issuer=CN = vitaly.ru
```


5. Выполнено



6. Nginx установлен:

```bash

apt update
apt install nginx
```

7. Конфигурация SSL:

```bash
root@vagrant:~/cert_gen# cat /etc/nginx/sites-available/default

# Default server configuration
#
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        listen 443 ssl;
        ssl_certificate         /etc/ssl/chain_test_1.crt;
        ssl_certificate_key     /etc/ssl/priv_7.key;


        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

```

Далее в директорию /etc/ssl/ добавляются сгененированные файлы сертификата - chain_test_1.crt и приватный ключ - priv_7.key.

Была также изменена стартовая страница nginx:

```bash
root@vagrant:~/cert_gen# cat /var/www/html/index.nginx-debian.html
<!DOCTYPE html>
<html>
<head>
<title>Coursework is done!</title>
<style>
    body {
        width: 40em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Coursework is done!</h1>
<p>This coursework was done by Vitaly Kukhtenko</p>

<p><em>Thank you for your attention</em></p>
</body>
</html>
root@vagrant:~/cert_gen#
```


8. Ответ:

![image](https://user-images.githubusercontent.com/60869933/147604465-527751d8-c245-4c63-b6d0-125861b6f690.png)



9. Скрипт генерации сертификата:

```bash

root@vagrant:~/cert_gen# cat cert_gen.sh
#!/usr/bin bash
PATH=/root/cert_gen:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
screen -dmS VAULT vault server -dev -dev-root-token-id root
sleep 1
bash /root/cert_gen/cert1.sh
pgrep -f vault | xargs kill
screen -S VAULT -X quit
unset VAULT_ADDR VAULT_TOKEN
cat /root/cert_gen/cert_value.crt | jq -r .data.certificate > /etc/ssl/chain_test_1.crt
cat /root/cert_gen/cert_value.crt | jq -r .data.issuing_ca >> /etc/ssl/chain_test_1.crt
#cat intermediate.cert.pem >> /etc/ssl/chain_test_1.crt
#cat CA_cert.crt >> /etc/ssl/chain_test_1.crt
cat /root/cert_gen/cert_value.crt | jq -r .data.private_key > /etc/ssl/priv_7.key
nginx -s reload

```


В отдельном скрипте - cert1.sh в целях повышения читабельности кода вынесены команды по генерации собственно сертификата:

```bash
root@vagrant:~/cert_gen# cat cert1.sh
#!/usr/bin bash
PATH=/root/cert_gen:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal \
     common_name="vitaly.ru" \
     ttl=87600h > /root/cert_gen/CA_cert.crt
vault write pki/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int
vault write -format=json pki_int/intermediate/generate/internal \
     common_name="vitaly.ru Intermediate Authority" \
     | jq -r '.data.csr' > /root/cert_gen/pki_intermediate.csr
vault write -format=json pki/root/sign-intermediate csr=@/root/cert_gen/pki_intermediate.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > /root/cert_gen/intermediate.cert.pem
vault write pki_int/intermediate/set-signed certificate=@/root/cert_gen/intermediate.cert.pem
vault write pki_int/roles/example-dot-com \
     allowed_domains="vitaly.ru" \
     allow_subdomains=true \
     max_ttl="720h"
vault write -format=json pki_int/issue/example-dot-com common_name="course.vitaly.ru" ttl="30d" > /root/cert_gen/cert_value.crt
root@vagrant:~/cert_gen#

```

Скрипт работоспособен. Проверял так: запускал скрипт вручную:

```bash

root@vagrant:~/cert_gen# bash cert_gen.sh
Success! Enabled the pki secrets engine at: pki/
Success! Tuned the secrets engine at: pki/
Success! Data written to: pki/config/urls
Success! Enabled the pki secrets engine at: pki_int/
Success! Tuned the secrets engine at: pki_int/
Success! Data written to: pki_int/intermediate/set-signed
Success! Data written to: pki_int/roles/example-dot-com
No screen session found.
root@vagrant:~/cert_gen#

```

Далее копировал содежимое файла CA_cert.crt на хостовую машину и устанавливал сертификат в доверенные корневые центры сертификации. Каждый раз страница nginx успешно открывалась без предупреждений безопасности в браузере.

Добавил строку 

```
192.168.56.5 course.vitaly.ru
```

в файл hosts, чтобы на хостовой машине имя в адресной строке браузера резолвилось в IP адрес сетевого интерейса поднятой ВМ.

10. crontab настроен на выполнение каждый месяц 1-го числа в 5 часов утра:

```bash

root@vagrant:~/cert_gen# crontab -l
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
PATH=/root/cert_gen:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
SHELL=/bin/bash
0 5 1 * * bash /root/cert_gen/cert_gen.sh
root@vagrant:~/cert_gen#

```

Для проверки запустил задание на выполнение каждую минуту:

```bash
* * * * * bash /root/cert_gen/cert_gen.sh 
```

Файлы сертификатов успешно обновляются:

```bash
root@vagrant:~/cert_gen# ll
total 40
drwxrwxrwx 2 root root 4096 Dec 29 02:20 ./
drwx------ 6 root root 4096 Dec 29 02:30 ../
-rw-r--r-- 1 root root 1163 Dec 29 02:30 CA_cert.crt
-rwxrwxrwx 1 root root 1367 Dec 29 02:11 cert1.sh*
-rwxrwxrwx 1 root root  690 Dec 29 02:19 cert_gen.sh*
-rw-r--r-- 1 root root 6049 Dec 29 02:30 cert_value.crt
-rw-r--r-- 1 root root  374 Dec 29 02:30 cron.log
-rw-r--r-- 1 root root 1322 Dec 29 02:30 intermediate.cert.pem
-rw-r--r-- 1 root root  924 Dec 29 02:30 pki_intermediate.csr
root@vagrant:~/cert_gen#
root@vagrant:~/cert_gen#
root@vagrant:~/cert_gen# date
Wed 29 Dec 2021 02:30:10 AM MSK
```
