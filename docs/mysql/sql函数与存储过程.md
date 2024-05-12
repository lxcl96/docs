```sql
DELIMITER $$ -- 自定义结束符替换默认的冒号;（可以为++）
CREATE FUNCTION rand_string(n INT) RETURNS VARCHAR(255)
BEGIN
	DECLARE chars_str VARCHAR(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFJHIJKLMNOPQRSTUVWXYZ'; -- 定义变量
	DECLARE return_str VARCHAR(255) DEFAULT '';
	DECLARE i INT DEFAULT 0;
	WHILE i < n DO
		SET return_str =CONCAT(return_str,SUBSTRING(chars_str,FLOOR(1+RAND()*52),1));
		SET i = i + 1;
	END WHILE;
	RETURN return_str;
END $$ 
-- 用完记得改回去 
DELIMITER ;




DELIMITER $$
CREATE PROCEDURE insert_emp( START INT , max_num INT )
BEGIN
	DECLARE i INT DEFAULT 0;
	-- set autocommit =0 把 autocommit 设置成 0
	SET autocommit = 0;
	REPEAT -- 循环
		SET i = i + 1;
		INSERT INTO emp (empno, NAME ,age ,deptid ) VALUES ((START+i) ,rand_string(6) , rand_num(30,50),rand_num(1,10000));
		UNTIL i = max_num
	END REPEAT;
	COMMIT;
END$$
DELIMITER ;

--调用存储过程
DELIMITER ;
call insert_emp(p1,p2);





-- 必须关键字大写，排除问题
BEGIN
	IF height >=180 THEN
		SET bodyType='身材高挑';
	ELSEIF height >=170 AND height <180 THEN
		SET bodyType='标准身材';
	ELSE 
		SET bodyType='一般身材';
	END IF;
END
-- @type相当于定义一个临时变量，在整个会话期间有效
call figureDetermine(180,@type);
select @type;

```

参考网址：
https://www.jb51.net/article/257981.htm
https://blog.csdn.net/qq_23579405/article/details/124624710