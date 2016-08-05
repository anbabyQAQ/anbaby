# !/bin/bash
#判断有没有传进参数
#shell中得脚本 判断时需要和test组合起来
if test $1
then
    cd classes
    cd Modules
    mkdir $1
    cd $1
    mkdir Views Models Controllers
    echo "$1模块创建成功"
else
    echo "请输入一个模块名称"
fi
