drop table if exists `operators`;
create table `operators`(
    id int not null auto_increment primary key,
    firstname varchar(50) ,
    lastname varchar(50) comment 'surname',
    email varchar(50) unique,
    experience int,

    index idx_operatorname(firstname, lastname)
    );
   
alter table `operators` add column birthday date ;
