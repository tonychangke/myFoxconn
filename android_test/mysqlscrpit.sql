create table map_db
(                   
	id int unsigned not null auto_increment primary key,
	mapid int unsigned not null,
	mapurl char(10) not null
);

insert into map_db2 values(NULL,"123","1.jpg");
insert into map_db2 values(NULL,"456","2.jpg");