# Log4j两种配置文件格式：

*参考链接：[最详细的Log4J使用教程_harderczw的博客-CSDN博客_log4j使用](https://blog.csdn.net/u013870094/article/details/79518028)*

## 1、Properties类型配置文件（Jav特性文件即：键=值）：

实例：

```properties
### 设置日志采用模式  表示使用3个日志输出策略：stdout，D，E
###第一个debug表示控制台输出的日志等级，去掉就是控制台不输出日志
log4j.rootLogger = debug,stdout,D,E

### 输出信息到控制台 ###
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target = System.out
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern = [%-5p] %d{yyyy-MM-dd HH:mm:ss,SSS} method:%l%n%m%n

### 输出DEBUG 级别以上的日志到=E://logs/error.log ###
log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
log4j.appender.D.File = D:\\JavaWork\\MyBatis\\log4j\\log\\debug.log
### true代表日志以追加模式记录
log4j.appender.D.Append = true 
### 当前appender保存的日志等级
log4j.appender.D.Threshold = DEBUG 
log4j.appender.D.layout = org.apache.log4j.PatternLayout
log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

### 输出ERROR 级别以上的日志到=E://logs/error.log ###
log4j.appender.E = org.apache.log4j.DailyRollingFileAppender
log4j.appender.E.File =D:\\JavaWork\\MyBatis\\log4j\\log\\error.log 
log4j.appender.E.Append = true
log4j.appender.E.Threshold = DEBUG 
log4j.appender.E.layout = org.apache.log4j.PatternLayout
log4j.appender.E.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n
```



## 2、XML类型配置文件：

实例：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">
    <!--
        appender标签的属性值：
        org.apache.log4j.ConsoleAppender（控制台），
        org.apache.log4j.FileAppender（文件），
        org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件），
        org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件），
        org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）-->
    <appender name="STDOUT" class="org.apache.log4j.ConsoleAppender">
        <param name="Encoding" value="UTF-8"/>

        <!--
            layout标签的属性值：
            org.apache.log4j.HTMLLayout（以HTML表格形式布局），
            org.apache.log4j.PatternLayout（可以灵活地指定布局模式），
            org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），
            org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）

        -->
        <layout class="org.apache.log4j.PatternLayout">
            <!--
                1、%p 当前日志等级，但是log等级的字符数不一致，看起来不美观
                    %-5p 表示左对齐5个字符
                    %5p  表示右对齐5个字符
                2、%r 输出log自构建到输出的毫秒数
                3、%c 输出当前类的全类名
                4、%t 输出产生该日志事件的线程名 (如main，Thread-0等)
                5、%n 输出一个回车换行符 （win下：\r\n  linux下：\n）
                6、%d 输出日志点的时间 可以指定格式，默认格式：ISO8601  %d{yyyy-MM-dd HH:mm:ss:SSS} 年月日时分秒毫秒
                7、%l 输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。如：com.ly.log4j.log.MyLog.main(MyLog.java:19)
                8、%m 输出自定义的消息
                9、%F 输出使用日志的类名（不是全类名）
                10、%L 输出调用日志的代码行数
            -->
            <param name="ConversionPattern" value="%-5p [%t] %d{yyyy-MM-dd HH:mm:ss:SSS} %m (%F:%L)  \n "/>
        </layout>
    </appender>
    <!--
        示例：
        <logger name="java.sql">
            <level value="debug" />
        </logger>

    -->
    
    <!-- 对不同日志等级进行不同输出  debug日志单独保存-->
    <!--
    appender标签的属性值：
    org.apache.log4j.ConsoleAppender（控制台），
    org.apache.log4j.FileAppender（文件），
    org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件），
    org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件），
    org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）-->
    <appender name="D" class="org.apache.log4j.RollingFileAppender">
        <!-- 日志文件最大到2KB时重新建立一个新文件-->
        <param name="MaxFileSize" value="2KB"/>
        <!-- 最多保存5个日志文件,超过的话就会顺序覆盖重新写入，文件名不会变还是.1.2.3.4.5 (不是.6.7.8.9.)-->
        <param name="MaxBackupIndex" value="5"/>

        <param name="Encoding" value="UTF-8"/>
        <!-- 保存文件路径必须是正斜杠/-->
        <param name="File" value="D:/JavaWork/MyBatis/log4j/log/debug.log"/>
        <param name="Append" value="true"/>
        <param name="Threshold" value="DEBUG"/>
        <!--
            layout标签的属性值：
            org.apache.log4j.HTMLLayout（以HTML表格形式布局），
            org.apache.log4j.PatternLayout（可以灵活地指定布局模式），
            org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），
            org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）

        -->
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%-5p [%t] %d{yyyy-MM-dd HH:mm:ss:SSS} %m (%F:%L)  \r\n "/>
        </layout>
    </appender>

    <!-- 对不同日志等级进行不同输出  error日志单独保存-->
    <!--
        appender标签的属性值：
        org.apache.log4j.ConsoleAppender（控制台），
        org.apache.log4j.FileAppender（文件），
        org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件），
        org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件），
        org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）-->
    <appender name="E" class="org.apache.log4j.RollingFileAppender">
        <!-- 日志文件最大到2KB时重新建立一个新文件-->
        <param name="MaxFileSize" value="2KB"/>
        <!-- 最多保存5个日志文件,超过的话就会顺序覆盖重新写入，文件名不会变还是.1.2.3.4.5 (不是.6.7.8.9.)-->
        <param name="MaxBackupIndex" value="5"/>

        <param name="Encoding" value="UTF-8"/>
        <param name="File" value="D:/JavaWork/MyBatis/log4j/log/error.log"/>
        <param name="Append" value="true"/>
        <param name="Threshold" value="DEBUG"/>
        <!--
            layout标签的属性值：
            org.apache.log4j.HTMLLayout（以HTML表格形式布局），
            org.apache.log4j.PatternLayout（可以灵活地指定布局模式），
            org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），
            org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）

        -->
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%-5p [%t] %d{yyyy-MM-dd HH:mm:ss:SSS} %m (%F:%L)  \r\n "/>
        </layout>
    </appender>
    

    <!-- 针对控制台日志输出 -->
    <root>
        <level value="debug"/>
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="D"/>
        <appender-ref ref="E"/>
    </root>
</log4j:configuration>
```