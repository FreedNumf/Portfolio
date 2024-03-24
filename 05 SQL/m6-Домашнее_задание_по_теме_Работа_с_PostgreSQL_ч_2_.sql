--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".
explain analyze -- cost=0.00..68.84
select film_id, initcap (title) as "title", special_features
from film 
where special_features && array ['Behind the Scenes'];



--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.
explain analyze -- cost=0.00..72.50
select  film_id, initcap (title) as "title", special_features 
from film 
where special_features::text ilike '%Behind the Scenes%';

explain analyze -- cost=248.13..316.94
select f.film_id, initcap (f.title) as "title", f.special_features
from (
	select film_id, title, unnest (special_features) 
	from film) t 
join film f on f.film_id = t.film_id and t.unnest = 'Behind the Scenes';


--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.
explain analyze --cost=719.27..720.76
with cte as 
(
select film_id, initcap (title) as "title", special_features
from film 
where special_features && array ['Behind the Scenes']
)
select c.customer_id, count(cte.film_id) as film_count
from customer c
	join rental r on c.customer_id = r.customer_id
	join inventory i on r.inventory_id = i.inventory_id
	join cte on cte.film_id = i.film_id 
group by c.customer_id
order by c.customer_id;


--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.
explain analyze --cost=673.98..675.48
select r.customer_id, count(f.film_id) as film_count
from (
	 select film_id, initcap (title) as "title", special_features
	 from film 
	 where special_features && array ['Behind the Scenes']
	 ) f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by r.customer_id
order by r.customer_id;


--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view Behind_the_Scenes as
select r.customer_id, count (f.film_id) as film_count
from (
	 select film_id, initcap (title) as "title", special_features
	 from film 
	 where special_features && array ['Behind the Scenes']
	 ) f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by r.customer_id
order by r.customer_id;

explain analyze
select * from Behind_the_Scenes

explain analyze
refresh materialized view Behind_the_Scenes

--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ стоимости выполнения запросов из предыдущих заданий и ответьте на вопросы:
--1. с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания: 
--поиск значения в массиве затрачивает меньше ресурсов системы;
Проведя анализ стоимости выполнения запросов я сделал вывод, что при использовании специального атрибута при поиске значения в массиве затрачивается меньше ресурсов.
Задание 1
cost=0.00..68.84
Задание 2
cost=0.00..72.50
против других без использования специального атрибута
cost=248.13..316.94
cost=719.27..720.76
cost=673.98..675.48



--2. какой вариант вычислений затрачивает меньше ресурсов системы: 
--с использованием CTE или с использованием подзапроса.
Вариант вычислений с использованием подзапроса затрачивает меньше ресурсов (cost=673.98..675.48 actual time=11.772..11.796)
против варианта с использованием CTE (cost=719.27..720.76 actual time=23.200..23.225)




--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии

--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.





--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день




