# 创建交换文件
dd if=/dev/zero of=/var/swapfile bs=1024 count=2048k
# 格式化
mkswap /var/swapfile
# 挂载并激活
swapon /var/swapfile
# 消除权限错误
chmod -R 0600 /var/swapfile
# 添加开机自动挂载
echo "/var/swapfile swap swap defaults 0 0" >> /etc/fstab