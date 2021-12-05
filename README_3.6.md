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


