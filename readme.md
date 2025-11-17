### Requirements
#### ⭐ 在Windows环境下运行 
win_flex&bison 下载地址：[https://sourceforge.net/projects/winflexbison/]

解压到一个位置后配置你的环境变量，在系统变量中设置Path，新增Path将解压后的文件夹位置添加到Path

示例的Path：

D:\win_flex_bison3-latest（根据你实际的解压位置）

配置环境后使用cmd查看是否可以正常使用

```bash
win_flex --version
win_bison --version
```
在输入命令后正常显示信息说明已经安装配置成功

⚠ 确保你的电脑上已经安装了gcc编译器

### 项目目录
#### LAB
--SysY.c flex生成的程序文件

--SysY.l 编写的符合flex工具语法规则的文件

--SysY.exe 编译生成的可执行文件

--sysY.docx 对sysY设计的说明

--sysYtest.c 自己编写的测试c程序

--test1_dataset1.txt 问题一的测试集1

--test1_dataset2.txt 问题一的测试集2

--test1_dataset3.txt 问题一的测试集3

--test1_dataset4.txt 问题一的测试集4

--test2_dataset1.txt 问题二的测试集1

--test2_dataset2.txt 问题二的测试集2

--test2_dataset3.txt 问题二的测试集3

--test2_dataset4.txt 问题二的测试集4

--unistd.h 项目运行需要的头文件

~~由于项目已经使用flex完成了程序文件的生成和程序的编译，以下的命令在该文件夹中用不到~~

~~使用flex生成代码：~~

~~`cd D:\LAB(这里进入你的项目所在文件夹)`~~

~~`win_flex -o SysY.c SysY.l`~~

~~编译得到可执行文件：~~

~~`gcc SysY.c -o SysY`~~

在项目文件夹下准备好测试的文本文件（.txt/.c格式）

使用`./SysY.exe test1_dataset1.txt`对目标文件进行编译测试
