--1 Выведите названия самолётов, которые имеют менее 50 посадочных мест. 10 баллов

select a.model as "названия самолётов"
from aircrafts a 
join seats s on s.aircraft_code = a.aircraft_code 
group by a.aircraft_code having count (s.seat_no) < 50;

--2 Выведите процентное изменение ежемесячной суммы бронирования билетов, округленной до сотых. 25 баллов

select date_trunc ('month', book_date) as "дата", sum (total_amount) as "сумма", 
	round (((sum (total_amount) - 
	lag (sum (total_amount), 1) over (order by date_trunc ('month', book_date))) / 
	lag (sum (total_amount), 1) over (order by date_trunc ('month', book_date))) * 100, 2) as "процентное изменение"
from bookings
group by "дата" 

--3 Выведите названия самолётов без бизнес-класса. Используйте в решении функцию array_agg. 2 строки с 2мя самолетамb 15 баллов

--Вариант 1 
select a.model as "названия самолётов"
from seats s 	
join aircrafts a on a.aircraft_code = s.aircraft_code	
group by s.aircraft_code, a.model having array_position (array_agg (fare_conditions), 'Business') is null;

--Вариант 2 с подзапросом
select a.model as "названия самолётов"
from (
	select s.aircraft_code, array_agg (fare_conditions) 
	from seats s 
	group by s.aircraft_code having array_position (array_agg (fare_conditions), 'Business') is null
	) f
join aircrafts a on a.aircraft_code = f.aircraft_code

/*4 Выведите накопительный итог количества мест в самолётах по каждому аэропорту на каждый день. 
 * Учтите только те самолеты, которые летали пустыми и только те дни, когда из одного аэропорта вылетело более одного такого самолёта.
        Выведите в результат код аэропорта, дату вылета, количество пустых мест и накопительный итог. 35 баллов*/

with cte1 as (
	select *, count (f.aircraft_code) over (partition by f.departure_airport, f.actual_departure::date) count_flights
	from flights f
	left join boarding_passes b on b.flight_id = f.flight_id 
	where b.boarding_no is null and (f.status = 'Departed' or f.status = 'Arrived')),
cte2 as (
	select *
	from cte1
	where count_flights > 1),
cte3 as(
	select s.aircraft_code, count (*) as seat
	from seats s
	group by s.aircraft_code),
cte4 as (
	select cte2.departure_airport, cte2.actual_departure, cte3.seat
	from cte2
	join cte3 on cte3.aircraft_code = cte2.aircraft_code
	order by cte2.departure_airport, cte2.actual_departure)
select *, sum (cte4.seat) over (partition by cte4.departure_airport, cte4.actual_departure::date order by cte4.actual_departure) as "Накопительный итог"
from cte4

/*5 Найдите процентное соотношение перелётов по маршрутам от общего количества перелётов. Выведите в результат названия аэропортов и процентное отношение.
        Используйте в решении оконную функцию 20 баллов*/
	
select distinct a.airport_name  as "вылет", b.airport_name  as "прилет", 
		round(count (flight_id) over (partition by flight_no)::numeric / count (flight_id) over ()::numeric * 100, 2) as "процентное отношение"
from flights f  
join airports a on a.airport_code = f.departure_airport	
join airports b on b.airport_code = f.arrival_airport

--6 Выведите количество пассажиров по каждому коду сотового оператора. Код оператора – это три символа после +7. 15 баллов

select substring (contact_data ->> 'phone' from 3 for 3) as "Код сотового оператора", count (passenger_id) as "Количество пассажиров"
from tickets
group by "Код сотового оператора";

/*7 Классифицируйте финансовые обороты (сумму стоимости билетов) по маршрутам:
    до 50 млн – low
    от 50 млн включительно до 150 млн – middle
    от 150 млн включительно – high
    Выведите в результат количество маршрутов в каждом полученном классе. 20 баллов*/

select distinct t.class as "класс", count (t.class) as "количество маршрутов"
from (
	select flight_no, sum (t1.amount),
	case when sum (t1.amount) < 50000000 then 'low'
	when sum (t1.amount) >= 50000000 and sum (t1.amount) < 150000000 then 'middle'
	else 'high'
	end as "class"
		from flights f 
		join ticket_flights t1 on t1.flight_id = f.flight_id 
		group by flight_no) t
group by t.class

--8*Вычислите медиану стоимости билетов, медиану стоимости бронирования и отношение медианы бронирования к медиане стоимости билетов, результат округлите до сотых. 25 баллов

select percentile_cont (0.5) within group (order by t1.amount) as "Медиана стоимости билета", 
	   (select percentile_cont (0.5) within group (order by b.total_amount) from bookings b ) as "Медиана стоимости бронирования",
	   round((select percentile_cont (0.5) within group (order by b.total_amount) from bookings b)::numeric / (percentile_cont (0.5) within group (order by t1.amount))::numeric, 2) as " Процентное отношение"
from tickets t 
join ticket_flights t1 on t1.ticket_no = t.ticket_no 

/* 9*Найдите значение минимальной стоимости одного километра полёта для пассажира. 
    Для этого определите расстояние между аэропортами и учтите стоимость билетов.
    Для поиска расстояния между двумя точками на поверхности Земли используйте дополнительный модуль earthdistance. Для работы данного модуля нужно установить ещё один модуль – cube.
	Важно: 
	Установка дополнительных модулей происходит через оператор CREATE EXTENSION название_модуля.
	В облачной базе данных модули уже установлены.
	Функция earth_distance возвращает результат в метрах. 35 баллов*/

create extension cube

create extension earthdistance

with cte1 as (
	select f.flight_id, f.departure_airport, a.longitude as dlong, a.latitude as dlat, f.arrival_airport, a1.longitude as along, a1.latitude as alat
	from flights f
	join airports a on a.airport_code = f.departure_airport
	join airports a1 on a1.airport_code = f.arrival_airport),
cte2 as (
	select cte1.flight_id, earth_distance (ll_to_earth (cte1.dlat, cte1.dlong), ll_to_earth (cte1.alat, cte1.along)) / 1000 as distance
	from cte1),
cte3 as (
	select t1.flight_id, min (t1.amount) as min_am
	from ticket_flights t1
	group by t1.flight_id)
select round((cte3.min_am / distance)::numeric,2) as "минимальная стоимость 1 км"
from cte2
join cte3 on cte3.flight_id = cte2.flight_id
order by "минимальная стоимость 1 км"
limit 1

