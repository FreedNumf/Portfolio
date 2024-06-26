﻿**Модуль 3. Домашнее задание по теме «Основы SQL»**

**Цели домашнего задания:**

- закрепить на практике знания по функциям агрегации и группировке строк;
- научиться фильтровать сгруппированные строки;
- закрепить навыки использования методов соединения таблиц с помощью разных вариаций JOIN.

**Перечень заданий**

**Основная часть:**

Задание 1. Выведите для каждого покупателя его адрес, город и страну проживания.
Ожидаемый результат запроса: [letsdocode.ru...in/3-1.png](https://letsdocode.ru/sql-main/3-1.png)

Задание 2. С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
Ожидаемый результат запроса: [letsdocode.ru.../3-2-1.png](https://letsdocode.ru/sql-main/3-2-1.png)
Доработайте запрос и выведите только те магазины, у которых количество покупателей больше 300. Для решения используйте фильтрацию по сгруппированным строкам с функцией агрегации. Ожидаемый результат запроса: [letsdocode.ru.../3-2-2.png](https://letsdocode.ru/sql-main/3-2-2.png)
Доработайте запрос, добавив в него информацию о городе магазина, фамилии и имени продавца, который работает в нём. Ожидаемый результат запроса: [letsdocode.ru.../3-2-3.png](https://letsdocode.ru/sql-main/3-2-3.png)

Задание 3. Выведите топ-5 покупателей, которые взяли в аренду за всё время наибольшее количество фильмов.
Ожидаемый результат запроса: [letsdocode.ru...in/3-3.png](https://letsdocode.ru/sql-main/3-3.png)

Задание 4. Посчитайте для каждого покупателя 4 аналитических показателя:

- количество взятых в аренду фильмов;
- общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа);
- минимальное значение платежа за аренду фильма;
- максимальное значение платежа за аренду фильма.
  Ожидаемый результат запроса: [letsdocode.ru...in/3-4.png](https://letsdocode.ru/sql-main/3-4.png)

Задание 5. Используя данные из таблицы городов, составьте все возможные пары городов так, чтобы в результате не было пар с одинаковыми названиями городов. Задание необходимо выполнить, используя Декартово произведение.
Ожидаемый результат запроса: [letsdocode.ru...in/3-5.png](https://letsdocode.ru/sql-main/3-5.png)

Задание 6. Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental\_date) и дате возврата (поле return\_date), вычислите для каждого покупателя среднее количество дней, за которые он возвращает фильмы. В результате должны быть дробные значения, а не интервал.
Ожидаемый результат запроса: [letsdocode.ru...in/3-6.png](https://letsdocode.ru/sql-main/3-6.png)

**Дополнительная часть:**

Задание 1. Посчитайте для каждого фильма, сколько раз его брали в аренду, а также общую стоимость аренды фильма за всё время.
Ожидаемый результат запроса: [letsdocode.ru...in/3-7.png](https://letsdocode.ru/sql-main/3-7.png)

Задание 2. Доработайте запрос из предыдущего задания и выведите с помощью него фильмы, которые отсутствуют на dvd-дисках.
Ожидаемый результат запроса: [letsdocode.ru...in/3-8.png](https://letsdocode.ru/sql-main/3-8.png)

Задание 3. Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 7 300, то значение в колонке будет «Да», иначе должно быть значение «Нет».
Ожидаемый результат запроса: [letsdocode.ru...in/3-9.png](https://letsdocode.ru/sql-main/3-9.png)

