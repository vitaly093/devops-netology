1. Ответ: ответ на запрос GET был с кодом 301 - Moved Permanently. Это означает, что ресурс по запрошенному адресу переместился на другой адрес, а именно: location: https://stackoverflow.com/questions


vfkuhtenko@SC-:~$ telnet stackoverflow.com 80
Trying 151.101.65.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: b16f5aad-1554-4f67-8691-3158be648c3f
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Sat, 04 Dec 2021 23:52:54 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-fra19128-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1638661974.415858,VS0,VE92
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=a19134af-f525-6a03-2936-2c438b5b3216; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.


2. Ответ: 

код ответа в браузере: 307 internal redirect
дольше всего обрабатывался запрос https://sb.scorecardresearch.com/cs/17440561/beacon.js
скриншот:

![image](https://user-images.githubusercontent.com/60869933/144728394-08c1ce2f-26fd-420d-9cb7-0ca35348dca3.png)



3. Ответ: мой IP: 185.13.112.230

![image](https://user-images.githubusercontent.com/60869933/144728463-8ab97184-21b7-4676-b28a-b7c5feb1f5b6.png)


4. Ответ: 

- провайдер: Morton Telecom Ltd.
- AS num: AS29069
- вывод whois:

vfkuhtenko@SC-:~$ whois 185.13.112.230
% This is the RIPE Database query service.
% The objects are in RPSL format.
%
% The RIPE Database is subject to Terms and Conditions.
% See http://www.ripe.net/db/support/db-terms-conditions.pdf

% Note: this output has been filtered.
%       To receive output for a database update, use the "-B" flag.

% Information related to '185.13.112.0 - 185.13.113.255'

% Abuse contact for '185.13.112.0 - 185.13.113.255' is 'info@mtel.ru'

inetnum:        185.13.112.0 - 185.13.113.255
netname:        MTEL-1
descr:          JSK "Morton-Telekom"
country:        ru
org:            ORG-ML207-RIPE
admin-c:        AK10545-RIPE
tech-c:         AK10545-RIPE
status:         ASSIGNED PA
mnt-by:         MORTONTEL-MNT
mnt-lower:      MORTONTEL-MNT
mnt-routes:     MORTONTEL-MNT
created:        2012-12-19T15:13:58Z
last-modified:  2012-12-19T15:13:58Z
source:         RIPE # Filtered

organisation:   ORG-ML207-RIPE
org-name:       Morton-Telekom Ltd
org-type:       OTHER
address:        Kievskoe shosse 22km,
                household 6 build. 1
address:        108811
address:        Moscow
address:        RUSSIAN FEDERATION
phone:          +74957410055
fax-no:         +74957410055
abuse-c:        AR13499-RIPE
mnt-ref:        MORTONTEL-MNT
mnt-ref:        TRANSLINECOM-MNT
mnt-by:         TRANSLINECOM-MNT
created:        2012-07-02T08:24:14Z
last-modified:  2018-05-28T11:21:55Z
source:         RIPE # Filtered

person:         Anton Kamynin
address:        Morton Telekom Ltd
address:        Kievskoe shosse 22km, household 6 build. 1
address:        Moscow, Russia
phone:          +74957410055
nic-hdl:        AK10545-RIPE
mnt-by:         MORTONTEL-MNT
created:        2012-12-13T14:34:47Z
last-modified:  2017-05-03T12:44:08Z
source:         RIPE # Filtered

% Information related to '185.13.112.0/22AS29069'

route:          185.13.112.0/22
descr:          Morton Telecom Ltd.
origin:         AS29069
mnt-by:         TRANSLINECOM-MNT
created:        2014-02-13T17:42:11Z
last-modified:  2014-02-13T17:42:36Z
source:         RIPE

% This query was served by the RIPE Database Query Service version 1.101 (WAGYU)


5. Ответ: 

root@vagrant:~# traceroute 8.8.8.8 -An -I
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  0.236 ms  0.210 ms  0.201 ms
 2  192.168.1.1 [*]  1.336 ms  2.025 ms  2.015 ms
 3  172.16.16.8 [*]  2.731 ms  3.064 ms  3.058 ms
 4  172.31.5.1 [*]  4.437 ms  4.419 ms  4.409 ms
 5  185.13.115.85 [AS29069]  4.010 ms  3.995 ms  4.357 ms
 6  72.14.204.81 [AS15169]  4.348 ms  5.539 ms  5.372 ms
 7  108.170.250.129 [AS15169]  6.759 ms  4.275 ms  4.734 ms
 8  * * *
 9  * * *
10  74.125.253.94 [AS15169]  18.961 ms  19.630 ms  19.589 ms
11  172.253.64.51 [AS15169]  20.933 ms  21.961 ms  21.152 ms
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  8.8.8.8 [AS15169]  20.932 ms  25.444 ms  25.330 ms


6. Ответ: наибольшая задержка возникает на участке 209.85.249.158 - 172.253.64.51. По данным сервиса whois оба адреса принадлежат сети Google, то есть наибольшая задержка возникает внутри сети Google.

vagrant (10.0.2.15)                                                               2021-12-05T00:26:13+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                  Packets               Pings
 Host                                                           Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    10.0.2.2                                            0.0%    27    0.8   2.6   0.4  47.4   9.0
 2. AS???    192.168.1.1                                         0.0%    27    1.9  19.5   1.9 144.5  43.1
 3. AS???    172.16.16.8                                         0.0%    27    1.8  23.6   1.8 147.9  42.5
 4. AS???    172.31.5.1                                          0.0%    27    2.5  16.1   2.3  99.3  27.8
 5. AS29069  185.13.115.85                                       0.0%    27    8.3  12.9   2.7 108.1  22.7
 6. AS15169  72.14.204.81                                        0.0%    27    4.0  31.5   2.9 147.4  52.4
 7. AS15169  108.170.250.129                                     0.0%    27  156.5  33.0   3.6 157.8  49.0
 8. AS15169  108.170.250.146                                    88.9%    27    2.9  17.2   2.9  45.5  24.5
 9. AS15169  209.85.249.158                                     29.6%    27   20.4  31.8  20.3 151.4  30.5
10. AS15169  74.125.253.94                                       0.0%    27   17.8  40.1  17.4 168.5  46.5
11. AS15169  172.253.64.51                                       0.0%    27   19.9  42.3  19.6 158.3  44.2
12. (waiting for reply)
13. (waiting for reply)
14. (waiting for reply)
15. (waiting for reply)
16. (waiting for reply)
17. (waiting for reply)
18. (waiting for reply)
19. (waiting for reply)
20. (waiting for reply)
21. AS15169  8.8.8.8                                            32.0%    26   22.1  46.5  19.2 164.7  46.6


7. Ответ: чтобы получить ответ для dns.google, нужно пройти цепочку DNS серверов: корневой DNS сервер .                       6106    IN      NS      e.root-servers.net. -> DNS сервер, отвечающий за зону google: google.                 172800  IN      NS      ns-tld1.charlestonroadregistry.com. -> DNS сервер имеющий непосредственно интересующие нас записи: dns.google.             10800   IN      NS      ns2.zdns.google.

А записи:

dns.google.             900     IN      A       8.8.8.8
dns.google.             900     IN      A       8.8.4.4


8. Ответ: 


root@vagrant:~# dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 35776
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   6125    IN      PTR     dns.google.



root@vagrant:~# dig -x 8.8.4.4

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 1405
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   82840   IN      PTR     dns.google.

