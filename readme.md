# 一、项目简介
  本项目为ETL的简单实现。做一些简单配置，之后只需要将写好的Hql文件放入到特定的目录中即可。通过contab配置执行时间，即可执行ETl。
  -- 可以通过 bin/env.sh 中的允许修改项，做一些初始化设置（如：目录配置、初始化时间等）
  -- 可以通过 conf/imex.conf 做一些数据导入导出到Hive的配置（后续单独介绍）

# 二、目录介绍
  bin       : 存放所有执行命令的目录
  conf      : 存放配置文件的目录
  lib       : 存放所有程序所需初始化变量、函数等的目录
  warehouse : 存放所有Hql文件的目录（含：建表语句文件、抽取数据语句文件、其他数仓各层间的可执行文件）
  --  create    : 存放所有建表语句的目录（只有.hql文件可以使用）
  --  extract   : 存放抽取数据时会使用到的简单语句或语句片段
  --  dm(ods等) : 存放数仓各层间数据转换的Hql语句（层级不一样时，可以自行添加）

  start.sh  : 此文件用于统一执行ETl主过程的执行文件
  test.sh   : 此文件用于调试过程中测试代码片段

# 三、操作步骤
##（一）根据数据来源、数仓建设，编写建表语句。放入 warehouse/create 目录下。
##（二）设置 lib/env.sh 文件，可编辑项为 “允许修改” 中的变量。按照注释进行必要设置。
##（三）设置 conf/imex.conf 文件（下一节详细介绍）。
##（四）执行 bin/0_0_create.sh 执行创建表操作（可以单独执行执行某个建表语句文件。文件可以带有目录）。
##（五）执行 bin/0_1_init_table.sh 初始化配置文件。
##（六）执行 start.sh 文件，开始运行程序（手动）。
  --  配置 crontab 文件，使程序自动执行。

# 四、imex.conf文件配置
  imex      : 归属类型（export、import、execut）：导入、导出及执行
  type      : 数据来源类型、数据导出目的地类型、数据执行类型（现有 mysql、mongodb、local、beeline）
  hosts     : 数据来源主机识别或主机IP（多台服务器的数据来源目录或表相同时，可以使用 :(分号)隔开）
  user      : 来源主机用户（若已配置 ssh 免密登陆，可以不填写）
  passwd    : 来源主机密码（若已配置 ssh 免密登陆，可以不填写）
  database  : 格式为：来源数据库:目标数据库
  tables    : 来源数据库与目标数据库的表名称，或文件名称（有 *(星号)时，采用 x(英文字母 x )代替），一个库中用多张表是采用 :(分号)隔开
  注 : 来源数据库的表名需与目标数据库的表名一致

# 五、版本更新
  v1.0 第一版（正式版） v0.2 第二版
    第一版中，添加新表时，不能够使新表单独执行，有诸多不便。
    改进：增加 0_1_init_table.sh 命令。初始化时，有了一份 imex.table 文件，模拟MySQL表结构。
              将原来的一次性执行配置中的所有表，改为按照每次读取特定的归属类型数据，单独执行每一张表。
              解决了新添加表时，只需重新执行 bin/0_1_init_table.sh ，就可基本解决不能够单独执行新添加表的问题。
  v0.1 第一版
    测试版，上线测试。
