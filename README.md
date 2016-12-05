# docker-edusoho
EduSoho Dockerfile

#### How to build

1. change EDUSOHO_VERSION in Dockerfile
2. exec `docker build -t edusoho/edusoho:{version} .`

>**NOTICE**: {version} is according to EDUSOHO_VERSION

#### How to use after build

###### run command

```
docker run --name edusoho -tid --rm \
        -v {host_dir_for_db}:/var/lib/mysql \
        -p {host_port}:80 \
        -e DOMAIN="{your_domain}" \
        -e MYSQL_USER="{your_mysql_user}" \
        -e MYSQL_PASSWORD="{your_mysql_password}" \
        edusoho/edusoho:{version}
```

###### parameters

* {host_dir_for_db}: specify a dir in host machine to store mysql database data, like `/home/mysql_data`
* {host_port}: specify the http port, usually as `80`
* {your_domain}: specify your webapp domain, like `www.edusoho.com`
* {your_mysql_user}: specify a new mysql_user, like `esuser`
* {your_mysql_password}: specify a new mysql_password `edusoho`
* {version}: specify the edusoho version, it's optional, default `latest`

###### example

```
mkdir -p /root/docker-edusoho/mysql_data && \
rm -rf /root/docker-edusoho/mysql_data/* && \
docker run --name edusoho --rm -ti \
        -v /root/docker-edusoho/mysql_data:/var/lib/mysql \
        -p 49189:80 \
        -e DOMAIN="dest.st.edusoho.cn" \
        -e MYSQL_USER="esuser" \
        -e MYSQL_PASSWORD="edusoho" \
        edusoho/edusoho:7.2.9
```

visit http://dest.st.edusoho.cn:49189