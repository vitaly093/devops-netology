1. Ответ: системный вызов команды cd: chdir("/tmp")

2. Ответ: в man file указано, что это /usr/share/misc/magic.mgc, в тексте strace это строка: openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3

3. Ответ: Если файл удален, но при этом его экземпляр все еще открыт какой-то программой, то такой файл может быть расположен в каталоге ядра. Таким образом уудаленного экземпляра файла есть свой файловый дескриптор, в который можно передать на вход какую-то информацию. Например пустую строку, тем самым затерев содержимое файла. 

Пример: если открыть текстовый файл для редактирования в текстовом редакторе vim, то у такого файла будет создана копия .swp. Эта копия используется для изменения и сохранения текста в ней.

Этот .swp файл можно удалить при открытом vim, работающим с этим файлом, и тогда у такого файла вывод lsof покажет следующее (deleted):

vagrant@vagrant:~/test$ lsof | grep delet

vim       1853                       vagrant    4u      REG              253,0    12288     131090 /home/vagrant/test/.test2.swp (deleted) 

Далее если передать на вход файловому дескриптору 4 пустую строку:

echo '' >/proc/1853/fd/4

то файл перезапишется:

vagrant@vagrant:~/test$ lsof | grep delet

vim       1853                       vagrant    4u      REG              253,0        1     131090 /home/vagrant/test/.test2.swp (deleted) 

Из вывода видно, что размер файла равен 1.



4. Нет, зомби-процессы не занимают ресурсов хоста, за исключением строки записи в таблице процессов.


5. Ответ: openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/site.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3

vagrant@vagrant:~$ sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
783    vminfo              4   0 /var/run/utmp
578    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
578    dbus-daemon        18   0 /usr/share/dbus-1/system-services
578    dbus-daemon        -1   2 /lib/dbus-1/system-services
578    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
597    irqbalance          6   0 /proc/interrupts
597    irqbalance          6   0 /proc/stat
597    irqbalance          6   0 /proc/irq/20/smp_affinity
597    irqbalance          6   0 /proc/irq/0/smp_affinity
597    irqbalance          6   0 /proc/irq/1/smp_affinity
597    irqbalance          6   0 /proc/irq/8/smp_affinity
597    irqbalance          6   0 /proc/irq/12/smp_affinity
597    irqbalance          6   0 /proc/irq/14/smp_affinity
597    irqbalance          6   0 /proc/irq/15/smp_affinity



6. Ответ: Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.


7. Ответ: Последовательность команд через ';' - просто перечисление команд одна за одной. А последовательность команд связанная через && означается, что вторая команда будет выполнена только в том случае, если результат выполнения первой команды вернул значение логического TRUE (0 - выходной код)
Применять set -e нет смысла, так как set -e прерывает выполнение команд при условии, что хотя бы одна из них вернула ненулевой статус.


8. Ответ: опции команды set -euxo pipefail:

-e  Exit immediately if a command exits with a non-zero status.
-u  Treat unset variables as an error when substituting.
-x  Print commands and their arguments as they are executed.
If pipefail is enabled, the pipeline's return status is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands exit successfully.

Данный режим хорошо использовать в сценариях, потому что в случае ошибок, выполнение сценария прекратится, а также позволит выводить на экран команды и действия, то есть производить подобие логирования.


9. Ответ: 

STAT
Ss
R+

Доп символы - доп харакетристика состония процесса, например:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
