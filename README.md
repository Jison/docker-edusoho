# docker-edusoho
EduSoho Dockerfile

#### Usage

##### Command Lines

First install docker-engine
```
Ubuntu: https://docs.docker.com/engine/installation/linux/ubuntulinux/
Mac: https://docs.docker.com/engine/installation/mac/
Windows: https://docs.docker.com/engine/installation/windows/
```

Step.1

```
docker pull edusoho/edusoho
```

Step.2

```shell
docker run --name edusoho -tid \
        -v {host_dir_for_db}:/var/lib/mysql \
        -v {host_dir_for_edusoho_code}:/var/www/edusoho \
        -p {host_port}:80 \
        -e DOMAIN="{your_domain}" \
        edusoho/edusoho
```

Step.3

```
visit http://{your_domain}:{host_port}
```

##### Parameters

* {host_dir_for_db}: specify a dir in host machine to store mysql database data, like `/home/mysql_data/www.edusoho.com`
* {host_dir_for_edusoho_code}: specify a dir in host machine to store code and file, like `/home/www/www.edusoho.com`
* {host_port}: specify the http port, usually as `80`
* {your_domain}: specify your webapp domain, like `www.edusoho.com`
* {your_mysql_user}: specify a new mysql_user, like `esuser`
* {your_mysql_password}: specify a new mysql_password, like `edusoho`

##### Example

```shell
mkdir -p /home/www/www.edusoho.com && \
mkdir -p /home/mysql_data/www.edusoho.com && \
rm -rf /home/mysql_data/www.edusoho.com/* && \
docker run --name edusoho -tid \
        -v /home/mysql_data/www.edusoho.com:/var/lib/mysql \
        -v /home/www/www.edusoho.com:/var/www/edusoho \
        -p 80:80 \
        -e DOMAIN="www.edusoho.com" \
        edusoho/edusoho
```

```shell
mkdir -p /var/www/t5.edusoho.cn && \
mkdir -p /var/mysql/t5.edusoho.cn && \
docker run --name t5.edusoho.cn -tid \
        -v /var/mysql/t5.edusoho.cn:/var/lib/mysql \
        -v /var/www/t5.edusoho.cn:/var/www/edusoho \
        -p 6888:80 \
        -e DOMAIN="t5.edusoho.cn" \
        edusoho/edusoho
```

visit http://www.edusoho.com

#### How to build from github source

Respo: https://github.com/starshiptroopers/docker-edusoho

1. change EDUSOHO_VERSION in Dockerfile
2. exec `docker build -t edusoho/edusoho:{version} .`

>**NOTICE**: {version} is according to EDUSOHO_VERSION