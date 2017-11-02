SQL语句--mysql

一：设计数据库

	1.数据库(DATABASE)
	
		创建：mysql> CREATE DATABASE d1;
		删除：mysql> DROP DATABASE d1;
		查看：mysql> SHOW DATABASES;
			  mysql> SELECT DATABASE();
			  mysql> STATUS;
			  --所有的数据库列表，当前所用数据库，当前数据库的详细信息
		切换：mysql> USE d1；
	
	2.数据表(TABLE)
	
		创建：
		
			mysql> CREATE TABLE t1(
				ID int NOT NULL AUTO_INCREMENT，
				number1 int(10) UNSIGNED NOT NULL,
				number2 int NOT NULL,
				name1 VARCHAR(255),
				name2 VARCHAR(255) ENUM('a','b'),
				name3 VARCHAR(255) DEFAULT 'Cshare',
				
				PRIMARY KEY(ID),
				FOREIGN KEY (number1) REFERENCES t2(number1),
				CHECK(number2>1)，
				UNIQUE(name1)
				);
				
			mysql> CREATE TABLE t2 SELECT * FROM t3;
			--可用于备份
				
			特殊字段：
			
				AUTO INCREMENT--在新记录插入表中时生成一个唯一的数字，默认开始值为1，每次递增1
					mysql> ALTER TABLE t1 AUTO_INCREMENT=100
					--修改t1表的AUTO_INCREMENT的开始值为100
				
				UNSIGNED--非负数,范围从0开始
				
				ENUM--枚举
				
								 
		删除：
		
			mysql> DROP TABLE t1;
			mysql> DROP TABLE IF EXISTS t1;
			--删除t1表,需要用sql文件创建t1表时，可利用IF EXISTS来删除t1表而不会报错
			
		查看：
		
			mysql> SHOW TABLES;
			--查看当前数据库下的所有表
			mysql> SHOW COLUMNS FROM t1;
			mysql> DESC t1;
			--查看t1表的表结构
			mysql> SHOW CREATE TABLE t1;
			--查看t1表的创建信息，可找到自动生成的索引名称
		
		改动：
		
			mysql> ALTER TABLE t1 RENAME TO t2;
			--t1表重命名为t2表
			mysql> ALTER TABLE t1 ADD column1 ENUM('old','young') NOT NULL
			--t1表中添加column1列
			mysql> ALTER TABLE t1 DROP column1，DROP column2；
			--t1表中删除column1列
			mysql> ALTER TABLE t1 MODIFY COLUMN column1 INT;
			--修改column1的数据类型为int，可自定义多样化的datatype
			
二：管理约束

	约束(CONSTRAINTS):
		
		1.NOT NULL--约束强制列不接受 NULL 值
	  
		2.UNIQUE --约束唯一标识数据库表中的每条记录
	  
			CONSTRAINT cons1 UNIQUE (number1,number2),
			--创建表时命名UNIQUE约束
			mysql> ALTER TABLE t1 ADD UNIQUE (column1);
			--当表已被创建时，在columns1列创建UNIQUE约束
			mysql> ALTER TABLE t1 ADD CONSTRAINT cons2 UNIQUE (column1,column2);
			--当表存在时，定义多个列的 UNIQUE 约束
			mysql> ALTER TABLE t1 DROP INDEX cons2;
			--撤销UNIQUE约束
		
		3.PRIMARY KEY--约束唯一标识数据库表中的每条记录，UNIQUE和NOT NULL集合，每个表都应有且只有一个主键
	  
			CONSTRAINT cons1 PRIMARY KEY (number1,number2),
			--创建表时命名PRIMARY KEY约束
			mysql> ALTER TABLE t1 ADD PRIMARY KEY (column1);
			--当表已被创建时，在columns1列创建PRIMARY KEY约束,必须把主键列声明为不包含 NULL 值（在表首次创建时）
			mysql> ALTER TABLE t1 ADD CONSTRAINT cons2 PRIMARY KEY (column1,column2);
			--当表存在时，定义多个列的 PRIMARY KEY 约束
			mysql> ALTER TABLE t1 DROP PRIMARY KEY;
			--撤销PRIMARY KEY约束
		
		4.FOREIGN KEY --一个表中的 FOREIGN KEY 指向另一个表中的 PRIMARY KEY
	  
			CONSTRAINT cons1 FOREIGN KEY (number1) REFERENCES t2(number1),
			--创建表时命名FOREIGN KEY约束
			mysql> ALTER TABLE t1 ADD FOREIGN KEY (column1) REFERENCES t2(column1);
			--当已被创建时，在column1列创建FOREIGN KEY约束
			mysql> ALTER TABLE t1 ADD CONSTRAINT cons2 FOREIGN KEY (column1) REFERENCES t2(column1);
			--当表存在时，命名FOREIGN KEY约束
			mysql> ALTER TABLE t1 DROP FOREIGN KEY cons2;
			--撤销FOREIGN KEY约束
		 
		5.CHECK --约束用于限制列中的值的范围
	  
			CONSTRAINT cons1 CHECK (number1>0 AND name1='Cshare'),
			--创建表时命名CHECK约束
			mysql> ALTER TABLE t1 ADD CHECK (column1>0);
			--当已被创建时，在column1列创建CHECK约束
			mysql> ALTER TABLE t1 ADD CONSTRAINT cons2 CHECK (column1>0 AND column2='Cshare');
			--当表存在时，命名CHECK约束
			mysql> ALTER TABLE Persons DROP CHECK cons2;
			--撤销CHECK约束
		 
		6.DEFAULT --约束用于向列中插入默认值
		
			OrderDate date DEFAULT GETDATE(),
			--DEFAULT可以插入函数
			mysql> ALTER TABLE t1 ALTER column1 SET DEFAULT 'Cshare';
			--当已被创建时，在column1列创建DEFAULT约束
			mysql> ALTER TABLE t1 ALTER column1 DROP DEFAULT;
			--撤销DEFAULT约束
			
	索引(INDEX):
	
		mysql> CREATE INDEX index1 ON t1(column1,column2 DESC);
		--ASC降序，DESC升序，对涉及到查询的列创建
		mysql> ALTER TABLE t1 DROP INDEX index1;
		--删除索引
			
三：管理单表
	
	1.SELECT(子查询)
	
		*简单选取
		
			mysql> SELECT column1,column2 FROM t1;
			mysql> SELECT * FROM t1;
			mysql> SELECT DISTINCT column1 FROM t1;--去重
		
		*复杂选取
		
			--WHERE子句{=,<>,>,<,>=,<=,BETWEEN,LIKE，IN}
			
				mysql> SELECT * FROM t1 WHERE column1='Cshare';
				mysql> SELECT * FROM t1 WHERE column1>100;			
				mysql> SELECT * FROM t1 WHERE column1 BETWEEN value1 AND value2
				mysql> SELECT * FROM t1 WHERE column1 BETWEEN 'a' AND 'h';
				--BETWEEN可以是数字，文本，日期,包含value1，value2，NOT BETWEEN 相补
				mysql> SELECT * FROM t1 WHERE column1 LIKE 'c%'
				mysql> SELECT * FROM t1 WHERE column1 NOT LIKE '%c%'
				--'%'表示一个或多个,'_'表示一个，[charlist],[^charlist]表示字符列中的一个,也用于show语句
				mysql> SELECT * FROM t1 WHERE column1 IN (value1,value2,...)
				mysql> SELECT * FROM t1 WHERE column1 IN (SELECT column2 FROM t2)
				--IN,可以嵌套子查询
				
			--AND和OR运算符
			
				mysql> SELECT * FROM t1 WHERE column1='Cshare' AND column2>100;
				mysql> SELECT * FROM t1 WHERE column1='Cshare' OR column2>100;
				
			--ORDER BY语句(默认ASC表示升序，DESC表示降序） 
			
				mysql> SELECT * FROM t1 ORDER BY column1;
				mysql> SELECT * FROM t1 ORDER BY column1,column2;
				--column1升序下column2升序
				mysql> SELECT * FROM t1 ORDER BY column1 DESC;
				mysql> SELECT * FROM t1 ORDER BY column1 DESC,column2 ASC;
				--column1升序下column2降序
				
			--LIMIT语句
				mysql> SELECT * FROM t1 LIMIT 3;
				--选取前三条
				mysql> SELECT * FROM t1 LIMIT 2,3;
				--从第3条开始选取3条数据,第一个参数默认从0开始				
	
	2.INSERT
	
		mysql> INSERT INTO t1 VALUES(value1,value2,value3);
		--t1有多少列，values就要有多少值，into可以省略，但是INSERT INTO 是标准写法
		mysql> INSERT INTO t1(column1,column2) VALUES(value1,value2);
		mysql> INSERT t1 SET column1=value1,column2=value2;
		--column和value需要一一对应
		mysql> INSERT INTO t1(column1,column2) SELECT column3,column4 FROM t2
		--column1,column2与column3,column4的格式要对齐
		
	3.UPDATE
	
		mysql> UPDATE t1 SET column1=new_value1,column2=new_value2 WHERE column3='Cshare'
		--column1=new_value为赋值语句column1=column1+1也可，where提供一种多样化的筛选
	
	4.DELETE
		
		mysql> DELETE FROM t1 WHERE column1='Cshare';
		--删除某行
		mysql> DELETE FROM t1;
		mysql> DELETE * FROM t1;
		mysql> TRUNCATE TABLE t1;
		--清空表格
		
四：管理多表

	--别名 Aliases
		mysql> SELECT column1 FROM table1 AS t1
		mysql> SELECT column1 AS co1 FROM t1
		mysql> SELECT t1.column1,t2.column1 FROM table1 AS t1,table2 AS t2 
		--以column1，column2为列构成的表，若不足则最后一条数据向下填充
		
	JOIN:--用于根据两个或多个表中的列之间的关系，从这些表中查询数据
	
		mysql> SELECT t1.column1,t2.column1 WHERE t1.column2=t2.column2;
		--相同于INNER JOIN，当t1.column2与t2.column2分别含有n,m个相同重复值时，则会生成n*m条数据
		
		INNER JOIN--A∩B  在表中存在至少一个匹配时，INNER JOIN 关键字返回行
		mysql> SELECT t1.column1,t2.column1 FROM t1 INNER JOIN t2 ON t1.column2=t2.column2
		
		LEFT JOIN--A∩B∪A  关键字会从左表t1那里返回所有的行，即使在右表t2中没有匹配的行。
		mysql> SELECT t1.column1,t2.column1 FROM t1 LEFT JOIN t2 ON t1.column2=t2.column2
		
		RIGHT JOIN--A∩B∪B  关键字会从右表t1那里返回所有的行，即使在左表t2中没有匹配的行。
		mysql> SELECT t1.column1,t2.column1 FROM t1 RIGHT JOIN t2 ON t1.column2=t2.column2
		
		FULL JOIN--A∪B  只要其中某个表存在匹配，FULL JOIN 关键字就会返回行。
		mysql> SELECT t1.column1,t2.column1 FROM t1 FULL JOIN t2 ON t1.column2=t2.column2
	
	UNION:--UNION操作符用于合并两个或多个具有相似结构的SELECT语句
	
		mysql> SELECT * FROM t1 UNION SELECT * FROM t2;
		--UNION操作符选取不同的值，如果允许重复的值，请使用 UNION ALL
		
五：创建视图

	VIEW:--视图的使用就像它是一张表
	
		创建
			mysql> CREATE VIEW view1 AS SELECT *FROM t1;
			
		查询
			mysql> SELECT * FROM view1;
			
		删除
			mysql> DROP VIEW view1;
			
六：SQL函数

	DATE函数
		mysql> SELECT now();
		--返回当前时间
		mysql> SELECT date(now);
		--提取日期
		
	NULL判断
		mysql> WHERE column1 IS NULL
		--判断是否为空，与IS NOT NULL 相补
		
	IFNULL()
		mysql> SELECT IFNULL(a,b);
		--如果a不为NULL则返回a，否则返回b
		
	IF()
		mysql> SELECT IF(a,b,c);
		--a=true返回b， a=false返回c
		
	GROUP BY
		mysql> SELECT SUM(id),name FROM t1 GROUP BY name;
		--以name分组处理数据，若不对id进行处理，则取第一个值
		
	HAVING 
		mysql> SELECT name FROM t1 GROUP BY name HAVING COUNT(name)<2;
		--在SQL中增加HAVING子句原因是WHERE关键字无法与合计函数一起使用。
		
		
	
		
	
		
		

			
		




		

		
	
	
	
		
	
	
	
	
	
		
		
			
			
	
	
	














/*参考：

来源：http://www.w3school.com.cn/sql/sql_top.asp	

【1】数据类型：http://www.w3school.com.cn/sql/sql_datatypes.asp
【2】date函数：http://www.w3school.com.cn/sql/sql_dates.asp

*/