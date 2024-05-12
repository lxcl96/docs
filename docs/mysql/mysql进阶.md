# 1、MySQL简介

## 1.1、什么是mysql

见pdf

## 1.2、MySQL高手是怎么练成的

见pdf

## 1.3、Linux下安装MySQL

### 1.3.1、准备工作

#### 1.3.1.1、检查当前系统是否已经安装过 Mysql

```sh
# centos 7
rpm -qa|grep mariadb # 查看是否安装
rpm -e --nodeps mariadb-libs # 卸载
```

![图片描述](./_media/image-20221108131331081.png)

默认 Linux（CentOS7）在安装的时候，自带了 mariadb(mysql 完全开源版本)相关的组件。 先卸载系统自带的 mariadb，执行卸载命令 `rpm -e --nodeps mariadb-libs`.

#### 1.3.1.2、给`/tmp`目录足够的权限

```sh
ll / # 查看根目录/tmp的读写权限 
# 如果不是全部权限 drwxrwxdrwx
chmod 777 /tmp
```

### 1.3.2、MySQL的安装

因为安装的为旧版本的MySQL，rpm包不好找，直接利用`wget`在线下载rpm安装包。

```sh
# 安装wget
yum install wget
# 下载MySQL5.5的服务端rpm
wget https://downloads.mysql.com/archives/get/p/23/file/MySQL-server-5.5.54-1.linux2.6.x86_64.rpm
# 下载MySQL5.5的客户端rpm
wget https://downloads.mysql.com/archives/get/p/23/file/MySQL-client-5.5.54-1.linux2.6.x86_64.rpm
```

+ 将下载好的`mysql-server`和`mysql-client`移动到`/opt`目录下

  > 第三方软件统一放在这个包下

+ 在`/opt`目录下安装 

  ```sh
  # -i 安装 -v显示详细信息(安装日志) -h hash进度条最好和-v一起
  rpm -ivh MySQL-server-5.5.54-1.linux2.6.x86_64.rpm 
  rpm -ivh MySQL-client-5.5.54-1.linux2.6.x86_64.rpm 
  ```

+ 查看mysql安装时创建的用户组

  > + **查看mysql创建的用户组来检验是否安装成功**
  >
  >   mysql安装时会在Linux上创建属于自己的用户和用户组
  >
  >   ![图片描述](./_media/image-20221108134303599.png)
  >
  > + **或者使用命令`mysqladmin -version`查看安装是否成功**
  >
  >   ![图片描述](./_media/image-20221108134454268.png)

+ 设置mysql的用户和密码(必须先启动mysql服务)

  ```
  mysqladmin -u root password 1024
  ```

### 1.3.3、MySQL服务

#### 1.3.3.1、mysql服务的启停

+ 使用`service`命令

  ```sh
  service mysql start
  service mysql stop
  ```

+ 使用`systemctl`命令

  ```sh
  systemctl start mysql
  systemctl stop mysql
  ```

#### 1.3.3.2、mysql的安装位置

可以通过命令`ps-ef|grep mysql`查看到数据库的存放位置

![图片描述](./_media/image-20221108141714747.png)

![图片描述](./_media/image-20221108141935515.png)

![图片描述](./_media/image-20221108142123992.png)

> **information_schema默认时看不到的，最底层的。里面存放mysql最底层的数据**
>
> windows下：
>
> ![图片描述](./_media/image-20221108142258828.png)

| 参数           | 路径                        | 解释                         | 备注                          |
| -------------- | --------------------------- | ---------------------------- | ----------------------------- |
| `--datadir`    | `/var/lib/mysql/`           | mysql中所有的数据库存放位置  | 还有进程pid，错误日志         |
| `--basedir`    | `/usr/bin`                  | mysql的所有命令              | 如`mysqladmin`，`mysqldump`等 |
| `--plugin-dir` | `/usr/lib64/mysql/plugin`   | mysql插件存放路径            |                               |
| `--log-error`  | `/var/lib/mysql/主机名.err` | mysql错误日志路径            |                               |
| `--pid-file`   | `/var/lib/mysql/主机名.pid` | 进程pid文件                  |                               |
| `--socket`     | `/var lib/mysql/mysql.sock` | 本地连接时用的unix套接字文件 |                               |
|                | `/usr/share/mysql`          | 配置文件目录                 | mysql脚本及配置文件           |
|                | `/etc/init.d/mysql`         | 服务启停相关脚本             |                               |



#### 1.3.3.3、mysql服务的自启动

![图片描述](./_media/image-20221108140754952.png)

或者使用命令：`ntsysv`进行启停

![图片描述](./_media/image-20221108141135458.png)

#### 1.3.3.1、mysql服务的重复启动

如果当前已经有mysql服务启动，再次去启动mysql则会一直卡死在启动中

![图片描述](./_media/image-20221108144729389.png)

此时可以通过命令，查看到后台多了很多mysql服务的进程。

此时，尝试去登陆或者操作就会报错！

![图片描述](./_media/image-20221108144849713.png)

***解决方法：杀死所有的mysql服务和mysqld的服务，然后重启***

![图片描述](./_media/image-20221108144957593.png)

### 1.3.4、修改字符集

+ 5.5默认的mysql配置文件为：`/usr/share/mysql/my-huge.cnf`
+ 5.6默认的mysql配置文件为：`/usr/share/mysql/my-default.cnf`
+ 5.7默认的mysql配置文件为：`/etc/my.cnf`

修改配置文件之前一定要先备份一份，所以我们将要修改的配置文件拷贝一份放到`/etc/my.cnf`

```sh
cp /usr/share/mysql/my-huge.cnf /etc/my.cnf
```

#### 1.3.4.1、常用命令

![图片描述](./_media/image-20221108152248206.png)

#### 1.3.4.2、字符集乱码原因

mysql默认的数据库字符集为latin1，是不包含中文字符的。所以建表时一定要指定字符集`charset=utf8`

![图片描述](./_media/image-20221108152446104.png)

#### 1.3.4.3、修改默认字符集

mysql服务启动默认会去找`/etc/my.cnf`配置文件（windows下默认为my.ini），如果没有就会使用默认的`/usr/lib/mysql/my-huge.cnf`。

![图片描述](./_media/image-20221108152612355.png)

***重启mysql服务，再次查看***

```sh
service mysql stop;
service mysql start;
```

![图片描述](./_media/image-20221108153221735.png)

### 1.3.5、设置大小写不敏感

![图片描述](./_media/image-20221108153531935.png)

![图片描述](./_media/image-20221108153553750.png)

### 1.3.6、sql_mode 

**默认为null，运行一些非法数据**

见pdf

## 1.4、MySQL配置文件

就是`/etc/my.cnf`的内容，以下为主要配置文件。（详情百度）

+ **二进制日志log-bin**

  主要用于主从复制，复制主机内容到从机

  ```sh
  # my.cnf
  # Replication Master Server (default)
  # binary logging is required for replication
  log-bin=mysql-bin
  ```

+ **错误日志log-error**

  设置mysql的错误日志

+ **查询日志log**

  记录查询的sq语句，默认关闭

+ **数据文件**

  > + mysql中数据库默认存放位置
  >
  >   > + windows中：默认是和mysql/bin同级别的data目录下
  >   > + linux中：默认在 var/lib/mysql
  >
  > + **frm文件** <font color='red'> 为数据库中所有表的对应结构（INNODB/MyISAM引擎）</font>
  >
  > + **myd文件**  <font color='red'>为数据库中所以表的对应数据（MyISAM引擎）</font>
  >
  > + **myi文件**  <font color='red'>为数据库中所以表的对应数据索引（MyISAM引擎）</font>
  >
  > + **ibd文件** <font color='red'>表数据和索引的文件</font>
  >
  > ![图片描述](./_media/image-20221108155652837.png)

+ **如何配置**

  > * Linux下为**my.cnf**
  > * Windows下为**my.ini**

## 1.5、开放ip访问mysql

```sh
# *.* 表示所有数据库的所有表，给root用户，ip地址为任意 ，莫玛为1024
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '1024' WITH GRANT OPTION;
flush privileges;
```

***

# 2、MySQL的用户和权限管理

见pdf

![图片描述](./_media/image-20221109152202349.png)

![图片描述](./_media/image-20221109152228028.png)

***

# 3、MySQL逻辑架构简介

和其他数据库相比，MySQL有点与众不同，它的架构可以在多种不同场景中应用并发挥良好作用。主要体现在存储引擎的架构上，<font color='red'>**插件式的存储引擎架构将查询处理和其他的系统任务、数据的存储读取想分离**</font>。这架构可以根据业务的需求和实际需要选择合适的存储引擎。

## ![图片描述](./_media/image-20221108162922024.png)3.1、连接层

**即图中的Connector**

最上层是一些客户端和连接服务，包含本地sock通信和大多数基于客户端/服务器端工具实现的类似于tcp/ip的通信。主要完成一些类似于连接处理、授权认证及相关的安全方案。

在该层上引入了线程池的概念，为通过认证安全接入的客户端提供线程。同样在该层上可以实现基于SSL的安全链接。服务器也会为安全接入的每个客户端验证它所具有的操作权限。

## 3.2、服务层

+ **`Management Services & Utilities`** :系统管理和控制工具

  > 如备份、恢复、安全、复制、集群、迁移等等	

+ **`SQL Interface`** :SQL接口，接受用户的SQL命令，并返回用户需要的查询结果。

  > 如：`select * from xxx`就是调用的SQL Interface
  >
  > 主要为：DDL，DML，存储过程，触发器，视图等

+ **`Parser`** :解析器。SQL命令传递到解析器的时候会被解析器验证和解析

  > 如：查询语句的翻译，对象优先级等

+ **`Optimizer`** :查询优化器。SQL语句在查询之前会使用查询优化器对查询进行优化

  > 比如有where条件时，优化器会决定先投影还是先过滤

+ **`Cache and Buffer`** :查询缓存。如果查询缓存有命中的查询结果，查询语句就可以直接去查询缓存中取数据。这个缓存机制是由一系列小缓存组成的。

  > 比如：表缓存，记录缓存，key缓存，权限缓存等。

## 3.3、引擎层

存储引擎层，存储引擎真正的负责了MySQL中数据的存储和读取，服务通过API与存储引擎进行通信。不同的存储引擎具有的功能不同，这样我们可以根据自己的实际业务进行选择。

比较常用的存储引擎：INNODB和MYISAM

![图片描述](./_media/image-20221109152428324.png)

## 3.4、存储层

数据存储层，主要是将数据存储在运行于裸设备的文件系统之上，并完成与存储引擎的交互。

***

# 4、SQL

## 4.1、show profile

+ ==**因为profile更功能默认是关闭的，所以每次新开一个查询窗口（包括navicat的新窗口）都是一个新会话，即profile功能是关闭的**==
+ ==**多个窗口会话中执行的sql，只会被当前窗口的profile记录，不会被其他窗口的profil记录（即`show profiles`仅显示在当前会话窗口执行的最新15条sql）**==

利用`show profile`可以查看sql的执行周期！

### 4.1.1开启profile

查询 profile 是否开启：`show variables like '%profiling%';`

![图片描述](./_media/image-20221110091929950.png)

如果没有开启即`profiling=off`，可以`set profiling=1`开启

### 4.1.2、使用profile

+ 执行 <font color='red'>`show profiles` </font>命令，可以查看最近的几次查询。

  ![图片描述](./_media/image-20221110092641957.png)

+ 根据上面查询的id（即`Query_ID`），执行 <font color='red'>`show profile cpu，memory,block io for query [Query_ID]` </font>命令，可以查看sql的具体执行步骤。

  ![图片描述](./_media/image-20221110093334796.png)

***如果查询没有结果，则使用下面语句进行查询（效果是一样的）***

```sql
# 高版本的profile查询记录信息，实际数据保存在这个表中
SELECT * from information_schema.PROFILING
/*
注意由于mysql中profile默认只保存15条查询记录，所以很快会被覆盖，导致
	刚查询业务语句，
	去show profiles 查看id  如46
	结果发现 information_schema.PROFILING中query_id被覆盖更新了
	导致
		SHOW PROFILE cpu,memory,block io FOR QUERY 46; 
		或
		SELECT * from information_schema.PROFILING where query_id=46
	查询结果为空，就是过期被覆盖了
*/
```



## 4.2、MySQL查询的大致流程

+ mysql客户端通过协议与mysql服务器建立连接
+ 发送查询语句
+ 先去检查查询缓存（query cache），如果命中，直接返回结果
+ 缓存没有命中，进行sql语句解析

> 也就是说在解析查询sql语句之前，服务器会先访问查询缓存（query cache）--它存储SELECT语句以及相应的查询结果集。
>
> 如果某个查询结果已经位于缓存中，服务器就不会再对查询进行解析、优化以及执行。它仅仅将缓存中的结果返回给用户即可，这将大大提高系统的性能。

+ sql语法解析和预处理

  > 首先mysql通过关键字将SQL语句进行解析，并生成一棵对应的“解析树”。
  >
  > **mysql解析器**将使用mysql语法规则验证和解析查询；
  >
  > **预处理器**则根据一些mysql规则进行进一步检查解析树是否合法
  >
  > 当解析树被认为是合法的时候，查询优化器optimizer就会将其转化为执行计划。一条查询可以有很多种执行的方式，最后都返回相同的结果。
  >
  > **优化器optimizer**的作用就是找到这其中最好的执行计划。

+ mysql默认使用 BTREE 索引，并且一个大致方向是：**无论怎么折腾sql，至少目前来说，mysql最高只用到表中的一个索引**

## 4.3、SQL的执行顺序

我们常见手写的顺序：

```sql
select distinct
	<select_list>
from
	<left_table> <join_type>
join <right_table> 
on <join_condition>
where
	<where condition>
group by <groupby_list>
having <having_condition>
order by <orderby_condition>
limit <limit_number>
```

真正的执行顺序：

​	随着mysql版本的更新换代，其优化器也在不断的升级，优化器会分析不同执行顺序产生的不同的性能消耗，从而动态调整执行顺序。下面就是经常出现的查询顺序：

![图片描述](./_media/image-20221110095621441.png)

## 4.4、常见的join查询

最最基本的五大join查询图，以后基本所有的查询都是基于这个。

![图片描述](./_media/image-20221110105707089.png)

***

# 5、索引优化分析

## 1.  索引的概念

### 1.1 是什么

MySQL官方对索引的定义为：**索引（index）是帮助MySQL高效获取数据的数据结构**。由此可以得出索引的本质：**索引是一种数据结构**，换句话说就是 <font color='red'>索引就是*排好序的用于快速查找的一种数据结构*</font>。

> **索引作用位置：**
>
> + ==会影响where后的条件约束（查找）==
> + ==会影响order by（排序）==
>
> 索引有两个作用：查找和排序

在数据之外，数据库系统还维护者满足特定查找算法的数据结构，这些数据结构以某种方式引用（指向，类似指针）数据，这样就可以在这些数据结构上实现高级查找算法。这种数据结构，就是索引。

下图就是一种可用的索引方式实例：

![图片描述](./_media/image-20221110135458456.png)

一般来说，索引本身也很大，不可能全部存储在内存中，因此**索引往往以索引文件的形式存储在磁盘上**。

### 1.2 索引分类

**我们平时说的索引，如果没有特殊说明就是==BTREE==（==多路搜索树==，并不一定是二叉的）结构组织的索引**。

其中==**聚集索引，次要索引，复合索引，前缀索引，唯一索引默认都是B+树索引，统称索引**==。

当然，mysql中除了B+树这种索引外，还有==**哈希索引（hash index）**==等。

+ B树（多路搜索树）
+ B+树
+ 哈希

### 1.3 索引的优缺点

***优点：***

+ 提高了数据**检索**的效率，降低数据库的io成本
+ 通过索引列对数据进行排序，降低了数据排序的成本，从而降低查询时的cpu消耗

***缺点：***

+ 虽然索引大大提高了查询速度，但同时会**降低更新**表的速度，比如对表进行insert，update和delete。因为更新表时，MySQL不仅要保存数据，还要生成、更新一下索引文件。
+ 索引实际上也是一张表，该表存放者主键与索引字段，并指向实体表的记录，所以索引列也是要**占用空间**

## 2. MySQL的索引

索引主要包括以下四种：

+ Btree
+ Hash
+ Full-text
+ R-tree

**MySQL使用的就是Btree索引**

![图片描述](./_media/btree.png)

### 2.1 Btree初始化介绍

一棵b树，浅蓝色（最外面）的块我们称之为一个磁盘块，可以看到每个磁盘块包含几个数据项（深篮色所示）和指针（黄色所示）。

如磁盘块 1 包含数据项 17 和 35，包含指针 P1、P2、P3， P1 表示小于 17 的磁盘块，P2 表示在 17 和 35 之间的磁盘块，P3 表示大于 35 的磁盘块。 真实的数据存在于叶子节点中存放的指针即 3、5、9、10、13、15、28、29、36、60、75、79、90、99。（不是真实数据，而是指针） 

**非叶子节点只不存储真实的数据，只存储指引搜索方向的数据项，如 17、35 并不真实存在于数据表中。**

### 2.2 Btree查找过程

如果要查找数据项 29，那么首先会把磁盘块 1（**磁盘1就是树的根**） 由磁盘加载到内存，此时发生一次 IO，在内存中用二分查找确定 29 在 17 和 35 之间，锁定磁盘块 1 的 P2 指针，内存时间因为非常短（相比磁盘的 IO）可以忽略不计，通过磁盘块 1 的 P2 指针的磁盘地址把磁盘块 3 由磁盘加载到内存，发生第二次 IO，29 在 26 和 30 之间，锁定磁盘块 3 的 P2 指 针，通过指针加载磁盘块 8 到内存，发生第三次 IO，同时内存中做二分查找找到 29，结束查询，总计三次 IO。 

真实的情况是，3 层的 b+树可以表示上百万的数据，如果上百万的数据查找只需要三次 IO，性能提高将是巨大的， 如果没有索引，每个数据项都要发生一次 IO，那么总共需要百万次的 IO，显然成本非常非常高。

### 2.3 B+ tree索引

![图片描述](./_media/b+tree.png)

### 2.4 B-tree与B+tree区别

b-tree就是b树

+ 在B+树中，具有n个关键字节点就有n个分支，在B树中，具有n个关键字节点（**节点**）就含有n+1个分支（**每个节点的线**）

+ B-tree的关健字（**key，查找的依据如主键**）和记录（数据）是放在一起的，叶子节点（**B-树严格地说，在还下面一层，代表查找失败，程序中就是用空指针代表，查找中也叫做外结点**）可以看作外部节点，不包含任何关键字信息。非叶子节点包括关键字的信息，以及子树指针向量和关键字表示的相应的数据项；
+ B+树的非叶子节点中只有关键字（关键字不保存数据，只用来做索引）和指向下一个节点的索引，记录只存放在叶子节点中。
+ 在 B-树中，越靠近根节点的记录查找时间越快，只要找到关键字即可确定记录的存在；而 B+树中每个记录 的查找时间基本是一样的，都需要从根节点走到叶子节点，而且在叶子节点中还要再比较关键字。从这个角度看 B- 树的性能好像要比 B+树好，而在实际应用中却是 B+树的性能要好些。**因为 B+树的非叶子节点不存放实际的数据，这样每个节点可容纳的元素个数比 B-树多，树高比 B-树小，这样带来的好处是减少磁盘访问次数（每个节点都算存储块，别的信息少，索引信息就多了）**。尽管 B+树找到 一个记录所需的比较次数要比 B-树多，但是一次磁盘访问的时间相当于成百上千次内存比较的时间，因此实际中 B+树的性能可能还会好些，而且 B+树的叶子节点使用指针连接在一起，方便顺序遍历（例如查看一个目录下的所有 文件，一个表中的所有记录等），这也是很多数据库和文件系统使用 B+树的缘故。

***思考：为什么说 B+树比 B-树更适合实际应用中操作系统的文件索引和数据库索引？***

1) B+树的磁盘读写代价更低 

   > B+树的内部结点并没有指向关键字具体信息的指针。因此其内部结点相对 B 树更小。如果把所有同一内部结点 的关键字存放在同一盘块中，那么盘块所能容纳的关键字数量也越多。一次性读入内存中的需要查找的关键字也就 越多。相对来说 IO 读写次数也就降低了。 

2) B+树的查询效率更加稳定

   >  由于非终结点并不是最终指向文件内容的结点，而只是叶子结点中关键字的索引。所以任何关键字的查找必须 走一条从根结点到叶子结点的路。所有关键字查询的路径长度相同，导致每一个数据的查询效率相当。

### 2.5 聚簇索引和非聚簇索引

聚簇索引并不是一种单独的索引类型，而是一种数据存储方式。

**聚簇：**表示数据行和相邻的键值聚簇的存储在一起。

如下图，左侧的索引就是聚簇索引，因为数据行在磁盘中的排列和索引排序保持一致。

> 索引中的关键字节点的关键字相邻，实际存放物理地址也相邻

![图片描述](./_media/image-20221111142533956.png)

***聚簇索引的好处：***

按照聚簇索引排列顺序，查询显示一定范围数据的时候，由于数据都是紧密相连，数据库不用从多个数据块中提取数据，所以节省了大量的io操作。

***从聚簇索引的限制：***

+ 对于MySQL数据库目前只有innodb数据引擎支持聚簇索引，而MYisAM并不支持聚簇索引。
+ 对于数据物理存储排序方式只能有一种，所以每个MySQL的表只能由一个聚簇索引，一般情况下就是该表的主键
+ 为了充分利用聚簇索引的聚簇特性，所以innodb表的主键列尽量选用有序的顺序id，而不建议用无序的id，如uuid。

### 2.6 时间复杂度

同一问题可用不同算法解决，而一个算法的质量优劣将影响到算法乃至程序的效率。算法分析的 目的在于选择合适算法和改进算法。 时间复杂度是指执行算法所需要的计算工作量，用大 O 表示记为：O(…)

![图片描述](./_media/image-20221111143144963.png)

![图片描述](./_media/image-20221111143310686.png)

## 3. MySQL索引分类

### 3.1 单值索引

即一个索引只包含单个列，一个表可以有多个单指索引。

### 3.2 唯一索引

索引列的值必须唯一，但允许有空值。使用关键字`unique`

### 3.3 主键索引 

设定主键后，数据库会自动建立索引，innodb为聚簇索引。

### 3.4 复合索引

即一个索引包含多个列

### 3.5 基本语法

#### 1.建立索引的语句：

**使用关键primary 或unique mysql数据库会自动创建主键索引和唯一索引**

+ **建表时创建表**

  ```sql
  create table if not EXISTS  stu (
  `id` int(10),
  `name` VARCHAR(255) unique DEFAULT null,
  `age` int(4) DEFAULT null,
  PRIMARY key(`id`),
  INDEX[/key] idx_stu_name(`name`[,...]) -- index 或key都可以  [,...表示单列索引]
  )ENGINE=INNODB auto_increment=1 DEFAULT CHARSET=utf8;
  ```

+ **alter 关键字单独创建**

  ```sql
  alter TABLE stu add INDEX idx_stu_name(`name`[,...]); -- 普通，复合索引
  alter table stu add PRIMARY key (`id`);-- 主键索引
  alter TABLE stu add unique INDEX idx_stu_name(`name`); -- 唯一索引
  ```

+ **create index 单独创建**

  ```sql
  create [unique] index idx_stu_name on stu (`name`[,...]);
  ```

#### 2.查看Mysql的索引

```sql
show index from xxxx;
```

![图片描述](./_media/image-20221111092526920.png)

#### 3.删除索引

```sql
drop index idx_stu_name on stu;
```

## 4. 索引创建的时机

### 4.1 适合创建索引情况

+ 主键自动创建唯一索引
+ 频繁作为查询条件的字符应该创建索引
+ 查询中与其他表关联的字段【如外键】，建议建立索引
+ 单键/组合索引的选择问题，组合（复合）索引性价比更高
+ 查询中需要排序的字段（order by 后的），排序字段如果通过索引去访问将大大提高排序速度
+ 查询中统计或者分组字段（group by）

### 4.2 不适合创建索引的情况

+ 表记录太少
+ 经常增删改的表或字段
+ where条件里用不到的字段不创建索引
+ 过滤性不好的不适合建索引

***

# 6、Explain性能分析

## 1. 概念

使用EXPLAIN关键字可以模拟优化器执行SQL查询语句，从而知道MySQL是如何处理你的SQL语句的。分析你的查询语句或是表结构的性能瓶颈。

用法：`explain + sql语句`

explain执行后返回e的信息：

![图片描述](./_media/image-20221111151217325.png)

## 2. Explain执行结果返回字段分析

### 2.1  字段id

select 查询的序列号，包含一组数字，表示查询中执行select子句或操作表的顺序。

+ **id相同，顺序执行**

  ![图片描述](./_media/image-20221111151936136.png)

+ **id不同，值越大优先级越高，先执行（一般为子查询，带括号）**

  ![图片描述](./_media/image-20221111152057945.png)

  > **出现有相同，有不同**
  >
  > 先执行2，id为1的再顺序从上往下执行
  >
  > ![图片描述](./_media/image-20221111152225049.png)

<font color='red'>**id中每一个记录，表示一趟独立的查询。一个sql的查询趟数越少越好**</font>

### 2.2 字段select_type

select_type表示当前查询的类型，主要用于区分**普通查询、联合查询、子查询**等的复杂查询。

| select_type属性        | 含义                                                         |
| ---------------------- | ------------------------------------------------------------ |
| `simple`               | 简单的select查询，查询中不包含子查询或union                  |
| `primary`              | 查询中若包含任何复杂的子部分，最外层查询则被标记为primary    |
| `derived`              | **虚拟表，衍生表**<br />在form后中包含的子查询会被标记为derived<br />mysql会递归执行这些子查询，把结果放在临时表中 |
| `subquery`             | **子查询** <br />在select或where后包含的子查询               |
| `dependent subquery`   | **依赖的子查询** <br />在select或where后包含的子查询，子查询依赖与外部（条件） |
| `uncacheable subquery` | 无法使用缓存的子查询                                         |
| `union`                | 若第二个select出现在union之后，则会被标记为union<br />若union包含在from后的子查询中，外层select则被标记位为derived |
| `union result`         | 从union表获取结果的select                                    |

#### 2.3.1 select_type=simple

表示简单的单表查询

![图片描述](./_media/image-20221111154256419.png)

#### 2.3.2 select_type=primary

查询中若包含任何复杂的子部分（子查询，union等），最外层查询则会被标记为primary

![图片描述](./_media/image-20221111154629760.png)

#### 2.3.3 select_type=derived

在from后使用的select子查询会被标记位derived（衍生），MySQL会递归执行这些子查询，把结果放在临时表中。

#### 2.3.4 select_type=subquery

在select或where后使用select查询的

![图片描述](./_media/image-20221111154850238.png)

#### 2.3.5 select_type=dependent subquery

在select或where后使用select查询的子查询，并且子查询基于外层（使用外面的条件）

![图片描述](./_media/image-20221111155023101.png)

> 都是 where 后面的条件，subquery 是单个值，dependent subquery 是一组值???

#### 2.3.6 select_type=uncacheable subquery

无法使用缓存的子查询，比如使用了@@引用系统变量时 如：`select @@version`

![图片描述](./_media/image-20221111155300649.png)

#### 2.3.7 select_type=union

在第二个select出现在union之后，则被标记为union；如果union包含在子句的子查询中，则最外层将被标记位derived

![图片描述](./_media/image-20221111155505999.png)

#### 2.3.8 select_type=union result

从union表获取结果的select

### 2.3 字段table

表示数据是基于哪张表的

### 2.4 字段type



type查询的访问类型，是较为重要的一个指标。

```sql
-- 结果值从好到坏,一般来说至少达到range，最好到ref
system > const > eq_ref > ref > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > index > All
```

#### 2.4.0 覆盖索引

概念：查询的列（字段），与复合索引的字段完全相同（即查询结果就在索引中，或全从索引中取数据）

> 如果查询过程中使用了覆盖索引，则该索引仅出现在key列表中
>
> ![图片描述](./_media/image-20221114103230932.png)

![图片描述](./_media/image-20221114104105536.png)

#### 2.4.1 system类型

表中至于一条记录（类似系统表），这是const类型的特例，平时不会出现。

#### 2.4.2 const类型

表示通过**索引一次**就找到了，const用于比较**primary key 或 unique索引**。因为只匹配一行数据，所以很快。

> 如：将主键至于where条件中，MySQL就能将该查询转换为一个常量。
>
> ![图片描述](./_media/image-20221111162719389.png)
>
> 解释：
>
> + 外查询里有一个子查询，所以外查询的select_type=primary，而其数据来源基于虚拟表（衍生表，即子查询）
> + 内查询的类型是虚拟表，数据来源基于t1

#### 2.4.3 eq_ref类型

**唯一（unique）性索引扫描**，对于每个索引键，表中只有一条记录与之匹配。常见于主键或唯一索引扫描

![图片描述](./_media/image-20221111163839083.png)

#### 2.4.4 ref类型

**非唯一性索引扫描**，返回匹配某个单独值的所有行。本质上也是一种索引访问，它返回所有匹配某个单独值的行。然而，他可能会找到多个符合条件的行，所以它应该属于查找和扫描的混合体。

+ 没用索引前 (ALL + ALL)

  ![图片描述](./_media/image-20221111164441488.png)

+ 用了索引后(ALL + ref)

  ![图片描述](./_media/image-20221111164525219.png)

#### 2.4.5 range类型

只检索给定范围的行，使用一个索引来选择行。

key列显示使用了哪个索引，一般就是在你的where语句中出现了between、<、>、in等的查询这种范围扫描索引比全表扫描要好，因为他只需要开始于索引的某一点，而结束与另一点，不用扫描全部索引。

![图片描述](./_media/image-20221111165023529.png)

#### 2.4.6 index类型

<font color='red'>出现index表示sql使用了索引，但是没有通过索引进行过滤，一般是使用了覆盖索引或者是利用索引进行了排序分组</font>

![图片描述](./_media/image-20221111165547417.png)

#### 2.4.7 all类型

full table scan，全表扫描

#### 2.4.8 index_merge类型（索引合并）

在查询过程中需要多个索引组合使用，通常出现在有or的关键字的sql中（**看实际使用key，有多个值**）。

![图片描述](./_media/image-20221114103230932.png)

![图片描述](./_media/image-20221114093810942.png)

#### 2.4.9 ref_or_null类型

对于某个字段既需要关联条件，也需要null值的情况下。查询优化器会选择用ref_or_null连接查询

![图片描述](./_media/image-20221114093950375.png)

#### 2.4.10 index_subquery类型

利用索引来关联子查询，不再全表扫描

![图片描述](./_media/image-20221114094231850.png)

#### 2.4.11 unique_subquery类型

该联接类型类似于index_subquery，子查询中的唯一（unique）索引

![图片描述](./_media/image-20221114094435850.png)

### 2.5 possible_keys

**显示可能应用在这张表中的索引，一个或多个**。查询涉及到的字段上若存在索引，则该索引将被列出，但**不一定被查询实际使用**

### 2.6 key

实际使用的索引，如果为null表示没有使用索引。

### 2.7 key_len

表示索引中使用的字节数，可通过该列计算查询中使用的索引的长度。key_len字段能够帮你检查是否充分的利用上了索引。key_len越长，说明索引使用的越充分。

![图片描述](./_media/image-20221114095330227.png)

![图片描述](./_media/image-20221114095937447.png)

![图片描述](./_media/image-20221114100151104.png)

### 2.8 ref

显示索引的哪一列被使用了，如果可能（比如查询条件是一个确定的值）的话是一个常数。哪些列或常量被用于查找索引列上的值。

`ref的值按照执行顺序关联， 并且引用的值看等号=右边的表达式`

![图片描述](./_media/image-20221114100436089.png)

![图片描述](./_media/image-20221114101435181.png)

### 2.9 rows

rows列显示MySQL认为它执行查询时必须检查的行数，**越少越好**!

![图片描述](./_media/image-20221114102809085.png)

### 2.10 Extra

其他的额外重要的信息，主要有以下几个值：

#### 2.10.1 Using filesort（排序没用到索引）

<font color='red'>组合索引排序时排序字段必须按照组合索引字段的顺序</font>

**查询中需要排序的字段，如果通过使用了索引将大大提高排序速度**

说明MySQL会对数据使用一个外部的索引排序，而不是按照表内的索引顺序进行读取。**MySQL中无法利用索引完成的排序成为“文件排序”**

![图片描述](./_media/image-20221114110226484.png)

#### 2.10.2 Using temporary（产生了临时表）

使用了临时表保存中间结果，MySQL在对查询结果排序时使用了临时表。常见于排序order by 和分组查询group by。

![图片描述](./_media/image-20221114112722712.png)

![图片描述](./_media/image-20221114112927554.png)

#### 2.10.3 Using index

表示使用到了覆盖索引（即查询的字段和顺序，与建立复合索引的顺序一致），避免了访问表的数据行，效率不错。

+ 如果同时出现using where，表示索引被用来执行索引键值的查找
+ 如果没有同时出现using where，表明索引只是用来读取数据而非利用索引执行查找

+ 出现`Using index for group-by` 表示利用索引来分组
+ 出现`Using index for order-by` 表示利用索引来排序

#### 2.10.4 Using where

表示使用了where进行过滤

#### 2.10.5 Using join buffer

表示使用了连接缓存，此时需要调高缓冲池的数量

#### 2.10.6 impossible where

where的子句总还是false的情况，如`where 0< 1`这样

#### 2.10.7 select tables optimized away

在没有 GROUPBY 子句的情况下，基于索引优化 MIN/MAX 操作或者对于 MyISAM 存储引擎优化 COUNT(*)操 作，不必等到执行阶段再进行计算，查询执行计划生成的阶段即完成优化。

![图片描述](./_media/image-20221114114737791.png)

![图片描述](./_media/image-20221114114806299.png)

***

# 7、==>单表使用索引常见的索引失效==

## 7.1 全值匹配我最爱

查询时的条件，和复合索引所有的列完全相同。

![图片描述](./_media/image-20221114144913946.png)

## 7.2 ==最佳左前缀法则==

即查询从索引的最左前列开始并且不跳过索引中的列。

> 举个例子：建立的索引为idx_name_age_sex
>
> 查询单/多列时：**where或on条件必须按照复合索引的建立顺序， name [ age [ sex [...] ] ] 取列（但是where中顺序不做要求）不允许跳过中间的某列**
>
> age或age,sex或sex都是不可以的
>
>  **name比作火车头，其余字段类似于车厢，火车头必须有**
>
> |\=\=\=\=\=>口诀：带头大哥不能少，（复合索引）中间兄弟不能断
>
> ```sql
> # 索引条件顺序无所畏，但一定要有且按照复合索引的顺序的列(下面俩等价)
> explain select *  from `t_emp` where age = 100 and `name`="张三丰"; -- 顺序无所畏
> explain select *  from `t_emp` where `name`="张三丰" and age = 100;
> ```
>
> ![图片描述](./_media/image-20221114143827608.png)

==**结论：过滤条件要使用索引必须按照索引建立时的顺序，依次满足，一旦跳过某个字段，索引后面的字段都无 法被使用。**==

## 7.3 不要在索引列上做任何操作（计算、函数、自动or手动的类型转换），会导致索引失效

## 7.4 存储引擎不能使用索引中范围条件右边的列

如`in, between..and, >, <, like`等，会导致右边的条件列无法用到索引

> + 作为范围筛选本身的列 **查找数据时没有用到(复合)索引，排序时用到了(复合)索引**
>
> + 右边的列都没有用到
>
>   > 其中like比较特殊，如果是 `like 'xxx%'`这样的则其右边的还可以使用索引，不像其它的范围不能用索引。

![图片描述](./_media/image-20221114145721359.png)

## 7.5 尽量使用覆盖索引（查询列和复合索引列完全一致），减少select *

## 7.6 mysql在使用不等于（!=或<>）的时候无法使用索引，会导致全表扫描

## 7.7 `is null`，`is not null` 也无法使用索引

## 7.8 like以通配符（%，*等）开头sql，会导致索引失效，如果是通配符结尾，则是range级别可以用索引

![图片描述](./_media/image-20221114151712371.png)

## 7.9 字符串（char,varchar）不加单引号导致索引失效

## 7.10 减少用or的次数，用它连接时会导致索引失效

## 7.11  思考问题：如何保证like中通配符开头的查询，一定用到索引？

解决方法：==使用覆盖索引，数据只需在索引中检索不需要全表扫描==

```sql
-- 存在索引 idx_name_age
-- 索引失效全表扫描
explain select `name`,`age`,id,deptId from `t_emp` where name like '%小宝%'; -- （全表）
explain select `name`,`age`,id from `t_emp` where name like '%小宝%'; -- （覆盖索引，id也有索引）
explain select `name`,`age` from `t_emp` where name like '%小宝%'; -- （覆盖索引）
explain select `name` from `t_emp` where name like '%小宝%'; -- （覆盖索引）
explain select `age` from `t_emp` where name like '%小宝%'; -- （覆盖索引）
```

## 7.12 练习

![图片描述](./_media/image-20221114160236426.png)

![图片描述](./_media/image-20221114160535406.png)

![图片描述](./_media/image-20221114160816072.png)

![图片描述](./_media/image-20221114160938709.png)

![图片描述](./_media/image-20221114161757580.png)

![图片描述](./_media/image-20221114162006574.png)

![图片描述](./_media/image-20221114162241744.png)

![图片描述](./_media/image-20221114162441855.png)

![图片描述](./_media/image-20221114163037992.png)

![图片描述](./_media/image-20221114164328013.png)

> **like范围特殊，只要是常量字符开头，不管中间是几个%百分号都可以用到索引，且右边的也都可以用索引**

## 7.13 总结 （口诀）

全值匹配我最爱，最左前缀要遵从。

（复合索引）带头大哥不能死，中间兄弟不能断。

索引列上少计算（函数），范围（like特殊）之后全失效。

like百分号写最右，覆盖索引不写*。

不等（!=/<>）空值还有OR，影响索引很重要。

varchar引号不能少，sql优化有诀窍。

***

# 8、关联(left/right join)查询优化

## 8.0 总结

+ 在优化关联查询时，只有在**被驱动表建立索引才有效**！ 

  > 被驱动表：left join时的右表，right join的左表

+ left join 时，左侧的为驱动表，右侧为被驱动表！
+ right join 时，右侧的为驱动表，左侧为被驱动表！
+ inner join ，mysql 会自己帮你把小结果集的表选为驱动表
+ straight_join，mysql会强制把左表作为驱动表

## 8.1 left join

==**左关联索引加在右表上**==

![图片描述](./_media/image-20221114165035661.png)

![图片描述](./_media/image-20221114165130124.png)

## 8.2 right join

==**右关联索引加在坐标上**==

> 与left join刚好相反

## 8.3 inner join

<font color='red'>**inner join 时，mysql 会自己帮你把小结果集的表选为驱动表。 **</font>



## 8.4 straight_join

<font color='red'>**效果和inner join一样，但是强制把左表作为驱动表**</font>

![图片描述](./_media/image-20221114165709687.png)

***

# 9、子查询优化(小表驱动大表 in和exists区别)

案例：见pdf

***总结：范围判断时，尽量不要使用`not in`和`not exists`，应该使用`left join on xxx is null`代替***

![图片描述](./_media/image-20221115094131770.png)

***

# 10、排序分组优化

## 10.1 order by

严格遵循索引键的最佳左前缀原则

+ 无过滤不索引

  > 没有where或limit条件约束，会导致出现 use filesort

+ 顺序错，必手动排序

  > 排序键的顺序 和建立索引时键的顺序不一致，会导致出现 use filesort
  >
  > ​			（where中是可以错序的）

+ 方向反，必排序

  > 如果有排序依据是多个键，且和建立索引时键的顺序一致，但是一个键要求升序，另一个键要求倒叙时，会导致出现 use filesort
  >
  > ​		（同时升序或倒叙不会出现）

### 10.1.1 案例

![图片描述](./_media/image-20221115102837946.png)

![图片描述](./_media/image-20221115102958716.png)

### 10.1.2 为排序使用索引

![图片描述](./_media/image-20221115162525826.png)

### 10.1.3 MySQL排序算法

+ **双路排序**：

  > MySQL4.1之前是使用双路排序，字面意思就是两次扫描磁盘，最终得到数据。
  >
  > 读取行指针和order by列，对他们进行排序生成列表A，然后扫描已经排序好的列表A，按照列表A中的值重新从列表中读取相应的数据输出。
  >
  > 从磁盘取排序字段，在buffer进行排序，再从磁盘取其他字段。（两次IO很耗时间）

+ **单路排序**：

  > MySQL4.1之后新增的排序算法，从磁盘中读取查询需要的所有列，按照order by列在buffer中对它们进行排序，然后扫描排序后的列表进行输出，他的效率更快一些，避免了第二次读取数据。并且把随机IO变成了顺序IO，但是他会使用更多地空间，因为它把每一行数据都保存到内存中了。

+ **单路排序的问题**：

  > 由于单路是后出的，总体而言好过双路。但是存在以下问题：
  >
  >   在sort_buffer中，方法B比方法A要多占用很多空间，因为方法B是把所有字段都取出，所以有可能取出的数据的总大小超过了sort_buffer的容量，导致每次只能取sort_buffer容量大小的数据，进行排序（创建tmp文件，多路合并），排完再取sort_buffer容量大小的数据，再排。。。从而多次IO
  >
  > 结论：本来想省一次IO操作，结果导致了大量的IO操作，得不偿失。

+ **怎么优化单路排序**：

  + <font color='red'>增大sort_buffer_size参数的设置</font>

    > 不管用哪种算法，提高这个参数都会提高效率，当然要根据系统的能力去提高，因为这个参数是针对每个进程的，**1M~8M之间调整**

  + <font color='red'>增大max_length_for_sort_data参数的设置</font>

    > mysql使用单路排序的前提是排序的字段大小要小于max_length_for_sort_data
    >
    > 提高这个参数会增加改进算法的概率。但是如果设的太高，数据总容量超过sort_buffer_size的概率就会增大，明显症状就是高的磁盘IO活动和低的处理器使用率（**1024-8192之间调整**）

  + <font color='red'>减少select后面的查询的字段</font>

    > 当查询的字段大小总和小于max_length_for_sort_data 而且排序字段不是TEXT|BLOB类型时，会用改进后的算法--单路排序，否则使用老算法--多路排序。
    >
    > 两种算法的数据都有可能超过sort_buffer的容量，超过之后会创建tmp文件并进行合并排序，导致多次IO，但是用单路排序算法的风险会更大一些，所以要提高sort_buffer_size

## 10.2 group by

group by 实质是先排序后进行分组，遵循索引键的最佳左前缀。

+ 当无法使用索引时，增大max-length_for_sort_data参数的设置 + 增大sort_buffer_size参数的设置
+ where条件高于having条件，能写在where中的条件就不要写在having中



# 11、==>截取查询分析==

## 11.1 ***慢查询日志***

MySQL的慢查询日志是MySQL提供的一种日志记录，它用来记录在MySQL中响应时间超过阀值的语句，具 体指运行时间超过long_query_time值的SQL，则会被记录到慢查询日志中。

具体指运行时间超过long_query_time值的SQL，则会被记录到慢查询日志中。long_query_time的默认值为 10，意思是运行10秒以上的语句。 

由他来查看哪些SQL超出了我们的最大忍耐时间值，比如一条sql执行超过5秒钟，我们就算慢SQL，希望能 收集超过5秒的sql，结合之前explain进行全面分析。

### ***怎么用：***

<font color='red'>**默认情况下，MySQL数据库没有开启慢查询日志，需要我们手动开启。**</font>

<font color='red'>**如果不是sql调优需要，不建议开启，会影响吸系统性能**</font>

```sql
-- 查询mysql是否开启慢查询(以及日志保存的位置)
show variables like '%slow_query_log%';
-- 查看当前数据库，慢查询的sql总数
show status like '%Slow_queries%';
--  查询mysql慢查询的时间设置
show VARIABLES like 'long_query_time';
-- 开启慢查询
set global slow_query_log=ON;
-- 设置慢查询时间（单位秒）,不会马上生效，需要重启数据库(或者新建立连接，新会话窗口)
set global long_query_time=1;
-- 设置慢查询日志保存位置
set global slow_query_log_file='D:\mysql5.6\querySlowLog\slowQuery.log';

-- 查看是否使用索引，及索引的级别
explain select  from `slow_log` where start_time  '20221024 000000';

-- 遇到多列索引失效的情况，可以将所有的查询列联合作为一个索引
alter  table  表名  add  index  索引名(index_name)  (列名1，列名2.......);
```

### **注意：**

使用命令set global slow_query_log=1/ON开启了慢查询日志只对当前数据库有效
使用MySQL重启后会失效。

如果需要永久保存慢查询，需要再配置文件`/etc/my.cnf`中配置：

```sh
# /etc/my.cnf 即mysql配置文件
[mysqld]
slow_query_log=1
slow_query_log_file=/var/lib/mysql/atguigu-slow.log
long_query_time=3
log_output=FILE
```



## 11.2 ***mysqldumpslow日志分析***

慢查询日志分析工具mysqldumpslow，查看mysqldumpslow 帮助信息：

```sh
[root@centos7 ~]# mysqldumpslow --help
Usage: mysqldumpslow [ OPTS... ] [ LOGS... ]

Parse and summarize the MySQL slow query log. Options are

  --verbose    verbose
  --debug      debug
  --help       write this text to standard output

  -v           verbose # 显示详细信息
  -d           debug
  -s ORDER     what to sort by (al, at, ar, c, l, r, t), 'at' is default # 以何种方式排序，默认是at
                al: average lock time # 平均锁定时间
                ar: average rows sent # 平均返回记录数
                at: average query time # 平均查询时间
                 c: count # sql语句访问次数
                 l: lock time # sql语句锁定时间
                 r: rows sent # sql语句返回的记录
                 t: query time # sql语句查询时间
  -r           reverse the sort order (largest last instead of first) #反/倒序,最大的是最后一个
  -t NUM       just show the top n queries # 返回排序后前n条数据
  -a           dont abstract all numbers to N and strings to 'S' 
  -n NUM       abstract numbers with at least n digits within names
  -g PATTERN   grep: only consider stmts that include this string # 管道grep 
  -h HOSTNAME  hostname of db server for *-slow.log filename (can be wildcard),
               default is '*', i.e. match all
  -i NAME      name of server instance (if using mysql.server startup script)
  -l           don't subtract lock time from total time
```

例子：

```sh
# 得到返回记录集最多的10个sql
mysqldumpslow -s r -t 10 /var/lib/mysql/centos7-slow.log
# 得到访问次数最多的10个sql
mysqldumpslow -s c -t 10 /var/lib/mysql/centos7-slow.log
# 得到按照时间排序的前10条中含有左连接的查询语句(两种方法都可以)
mysqldumpslow -s t -t 10 /var/lib/mysql/centos7-slow.log |grep "left join"
mysqldumpslow -s t -t 10 -g "left join" /var/lib/mysql/centos7-slow.log
```

## 11.3 ***show processlist***

用于查询mysql当前进程列表，可以杀掉故障进程

![图片描述](./_media/image-20221116155717177.png)



## 11.4 大数据准备

见pdf上**第 7 章 批量数据脚本**



## 11.5 ***show profile***

+ ==**因为profile更功能默认是关闭的，所以每次新开一个查询窗口（包括navicat的新窗口）都是一个新会话，即profile功能是关闭的**==
+ ==**多个窗口会话中执行的sql，只会被当前窗口的profile记录，不会被其他窗口的profil记录（即`show profiles`仅显示在当前会话窗口执行的最新15条sql）**==

### 1 概念

profile是mysql提供可以用来分析当前会话中语句执行的资源消耗情况，用于sql的调优。

官网连接：http://dev.mysql.com/doc/refman/5.5/en/show-profile.html

默认情况下该功能处于关闭状态，并且默认保存最近15次的允许操作。

### 2 使用步骤

+ 查看当前MySQL版本是否支持

  ![图片描述](./_media/image-20221116161442949.png)

+ 若该功能处于关闭状态，请开启

  ```sql
  set profiling=on;
  ```

+ 执行目标/业务sql

+ `show profiles`查看最新的15条记录（==sql在哪个会话窗口执行，就在哪个窗口查看（别的窗口不显示）==），记录业务sql查询对应的query_id（比如我的就是33）

  ![图片描述](./_media/image-20221116163934411.png)

+ `show profile cpu,block io for query xxxId`查看目标业务sql语句，实际消耗的系统底层信息

  ![图片描述](./_media/image-20221116170116809.png)

  ```sql
  # profile的数据实际来源的表就是 information_schema.PROFILING 
  # 你可以自己查看这个表，查看所有信息  
  select * from  information_schema.PROFILING where query_id=130; -- 等价于上面的show profile ..
  ```

+ 注意**（执行`show all for query xxxx`）status列中是否有**以下四列：

  > + **出现`converting HEAP to MyISAM`，查询结果太大了，内存都不够用放在磁盘上了**
  > + **`Creating tmp tables`创建临时表了（拷贝数据到临时表，用完删除）**
  > + **`Copying to tmp table on disk`把内存中临时表复制到磁盘上，危险**
  > + **locked**
  >
  > ![图片描述](./_media/image-20221116194914056.png)



## 11.6 全局查询日志

记录所有的sql（只允许在测试环境用），**命令方式**开启之后**所有的sql语句都会记录到mysql库里的general_log表中**

***配置文件启用：***

```sh
# /etc/my.cnf 开启
general_log=1
# 记录日志文件的路径
general_log_file=/path/logfile
# 输出格式
log_output=FILE
```

***命令方式启用：***

```sql
set global general_log=1; -- 开启
set global log_output='TABLE'; -- 以table方式记录sql（就是把sql记录到表中，默认是文件）
```

![图片描述](./_media/image-20221116200348424.png)

***

# 12、数据库锁

## 12.1 锁分类

***按照对数据操作的类型（读\写）分***

+ 读锁（共享锁）：针对同一份数据，多个读操作可以同时进行而不会互相影响
+ 写锁（排它锁）：当前写操作没有完成前，它会阻断其他写锁和读锁

***对数据库操作的粒度分***

+ 行锁
+ 表锁

## 12.2 三锁分析

### 12.2.1 表锁（MyISAM）

***特点：偏向MyISAM存储引擎，开销小，加锁快；无死锁；锁定粒度大，发生锁冲突的概率最高，并发度最低。***

```sql
-- 显示当前库中的所有表
show tables;

-- 查看已经加锁的表
show open tables;

-- 给表上锁（读写锁）
lock table `mylock` read,`t1` write; # 给mylock上读锁，给t1上写锁

-- 给所有锁定表解锁
unlock tables; # tables 是关键字，不是某个表名

-- 查看表级锁的情况
show status like 'table%';
```

![图片描述](./_media/image-20221117093802005.png)

![图片描述](./_media/image-20221117102414231.png)

**MyISAM的读写锁调度是写优先，这也是MyISAM不适合左写为主表的引擎。因为写锁后，其他线程不能做任何操作，大量更新会导致查询很难获取到锁，从而导致永久阻塞。**

### 12.2.2 行锁 （INNODB）

***特点：偏向InnoDB存储引擎，开销大，加锁慢；会出现死锁；锁定粒度最小，发生锁冲突的概率最低，并发度也最高。***

InooDB不同于MyISAM的最大两个不同点：

+ 支持事务（TRANSACTION）
+ 采用了行级锁

> 什么是事务？
>
> 事务的ACID分别是什么？
>
> 并发事务带来的问题是什么？
>
> mysql事务的默认隔离级别是什么？
>
> 事务的隔离级别几种？分别是什么？

```sql
# 查看innodb行锁的信息
show status like 'innodb_row_lock%';
```

![图片描述](./_media/image-20221117135859647.png)

#### ***1、效果：***

设置会话a自动提交为off，会话b为on

> 如果设置autocommit=off，则当前会话窗口想要读到最新数据必须先commit一下，才能读取到最新数据（否则都是可重复读的数据）

+ 会话a更新t表的id为1的数据（未提交），则会话b更新t表的id=1的数据会被**阻塞，直到a中sql commmit**
+ 会话a更新t表的id为1的数据（未提交），会话a可以读到会话a修改的数据，会话b读不到会话a修改的数据（读己之所写，可重复读）
+ 会话a更新t表的id为1的数据（未提交），则会话b更新t表的id为非1的数据会被**均会成功**

#### ***2、索引失效会导致行锁变为表锁：***

如自动类型转换引起索引失效引起表锁，导致更新另一方数据阻塞。

```sql
# 前提 关闭了自动提交，表中a（int），b（varchar）列均有索引 

-- 会话窗口aa更新数据
update test_innodb_lock set a=41 where b=4000; # b为varchar自动转换，导致索引失效
-- 会话窗口bb更新数据
update test_innodb_lock set b='9001' where a=9; # 正确的sql

# 虽然窗口aa，bb操作的不是同一行数据（正常情况下互不影响），但是因为aa中的的自动类型转换 导致b列索引失效，引起表锁。则b中sql会一直阻塞直到aa中sql提交

# 原因：mysql的行级锁是通过索引实现的，innodb的事务默认就是行级锁
```



#### ***3、间隙锁：***

当我们用范围条件而不是相等条件检索数据，并请求共享或排它锁时，InnoDB会给符合条件的所有已有数据记录加锁，对于键值在条件范围内但并不存在的记录，叫做间隙（gap）。

InnoDB也会对这个间隙（gap）加锁，这种锁机制就是所谓的间隙锁（next-key锁）。

![图片描述](./_media/image-20221117112839157.png)

**间隙锁危害：**

因为sql查询执行过程中通过范围查找的话，他会锁定整个范围内所有的索引键值，**即使整个满足条件的键值不存在**。

间隙锁的致命弱点就是当锁定一个范围内的所有键值后（包括不存在的键值），**会导致锁定的时候无法插入在锁定键值范围内的任何数据**。

#### ***4、如何给某一行上锁？***

```sql
begin; -- 开启事务，等同于 start transaction
# select 后面加上update就代表当前会话对a=8这一行数据上锁了，其余会话更新只能等待我这边commit
select * from test_innodb_lock where a=8 for update; 
# 执行自己的更新操作 update 。delete。。等
commit; -- 提交事务 等同于commit work

# 提交后其余会话更新a=8的行记录才会被执行
```

#### ***5、总结***

+ **尽可能让所有数据检索都通过索引完成，避免无索引行锁升级为表锁**（如自动类型转换导致索引失效）
+ **合理设计索引，尽量缩小锁的范围**
+ **尽可能较少的检索条件（指范围），避免间隙锁**
+ **尽量控制事务大小，减少锁定资源量和时间长度**
+ **近可能低级别事务隔离**

***

### 12.2.3 读锁（共享锁 MyISAM）

前提：会话a给表t1加的读锁  （t1是MyISAM引擎）

+ <font color='red'>会话a可以读取t1数据</font>
+ <font color='red'>会话a**无法读取其他没有被锁表数据**（只能读取被锁的表，不管谁锁的）</font>
+ <font color='red'>会话a无法更新t1数据</font>
+ <font color='yellow'>会话b（其他）**可以读取t1数据**</font>
+ <font color='yellow'>会话b（其他）可以读取更新其他未被锁表数据</font>
+ <font color='yellow'>会话b（其他）**更新t1数据会导致阻塞，直到t1表被解锁**（可以手动杀死该进程）</font>

### 12.2.4 写锁（排它锁 MyISAM）

前提：会话a给表t1加的写锁  （t1是MyISAM引擎）

+ <font color='red'>会话a可以读取t1数据</font>
+ <font color='red'>会话a**无法读取其他没有被锁表数据**（只能读取被锁的表，不管谁锁的）</font>
+ <font color='red'>会话a可以更新t1数据</font>
+ <font color='yellow'>会话b（其他）**读取t1数据会被阻塞，直到t1表被解锁**（可以手动杀死该进程）</font>
+ <font color='yellow'>会话b（其他）可以读取更新其他未被锁表数据</font>
+ <font color='yellow'>会话b（其他）**更新t1数据会导致阻塞，直到t1表被解锁**（可以手动杀死该进程）</font>



总之：基于MyISAM的表，***（针对非加锁的会话而言）读锁会阻塞写，但是不会阻塞读；写锁则会把读和写都阻塞。***

## 12.3 页锁

开销和加锁的时间介于表锁和行锁之间；会出现死锁；锁定粒度介于表锁和行锁之间，并发度一般。(了解)

***

# 13、主从复制

见pdf
