
yum install gcc openssl openssl-devel -y

function nginx_fastcgi_cache()
{
    mkdir temp
    cd temp
    # 获取nginx版本号

    nginx_ver_info=`nginx -V 2>&1`

    nginx_ver=`echo $nginx_ver_info | awk -F"version:" '{print $2}' | awk -F" built" '{print $1}' | awk -F"/" '{print $2}'`

    wget --no-check-certificate -c http://nginx.org/download/nginx-$nginx_ver.tar.gz
    wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz

    # 获取nginx编译参数
    nginx_make_info=`echo $nginx_ver_info | awk -F"arguments:" '{print $2}'`

    tar zxvf nginx-$nginx_ver.tar.gz
    tar zxvf ngx_cache_purge-2.3.tar.gz

    cd nginx-$nginx_ver
    echo "./configure ${nginx_make_info} --add-module=../ngx_cache_purge-2.3" >> configure.sh
    chmod +x ./configure.sh
    ./configure.sh
    make

    # 备份原有nginx执行文件
    nginx_whereis=`which nginx 2>&1`
    mv $nginx_whereis $nginx_whereis"_`date +%F`"

    mv objs/nginx $nginx_whereis

}

nginx_fastcgi_cache


yum install gcc git libevent zlib zlib-devel -y

function memcached_install()
{
    yum install memcached -y

    cd temp
    git clone https://github.com/websupport-sk/pecl-memcache.git

    cd pecl-memcache/
    phpize
    ./configure
    make
    make install

    echo "
[memcache]
extension=memcache.so
    " >> /etc/php.ini

    systemctl restart php-fpm

}