程序框架


1、 os_basis.sh
打造基础环境，包括常用软件包和依赖软件包的安装，以及内核参数的适当优化，运行完需要重启

2、 yum_source.sh
创建nginx/mariadb/php的对应yum源，并生成缓存

3、 lnmp_install_01.sh
安装最基础的lnmp环境，默认用户和用户组都为www，默认网站根目录为/www/wwwroot

4、 lnmp_install_02.sh
在lnmp_install_01的基础上安装ngx_cache_purge模块和memcache模块

5、 ansible_nginx.yml
使用ansible部署nginx的模板文件

6、 start.sh
启动文件