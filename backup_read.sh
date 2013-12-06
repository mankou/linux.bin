#!/bin/bash
# backup.sh 用于备份的脚本 
# author mang 
# create:2013年12月04日 星期三 21时53分46秒
# modify:2013年12月04日 星期三 21时53分59秒
# 功能描述：用于备份文件的脚本。 注意这里使用了绝对压缩路径
# bug
## 目前不能处理带有空格的行
## 也不能处理空行


# 使用说明
# #在下方设置相关变量参数。如备份路径 备份文件名 配置文件路径等
# # 在配置文件backup.config中设置要备份的文件路径
# # chmod u+x backup.sh 设置该脚本有执行权限
# # 运行该脚本即可


###############在下方配置相关参数###################################33
# 配置文件路径 其中记录要备份文件的路径  
config=backup.config

# 压缩包存放路径
dest=/home/mang/backup/

# 压缩包文件名
backup_file_name=backup

###############在上方配置相关参数###################################33


# 判断目的路径是否存在如果不存在则建立目录 
if [ ! -d $dest ];then
	echo "目录不存在 自动创建目录..."
	mkdir  $dest
fi



# 循环读入配置文件拼接到变量source中
# cat $config | grep '^[^#]' | while read line
set -x
srcpath=""
grep '^[^#]' $config| while read line
do
	echo "the line is : $line"
	srcpath="$srcpath $line"
	echo "the result of merge is:$srcpath"
done
# 按日期生成压缩包最后的文件名（带路径）
# dest="$dest$backup_file_name`date +%Y%m%d%H%M`.tar.gz"
#echo "目标路径为$dest"
echo "the source path is $srcpath"
set +x
#echo
#echo $IFS

# 生成压缩包 这里采用绝对路径压缩 所以解压时也要使用绝对路径解压才能得到覆盖的效果
#echo "生成的压缩命令如下"
#echo  "tar -czvPf $dest $source"
#
#echo
#echo "正在生成压缩文件...."
#tar -czvPf $dest  $source

#echo -e '\n\n测试用的语句'
#tar -czvPf /home/mang/backup/backup201312051620.tar.gz  "/home/mang/test1/" "/home/mang/test2/"


