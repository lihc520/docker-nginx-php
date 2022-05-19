# 镜像基本说明:



###### 此Dockerfile以centos7.9为基础,build有php74和nginx,以supervisord运行php和nginx进程,包含centos基本使用的工具



###### 如需要不同的php版本和模块只需要简单的更改dockerfile的remi-php(version)重新docker build即可



###### 如需要一些小工具也可以在dockerfile里加

```sh
docker -t build image-name .
```