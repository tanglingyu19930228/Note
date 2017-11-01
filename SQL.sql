SQL语句

一：设计数据库

	1.数据库(DATABASE)
	
		创建：mysql> CREATE DATABASE d1;
		删除：mysql> DROP DATABASE d1;
		查看：mysql> SHOW DATABASES;
		切换：mysql> USE d1；
	
	2.数据表(TABLE)
	
		创建：
		
			mysql> create table t1(
				ID int NOT NULL AUTO_INCREMENT，
				number1 int(10) UNSIGNED NOT NULL,
				number2 int NOT NULL,
				name1 VARCHAR(255),
				name2 VARCHAR(255) ENUM('a','b'),
				name3 VARCHAR(255) DEFAULT 'Cshare',
				
				PRIMARY KEY(ID),
				FOREIGN KEY (number1) REFERENCES t2(number1),
				CHECK(number2>1)，
				UNIQUE(name1),
				);
								 
		删除：
		
			mysql> DROP TABLE t1;
			--删除t1表
			
		查看：
		
			mysql> SHOW TABLES;
			--查看当前数据库下的所有表
			mysql> SHOW COLUMNS FROM t1;
			--查看t1表的表结构
			mysql> SHOW CREATE TABLE t1;
			--查看t1表的创建信息，可找到自动生成的索引名称
		
		改动：
		
			mysql> ALTER TABLE t1 RENAME TO t2;
			--t1表重命名为t2表
			mysql> ALTER TABLE t1 ADD column1 ENUM('old','young') NOT NULL
			--t1表中添加column1列
			mysql> ALTER TABLE t1 DROP column1
			--t1表中删除column1列
			
二：管理约束：

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
			
三：管理单表：
	
	1.SELECT
	
		*简单选取
		
			mysql> SELECT column1,column2 FROM t1;
			mysql> SELECT * FROM t1;
			mysql> SELECT DISTINCT column1 FROM t1;--去重
		
		*复杂选取
		
			--WHERE子句{=,<>,>,<,>=,<=,BETWEEN,LIKE}
				mysql> SELECT * FROM t1 WHERE column1='Cshare';
				mysql> SELECT * FROM t1 WHERE column1>100;
				mysql> SELECT *FROM t1 WHERE column1 BETWEEN 4 AND 8
				--BETWEEN可以是数字，文本，日期
				mysql> SELECT *FROM tb1 WHERE username LIKE 'c%'
				mysql> SELECT *FROM tb1 WHERE username NOT LIKE '_c%'
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
	
	2.INSERT
	
		mysql> INSERT INTO t1 VALUES(value1,value2,value3);
		--t1有多少列，values就要有多少值
		mysql> INSERT INTO t1(column1,column2) VALUES(value1,value2);
		--column和value需要一一对应
	
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
	
	
	
	
	
	
		
		
			
			
	
	
	















--http://www.w3school.com.cn/sql/sql_top.asp	
/*参考：数据类型 http://www.w3school.com.cn/sql/sql_create_table.asp*/