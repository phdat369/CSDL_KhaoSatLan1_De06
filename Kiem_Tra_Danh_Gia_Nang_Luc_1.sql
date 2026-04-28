-- Tạo CSDL
create database hackathon1;
use hackathon1;
-- Tạo bảng Properties 
create table properties (
   property_id varchar(5) primary key,
   property_name varchar(100) not null unique,
   location varchar(100) not null,
   price_per_night decimal(10,2) not null check (price_per_night > 0),
   status varchar(20) not null check (status in ('Available', 'Booked', 'Maintenance'))
);
-- Tạo bảng Guests
create table guests (
   guest_id varchar(5) primary key,
   full_name varchar(100) not null,
   email varchar(100) not null unique,
   phone varchar(15)  not null,
   guest_type varchar(50) not null check (guest_type in ('Regular', 'VIP', 'Member'))
);
-- Tạo bảng Bookings
create table bookings (
   booking_id int auto_increment primary key,
   property_id varchar(5) not null,
   guest_id varchar(5) not null,
   check_in_date date not null,
   check_out_date date not null,
   total_price decimal(10,2) check (total_price > 0),
   foreign key (property_id) references properties (property_id),
   foreign key (guest_id) references guests (guest_id),
   unique (property_id,check_in_date)
);
-- Tạo bảng Services
create table services (
   service_id int auto_increment primary key,
   booking_id int not null,
   service_name varchar(100) not null,
   service_fee decimal(10,2) not null check (service_fee > 0),
   service_date date not null,
   foreign key (booking_id) references bookings (booking_id)
);
-- Thêm dữ liệu cho bảng Properties
insert into properties (property_id,property_name,location,price_per_night,status) 
values ('P01', 'Sunrise Villa', 'Đà Lạt', 2000000.00, 'Available'),
       ('P02', 'Ocean View Apartment', 'Đà Nẵng', 1500000.00, 'Booked'),
       ('P03', 'Green Garden Homestay', 'Hà Nội', 800000.00, 'Available'),
       ('P04', 'Mountain Retreat', 'Sa Pa', 1200000.00, 'Booked'),
       ('P05', 'City Central Studio', 'TP HCM', 1000000.00, 'Maintenance');
-- Thêm dữ liệu cho bảng Guests
insert into guests (guest_id,full_name,email,phone,guest_type)
values ('G01', 'Nguyễn Văn Nam', 'nam.nv@gmail.com', '0912345678', 'VIP'),
       ('G02', 'Trần Thị Lan', 'lan.tt@gmail.com', '0987654321', 'Regular'),
       ('G03', 'Lê Minh Quang', 'quang.lm@gmail.com', '0978123456', 'Member'),
       ('G04', 'Phạm Bảo Châu', 'chau.pb@gmail.com', '0909876543', 'Regular'),
       ('G05', 'Hoàng Anh Đức', 'duc.ha@gmail.com', '0911222333', 'VIP');
-- Thêm dữ liệu cho bảng bookings
insert into bookings (property_id,guest_id,check_in_date,check_out_date,total_price)
values ('P01', 'G01', '2025-11-01', '2025-11-05', 8000000.00),
       ('P02', 'G02', '2025-11-10', '2025-11-12', 3000000.00),
       ('P03', 'G03', '2025-11-15', '2025-11-16', 800000.00),
       ('P04', 'G01', '2025-11-20', '2025-11-25', 6000000.00),
       ('P01', 'G04', '2025-12-01', '2025-12-05', 8000000.00),
       ('P02', 'G05', '2025-12-10', '2025-12-15', 7500000.00);
-- Thêm dữ liệu cho bảng Services
insert into services (booking_id,service_name,service_fee,service_date)
values (1, 'Ăn sáng', 200000.00, '2025-11-02'),
       (1, 'Giặt là', 100000.00, '2025-11-03'),
       (2, 'Thuê xe máy', 150000.00, '2025-11-11'),
       (4, 'Ăn sáng', 200000.00, '2025-11-21');
-- Phần 1 Câu 4
update properties
set price_per_night = price_per_night * 1.1
where property_id = 'P01';
-- Phần 1 Câu 5
update guests 
set guest_type = 'Member'
where guest_id = 'G02';
-- Phần 1 Câu 6
delete 
from services
where service_fee < 150000;
-- Phần 1 Câu 7
-- Đã thêm ở phần tạo bảng 
-- Phần 1 Câu 8
alter table properties
alter column status set default 'Available';
-- Phần 1 Câu 9
alter table properties
add column rating int check (rating between 1 and 5);
-- Phần 2 Câu 10
select property_name
from properties 
where price_per_night between 1000000 and 2000000;
-- Phần 2 Câu 11
select full_name,email
from guests
where full_name like ('%n%');
-- Phần 2 Câu 12
select property_id,property_name,location
from properties
order by price_per_night asc;
-- Phần 2 Câu 13
select booking_id
from bookings
order by total_price desc
limit 3;
-- Phần 2 Câu 14
select property_name,location
from properties
limit 3
offset 1;
-- Phần 2 Câu 15
update bookings
set total_price = total_price * 0.95
where check_in_date < '2025-11-15';
-- Phần 2 Câu 16
update properties
set location = upper(location);
-- Phần 2 Câu 17
delete 
from guests
where guest_id not in (select guest_id
					from bookings);
-- Phần 3 Câu 18
select booking_id,
	   (select full_name 
        from guests g
        where b.guest_id = g.guest_id) as full_name,
	   (select property_name
        from properties p 
        where b.property_id = p.property_id) as property_name,
	   check_in_date
from bookings b 
where guest_id in (select guest_id
                   from guests
                   where guest_type = 'VIP');
-- Phần 3 Câu 19 
select (select property_name
        from properties p
        where b.property_id = p.property_id) as property_name,
	   count(property_id) as 'Số lần đặt phòng'
from bookings b
group by property_id;
-- Phần 3 câu 20
select (select location
		from properties p 
        where b.property_id = p.property_id) as location,
        sum(total_price) as total_price
from bookings b 
group by property_id;
-- Phần 3 Câu 21
select (select property_name
        from properties p
		where p.property_id = b.property_id) as property_name,
        count(property_id) as 'Số lần đặt phòng'
from bookings b
group by b.property_id
having count(property_id) >= 2; 
-- Phần 3 Câu 22
select property_name
from properties
where price_per_night > (select avg(price_per_night)
                         from properties);
-- Phần 3 Câu 23
select (select full_name
        from guests g 
        where g.guest_id = b.guest_id) as full_name
from bookings b 
where b.booking_id in (select booking_id
                      from services s 
                      where s.booking_id = b.booking_id);
-- Phần 3 Câu 24
select booking_id
from bookings 
where (datediff(check_out_date,check_in_date)) > 3;
-- Phần 3 Câu 25
select b.booking_id,
       (total_price +  service_fee) as 'Tổng số tiền phải trả'
from bookings b
join services s
on s.booking_id = b.booking_id;