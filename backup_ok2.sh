#!/bin/bash
# backup.sh 用于备份的脚本 
# author mang 
# create:2013年12月04日 星期三 21时53分46秒
# modify:2013年12月05日 星期四 22时51分50秒
# 功能描述：用于备份文件的脚本。 注意这里使用了绝对压缩路径
# bug
## 目前不能处理带有空格的行


# 使用说明
# #在下方设置配置文件路径 建议把配置文件与该脚本放在同一目录了
# # 在配置文件backup.config中设置要备份的文件路径
# # chmod u+x backup.sh 设置该脚本有执行权限
# # 运行该脚本即可

# 设置配置文件路径 其中记录要备份文件的路径及备份的相关参数  
# 如果你在参数中指定了配置文件路径则使用参数中的路径 这里设置的路径会被覆盖
CONFIG=backup.config

# 判断输入的配置文件是否有效 如果无效则报错退出
if [ -n "$1" ];then
	# 如果配置文件存在且是个文件则用参数指定的配置文件替换前面配置的CONFIG 否则报错退出
	if [  -f "$1" ];then
		CONFIG="$1"
	else
		echo "[error]$1 does not exist or is not a file!!!"
		exit 1;
	fi
# 如果没有在参数中指定配置文件路径则采用默认的配置路径	
elif [ -f "$CONFIG" ]
	echo "[info]if you do not designate the config file  we will use a default config file named backup.config"
# 如果即没有指定配置文件路径又找不到默认配置文件路径则报错退出
then
	echo "[error]sorry I can not find $CONFIG!!!"
	exit 1;
fi



#从配置文件中取出相关参数
START_INDEX=`grep -n 'config_start' ${CONFIG} | cut -d: -f1`
END_INDEX=`grep -n 'config_end' ${CONFIG} | cut -d: -f1`
CONFIG_TEXT="sed -n ${START_INDEX},${END_INDEX}p ${CONFIG}"
# 备份路径
DEST=`${CONFIG_TEXT} | grep 'DEST' | cut -d= -f2`
# 备份文件名
BACKUP_FILE_NAME=`${CONFIG_TEXT} | grep 'NAME' | cut -d= -f2`




# 判断目的路径是否存在如果不存在则建立目录 
if [ ! -d $DEST ];then
echo "[信息]目录不存在 自动创建目录..."
	mkdir  $DEST
fi


# 取出配置文件中要备份的路径在备份文件的起始行号和结束行号。之所以要+1 -1 是因为这两行不是记录路径的
BACKUP_PATH_START=`grep -n 'backup_path_start' $CONFIG| cut -d: -f1`
BACKUP_PATH_END=`grep -n 'backup_path_end' $CONFIG| cut -d: -f1`
BACKUP_PATH_START=$[ $BACKUP_PATH_START+1 ]
BACKUP_PATH_END=$[ $BACKUP_PATH_END-1 ]

# 循环读入要备份的路径拼接到变量SOURCE中
# 下面设置IFSOLD本来是用于处理路径中有空格的问题，但后来也没有解决，这里先保留着反正不影响目前的功能
IFSOLD=$IFS
IFS=$'\n'
for VAR in `sed -n ${BACKUP_PATH_START},${BACKUP_PATH_END}p $CONFIG |grep '^[^#]'`
do 
	SOURCE="$SOURCE $VAR"
done
IFS=$IFSOLD


# 按日期生成压缩包最后的文件名（带路径）
DEST="$DEST$BACKUP_FILE_NAME`date +%Y%m%d%H%M`.tar.gz"

# 生成压缩包 这里采用绝对路径压缩 所以解压时也要使用绝对路径解压才能得到覆盖的效果
echo "[信息]正在生成压缩文件...."
tar -czvPf $DEST  $SOURCE
echo
echo "[信息]生成的压缩文件的路径为: $DEST"

