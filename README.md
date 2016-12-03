# docker-edusoho
EduSoho Dockerfile

#### How to build

1. change EDUSOHO_VERSION in Dockerfile
2. exec `docker build -t edusoho/edusoho:{version} .`

>**NOTICE**: {version} is according to EDUSOHO_VERSION

#### How to use after build

###### command line

```
docker run --name edusoho -tid \
        -v {host_dir_for_db}:/var/lib/mysql \
        -p {host_port}:80 -e DOMAIN="{domain}" \
        edusoho/edusoho:{version}
```

###### parameters

* {host_dir_for_db}: specify a dir in host machine to store mysql database data, like `/home/mysql_data`
* {host_port}: specify the http port, usually as `80`
* {domain}: specify webapp domain, like `www.edusoho.com`
* {version}: specify the edusoho version, it's optional, default `latest`