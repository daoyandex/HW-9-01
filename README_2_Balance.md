# Домашнее задание к занятию 9-02 «Кластеризация и балансировка нагрузки» `Alekseev Aleksandr`
Настраивать балансировку с помощью HAProxy
Настраивать связку HAProxy + Nginx

---

### Задание 1
Запустите два simple python сервера на своей виртуальной машине на разных портах
Установите и настройте HAProxy, воспользуйтесь материалами к лекции по ссылке
Настройте балансировку Round-robin на 4 уровне.
На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

![HAProxy in action](9-02-img-haproxy-task-1/HW-9-02-Nginx-HAProxy.png)
![haproxy.cfg](9-02-files-haproxy-task-1/haproxy.cfg)

### Задание 2
Запустите три simple python сервера на своей виртуальной машине на разных портах
Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4
HAproxy должен балансировать только тот http-трафик, который адресован домену example.local
На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.

<img src = "9-02-img-haproxy-task-2/HW-9-02-task-2-PythonServer-9997.png" width = 70%>
<img src = "9-02-img-haproxy-task-2/HW-9-02-task-2-PythonServer-9998.png" width = 70%>
<img src = "9-02-img-haproxy-task-2/HW-9-02-task-2-PythonServer-9999.png" width = 70%>

![HAProxy layer 7 stats](9-02-img-haproxy-task-2/HW-9-02-task-2-haproxy-layer-7-stats_.png)
![HAProxy - terminal](9-02-img-haproxy-task-2/HW-9-02-task-2-haproxy-layer-7-terminal.png)
![haproxy.cfg](9-02-files-haproxy-task-2/haproxy.cfg)


### Задание 3*
Настройте связку HAProxy + Nginx как было показано на лекции.
Настройте Nginx так, чтобы файлы .jpg выдавались самим Nginx (предварительно разместите несколько тестовых картинок в директории /var/www/), а остальные запросы переадресовывались на HAProxy, который в свою очередь переадресовывал их на два Simple Python server.
На проверку направьте конфигурационные файлы nginx, HAProxy, скриншоты с запросами jpg картинок и других файлов на Simple Python Server, демонстрирующие корректную настройку.

### Задание 4*
Запустите 4 simple python сервера на разных портах.
Первые два сервера будут выдавать страницу index.html вашего сайта example1.local (в файле index.html напишите example1.local)
Вторые два сервера будут выдавать страницу index.html вашего сайта example2.local (в файле index.html напишите example2.local)
Настройте два бэкенда HAProxy
Настройте фронтенд HAProxy так, чтобы в зависимости от запрашиваемого сайта example1.local или example2.local запросы перенаправлялись на разные бэкенды HAProxy
На проверку направьте конфигурационный файл HAProxy, скриншоты, демонстрирующие запросы к разным фронтендам и ответам от разных бэкендов.