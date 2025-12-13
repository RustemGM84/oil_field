create schema oil_field_;  # Создаю базу данных "Нефтяное месторождение"
use oil_field_;


create table `operators`(  # Создаю таблицу с данными операторов обслуживающих объекты нефтегазодобычи
    id int not null auto_increment primary key, # идентификатор оператора
    firstname varchar(50) ,  # имя оператора
    lastname varchar(50) comment 'surname',  # его фамилия
    email varchar(50) unique,  # электронная почта
    experience int,  # опыт работы (стаж)
    birthday date,  # дата рождения

    index idx_operatorname(firstname, lastname) # Составной индекс, состоящий из имени и фамилии
    );
   



create table oil_wells(  # Создаю таблицу с информацией о нефтегазодобывающих скважинах
    id int not null auto_increment primary key, # идентификатор скважины
    operator_id int not null,  # идентификатор обслуживающего оператора
    device_id int not null,  # идентификатор ГЗУ на которое работает скважина
    well_num int not null unique,  # номер скважины
    total_flow_rate int,  # дебит в м3 за сутки
    water_cut float,  # обводнённость в % от дебита
    gas_content float,  # содержание газа в % от дебита без учёта обводнённости
    pump_type enum('sucker rod', 'centrifugal','screw'),  # тип насоса в скважине
    pump_depth int,  # глубина насоса
    is_devonian bit,  # скважина добывает девонскую или сернистую нефть
    pressure int,  # давление на устье скважины
    lat float,  # широта локации скважины
    lon float  # долгота локации скважины
    );
alter table oil_wells add constraint fk_well_operator_id # связываю таблицы, содержащие информацию о скважинах и об операторах
foreign key (operator_id) references operators(id);

alter table oil_wells drop column lat;  # небольшой костыль;)
alter table oil_wells drop column lon;
 


create table group_measuring_devices(  # Создаю таблицу "Групповые Замеряющие Устройства"(ГЗУ)
    id int not null auto_increment primary key,  # идентификатор ГЗУ
    operator_id int not null,  # идентификатор обслуживающего оператора
    device_num int not null unique,  # номер ГЗУ
    has_dispenser bit,  # наличие насоса-дозатора на ГЗУ 
    station_id int not null,  # идентификатор ДНС
    dispenser_id int not null,  # идентификатор НД
    
    foreign key (operator_id) references operators(id));  # связываю данную таблицу с таблицей операторов
    
    
   alter table oil_wells add constraint fk_wells_devices_id  # связываю данную таблицу с таблицей скважин
   foreign key (device_id) references group_measuring_devices (id);
    
   
 
  
   
    
    
    create table dispensers(  # Создаю таблицу "Насосы-Дозаторы"(НД)
    id int not null auto_increment primary key,  # идентификатор НД
    reagent_type enum('against corrosion', 'demulsifier','against paraffin'),  # тип реагента, которое подаёт НД
    reagent_remainder int  # остаток рагента в ёмкости НД
    );

    alter table group_measuring_devices add constraint fk_device_dispenser_id  # связываю данную таблицу с таблицей ГЗУ
    foreign key (dispenser_id) references dispensers (id);
    
    
    
    create table pumping_stations(  # Создаю таблицу "Дожимная Насосная Станция"(ДНС)
    id int not null auto_increment primary key,  # идентификатор ДНС
    number int not null unique);  # номер ДНС
    
    
create table oil_production_2024( # Создаю таблицу "Добыча нефти за 2024 год"
            month varchar(50),  # месяц
            production_amount int); # количество нефти добытое за месяц

create table oil_production_2025( # Создаю таблицу "Добыча нефти за 2025 год"
             month varchar(50),
             production_amount int);

#Заполнение таблиц данными
insert into operators(firstname, lastname, email, experience, birthday)
values 
('Yuri', 'Gagarin', 'cosmos@mail.ru', 32, '1961-04-12'),
('Danis', 'Zaripov', 'akbars@gmail.com', 18, '1978-02-21'),
('Dmitri', 'Mendeleev', 'alchemy@outlook.com', 39, '1959-07-09'),
('Musa', 'Djalil', 'poetry@yandex.ru', 10, '1990-10-01'),
('Mintimer', 'Shaimiev', 'politics@gmail.com', 5, '1998-03-19'),
('Anton', 'Chehov', 'novel@mail.ru', 23, '1970-01-31'),
('Timur', 'Batrutdinov', 'comedy@internet.ru', 1, '2000-08-07'),
('Elon', 'Musk', 'tesla@outlook.com', 12, '1985-12-15'),
('Mark', 'Zuckerberg', 'facebook@yandex.ru', 3, '2003-12-31'),
('Pavel', 'Durov', 'vk@mail.ru', 25, '1970-01-01');
 



insert into dispensers (id, reagent_type, reagent_remainder)
values
(1, 'demulsifier', 32),
(2, 'against corrosion', 15),
(3, 'demulsifier', 12),
(4, 'against paraffin', 45),
(5, 'against corrosion', 73),
(6, 'against corrosion', 47),
(7, 'against paraffin', 22),
(8, 'demulsifier', 55),
(9, 'against paraffin', 68),
(10, 'demulsifier', 28);


insert into pumping_stations(id, number)
values 
(1,201),
(2,202);

INSERT INTO group_measuring_devices(id,operator_id, device_num, has_dispenser, station_id, dispenser_id) 
VALUES
(1,1,95,1,2,10),
(2,2,12,0,1,1),
(3,3,60,1,1,9),
(4,4,43,1,1,8),
(5,5,22,0,2,2),
(6,6,25,1,2,7),
(7,7,46,0,1,3),
(8,8,71,1,2,6),
(9,9,33,1,1,5),
(10,10,51,0,1,4),
(11,1,52,0,2,5),
(12,2,67,1,1,4),
(13,3,39,0,2,6),
(14,4,74,1,2,3),
(15,5,10,1,2,2),
(16,6,54,1,1,1),
(17,7,7,0,1,7),
(18,8,27,0,2,10),
(19,9,42,0,1,9),
(20,10,72,0,2,8);


INSERT INTO oil_wells
(id, operator_id, device_id, well_num, total_flow_rate, water_cut, gas_content, pump_type, pump_depth, is_devonian, pressure) 
VALUES
(201,7,1,3167,158,63,54,'sucker rod',1514,0,11),
(202,5,2,7681,113,52,23,'centrifugal',1895,0,21),
(203,6,3,1521,26,65,63,'sucker rod',1654,1,11),
(204,4,4,4559,78,73,49,'screw',1461,1,6),
(205,2,5,5099,130,67,35,'screw',1833,1,7),
(206,5,6,1568,188,9,65,'screw',931,1,28),
(207,7,7,7712,58,56,60,'sucker rod',1520,1,19),
(208,7,8,2304,135,28,38,'screw',1253,0,13),
(209,8,9,5756,52,36,33,'screw',1697,1,10),
(210,6,10,3262,259,75,30,'sucker rod',1495,1,31),
(211,5,11,2722,230,30,53,'sucker rod',890,0,6),
(212,7,12,6557,37,36,65,'screw',1851,1,20),
(213,10,13,4009,185,16,28,'screw',1669,0,28),
(214,1,14,8514,188,39,12,'screw',1926,1,34),
(215,7,15,4614,190,38,13,'centrifugal',1389,1,10),
(216,7,16,6568,104,34,63,'screw',1794,0,10),
(217,1,17,2832,130,52,39,'screw',1215,1,24),
(218,6,18,1531,212,20,41,'screw',1152,1,32),
(219,10,19,2821,138,75,49,'screw',1161,0,19),
(220,8,20,2528,83,10,37,'screw',1415,1,32),
(221,9,1,4644,55,34,25,'centrifugal',1786,1,21),
(222,9,2,8271,148,48,32,'centrifugal',1179,1,21),
(223,10,3,3760,217,68,23,'screw',1859,0,23),
(224,8,4,4633,19,30,14,'centrifugal',1000,0,24),
(225,1,5,3059,227,14,31,'centrifugal',1447,1,31),
(226,3,6,2747,65,39,36,'centrifugal',1488,1,25),
(227,7,7,6886,100,52,21,'sucker rod',1725,0,23),
(228,1,8,3083,80,64,42,'centrifugal',1121,1,29),
(229,4,9,1738,137,51,14,'sucker rod',1470,1,21),
(230,1,10,7400,219,14,24,'screw',894,1,34),
(231,8,11,7868,166,33,49,'centrifugal',930,1,6),
(232,4,12,6540,102,37,60,'centrifugal',805,0,26),
(233,7,13,1459,195,45,10,'centrifugal',1037,0,10),
(234,8,14,5983,205,47,20,'screw',1516,1,7),
(235,2,15,8229,194,9,20,'centrifugal',1691,0,8),
(236,10,16,5091,162,21,59,'centrifugal',1503,1,10),
(237,5,17,7511,201,64,20,'sucker rod',1272,1,11),
(238,7,18,8022,124,23,65,'sucker rod',1506,0,21),
(239,9,19,7653,240,34,12,'centrifugal',1120,1,18),
(240,4,20,5934,252,21,35,'sucker rod',1213,0,31),
(241,3,1,4208,166,10,39,'centrifugal',1836,1,5),
(242,7,2,3666,152,25,12,'screw',1294,1,25),
(243,10,3,3489,241,7,62,'centrifugal',1262,0,7),
(244,10,4,5472,131,15,56,'centrifugal',1416,0,33),
(245,2,5,1944,94,55,24,'screw',1668,1,24),
(246,7,6,4922,135,52,44,'centrifugal',1201,1,29),
(247,6,7,2413,203,18,28,'centrifugal',1155,1,32),
(248,7,8,3835,57,70,28,'centrifugal',1163,1,33),
(249,6,9,8240,239,42,20,'centrifugal',1559,1,21),
(250,2,10,1804,181,10,53,'sucker rod',1929,0,30),
(251,6,11,5167,94,14,32,'screw',1364,1,9),
(252,5,12,8045,68,50,48,'sucker rod',995,0,13),
(253,1,13,2365,40,70,18,'sucker rod',1686,0,21),
(254,10,14,8471,112,56,30,'centrifugal',842,1,8),
(255,2,15,3443,159,22,32,'centrifugal',850,1,5),
(256,6,16,8114,159,56,49,'sucker rod',899,0,30),
(257,4,17,8172,213,49,55,'centrifugal',1442,0,35),
(258,5,18,3426,228,44,37,'sucker rod',1733,0,17),
(259,1,19,3287,193,59,46,'sucker rod',1769,1,27),
(260,7,20,7007,253,31,36,'centrifugal',868,0,33),
(261,7,1,5026,125,56,49,'centrifugal',1918,0,29),
(262,1,2,1572,145,15,32,'screw',1685,1,27),
(263,1,3,3890,107,68,41,'screw',1444,0,12),
(264,9,4,2104,46,31,46,'sucker rod',1887,1,9),
(265,7,5,7774,36,6,60,'sucker rod',1641,1,18),
(266,10,6,3421,198,7,40,'centrifugal',1877,0,22),
(267,6,7,2993,28,73,11,'centrifugal',1675,0,30),
(268,6,8,2494,131,65,41,'centrifugal',1356,1,29),
(269,7,9,5715,157,25,45,'screw',1601,0,12),
(270,9,10,3708,85,56,59,'centrifugal',1941,1,31),
(271,4,11,7968,61,10,40,'centrifugal',1691,0x00,10),
(272,2,12,3726,222,35,55,'centrifugal',876,0,12),
(273,5,13,3821,29,68,14,'sucker rod',1271,1,27),
(274,1,14,2137,161,38,40,'centrifugal',892,1,30),
(275,4,15,6846,135,75,26,'centrifugal',875,0,20),
(276,3,16,1641,34,11,46,'sucker rod',1583,0,14),
(277,2,17,6962,37,7,34,'sucker rod',1789,0,14),
(278,10,18,1555,186,72,28,'sucker rod',1224,0,21),
(279,6,19,3783,253,15,29,'sucker rod',1688,0,14),
(280,10,20,4602,187,34,49,'centrifugal',891,1,19),
(281,6,1,3245,57,72,22,'sucker rod',1577,0,24),
(282,6,2,3252,21,65,55,'sucker rod',1321,1,32),
(283,10,3,7725,46,56,21,'centrifugal',882,0,27),
(284,2,4,1794,11,68,53,'sucker rod',934,1,5),
(285,1,5,6865,198,21,58,'sucker rod',1627,0,15),
(286,9,6,1722,250,57,47,'screw',1396,0,8),
(287,7,7,7094,181,36,54,'centrifugal',1085,1,33),
(288,5,8,5539,128,59,17,'sucker rod',1900,0,5),
(289,9,9,2481,100,45,24,'sucker rod',977,1,21),
(290,8,10,5568,173,65,14,'centrifugal',1449,0,18),
(291,5,11,2246,157,19,52,'screw',1342,0,25),
(292,3,12,2479,155,5,22,'screw',1699,0,11),
(293,8,13,1995,173,63,61,'screw',1295,1,27),
(294,6,14,5874,245,36,37,'sucker rod',1209,0,25),
(295,9,15,8450,252,73,45,'screw',1122,1,9),
(296,1,16,6406,203,19,43,'centrifugal',1377,0,12),
(297,8,17,7721,56,62,17,'centrifugal',1097,1,24),
(298,6,18,8526,154,60,21,'sucker rod',834,0,29),
(299,2,19,5474,13,35,21,'screw',1731,0,20),
(300,7,20,6739,16,51,47,'screw',1126,1,7);


alter table oil_wells add column lat float;
alter table oil_wells add column lon float;

update oil_wells 
set lat = -70.3
where id = 210;

update oil_wells 
set lat = -77.2
where id = 279;

update oil_wells 
set lat = -75.2
where id = 260;

update oil_wells 
set lat = -78.8
where id = 240;

update oil_wells 
set lat = -77.2
where id = 295;

update oil_wells 
set lon = -63.2
where id = 210;

update oil_wells 
set lon = -5.6
where id = 279;

update oil_wells 
set lon = 51
where id = 260;

update oil_wells 
set lon = 90.4
where id = 240;

update oil_wells 
set lon = -124.8
where id = 295;




insert into oil_production_2025
values
('31.01.2025', 463814),
('28.02.2025', 466193),
('31.03.2025', 484302),
('30.04.2025', 491834),
('31.05.2025', 488761),
('30.06.2025', 463559),
('31.07.2025', 470117),
('31.08.2025', 474673),
('30.09.2025', 481576),
('31.10.2025', 481317),
('30.11.2025', 482954),
('31.12.2025', 461254);


insert into oil_production_2024
values
('31.01.2024', 422634),
('28.02.2024', 407357),
('31.03.2024', 422078),
('30.04.2024', 429142),
('31.05.2024', 490072),
('30.06.2024', 423763),
('31.07.2024', 421481),
('31.08.2024', 422304),
('30.09.2024', 427089),
('31.10.2024', 427496),
('30.11.2024', 412658),
('31.12.2024', 411183);


create view work_volume as # Создаю представление, которое кроме прочей информации об операторе показывает количество обслуживаемых им скважин и ГЗУ
select o.id, firstname, lastname, experience, birthday, count(well_num), count(distinct device_id)
from operators as o 
join oil_wells as w on o.id = w.operator_id
group by 1, 2, 3, 4, 5
order by 1



create function get_devonian_percentage()  # Создаю функцию, которая возвращает процентное соотношение
returns float                              # количества девонских скважин к общему фонду 
reads sql data
begin
	declare total_well_amount int; 
    declare devonian_well_amount int;
    declare res float;
    set total_well_amount = (select count(*) 
                             from oil_wells);
    set devonian_well_amount = (select count(*)
                                from oil_wells
                                where is_devonian = 1);
    set res = devonian_well_amount / total_well_amount;
    return res;
end;


create procedure device_measures()  # Создаю процедуру, которая показывает измерение в м3 на ГЗУ за сутки 
begin
	select device_num, device_id, sum(total_flow_rate) as measure from group_measuring_devices as d 
    join oil_wells as w 
    on d.id = w.device_id 
    group by 1, 2;
end 



