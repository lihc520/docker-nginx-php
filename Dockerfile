FROM centos:7
LABEL maintainer="eddie@wizmacau.com"
ENV TZ=Asia/ShangHai
WORKDIR /app
ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1

#创建www用户和安装软件包
RUN useradd -M -s /sbin/nologin www && \
    yum -y install  epel-release && \  
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum -y install yum-utils && \
    yum-config-manager --enable remi-php74 && \
    yum -y update && \
    yum install -y https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-common-5.7.27-1.el7.x86_64.rpm && \
    yum install -y https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-libs-5.7.37-1.el7.x86_64.rpm && \
    yum install -y https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-client-5.7.37-1.el7.x86_64.rpm && \
    yum install -y php-fpm php-cli \
        php-bcmath \
        php-dom \
        php-gd \
        php-intl \
        php-ldap \
        php-mbstring \
        php-mcrypt \
        php-mysqlnd \
        php-pdo \
        php-posix \
        php-redis \
        php-zip \
        php-opcache && \
    yum install -y install nginx vim net-tools logrotate supervisor telnet which git bash-completion wget crontabs mailcap && \
    yum install -y http://gosspublic.alicdn.com/ossfs/ossfs_1.80.6_centos7.0_x86_64.rpm && \
    yum clean all && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#拷贝配置或代码
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker/conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/conf/nginx/conf.d/app.conf /etc/nginx/conf.d/app.conf
# COPY docker/conf/nginx/global /etc/nginx/global
COPY docker/conf/php/php-fpm.conf /etc/php-fpm.conf
COPY docker/conf/php/php.ini /etc/php.ini
COPY docker/web /app/
COPY docker/conf/supervisor/supervisord.d /etc/supervisord.d
COPY docker/conf/logrotate.d/nginx  /etc/logrotate.d/nginx
COPY docker/conf/logrotate.d/php-fpm  /etc/logrotate.d/php-fpm 
COPY docker/other/mysql-backup.sh /app/bin/mysql-backup.sh

VOLUME [ "/etc/nginx", "/var/log"]

ENTRYPOINT [ "docker-entrypoint.sh" ]