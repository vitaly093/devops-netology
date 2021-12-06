1. Ответ: сделано

![image](https://user-images.githubusercontent.com/60869933/144918070-6769d860-1005-4212-9549-ea96f3826c2f.png)






2. 2FA настроена через приложение Microsoft Authenticator.

![image](https://user-images.githubusercontent.com/60869933/144919840-bd27dd48-6c80-4f43-898b-9f59d12a8506.png)






3. It worked!

![image](https://user-images.githubusercontent.com/60869933/144924706-f1875d50-c9fd-4c95-bee4-1c824c2a93a0.png)




4. Проверил сайт www.sberbank.ru

```bash
###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


 Start 2021-12-06 21:30:33        -->> 194.54.14.168:443 (www.sberbank.ru) <<--

 rDNS (194.54.14.168):   --
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session ticket extension
 ROBOT                                     Server does not support any cipher suites that use RSA key transport
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=7D284FC9A071C899C816BE81A90D6931E9FBDE9B2E759D18D542C40697A47CB6 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers
                                           But: Unknown DH group (1024 bits)
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     not vulnerable (OK)
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK) - ARIA, CHACHA or CCM ciphers found
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-06 21:31:01 [  31s] -->> 194.54.14.168:443 (www.sberbank.ru) <<--


root@vagrant:~/testssl.sh#
``` 





5. Выполнено: я скопировал ssh ключ, сгенерированный в windows wsl в виртуальную машину ubuntu, которая создавалась в рамках курса. Из под wsl я могу зайти на нее по ssh по ключу (без ввода пароля):


```
vfkuhtenko@SC-:~/.ssh$ ssh vagrant@192.168.56.5
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon 06 Dec 2021 10:48:06 PM UTC

  System load:  0.0               Users logged in:         1
  Usage of /:   2.6% of 61.31GB   IPv4 address for dummy0: 10.2.2.2
  Memory usage: 16%               IPv4 address for eth0:   10.0.2.15
  Swap usage:   0%                IPv4 address for eth1:   192.168.56.5
  Processes:    124


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Mon Dec  6 22:40:26 2021 from 192.168.56.1
vagrant@vagrant:~$
vagrant@vagrant:~$ tty
/dev/pts/1
```




6. Настроено:

```

vfkuhtenko@SC-:~/.ssh$ cat config
Host Ubuntu20.04
      HostName 192.168.56.5
      User vagrant
      IdentityFile /home/vfkuhtenko/.ssh/id_ed25519
vfkuhtenko@SC-:~/.ssh$



vfkuhtenko@SC-:~/.ssh$ ssh Ubuntu20.04
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon 06 Dec 2021 11:32:17 PM UTC

  System load:  0.0               Users logged in:         1
  Usage of /:   2.6% of 61.31GB   IPv4 address for dummy0: 10.2.2.2
  Memory usage: 16%               IPv4 address for eth0:   10.0.2.15
  Swap usage:   0%                IPv4 address for eth1:   192.168.56.5
  Processes:    117


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Mon Dec  6 23:32:05 2021 from 192.168.56.1
vagrant@vagrant:~$
```



7. Выполнено:

```bash

root@vagrant:/home/vagrant# tcpdump -i eth0 -c 100 -n -w dump100.pcap
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
173 packets received by filter
0 packets dropped by kernel



