-- Active: 1714855398347@@185.198.166.80@34657@DB_PIZZA_ACTION
-- 1
-- Количество клиентов, которых обслужили за месяц. РАБОТАЕТ

SELECT COUNT(DISTINCT client)
FROM Заказы
WHERE EXTRACT(MONTH FROM date_of_order) = 4;

-- 2
-- Сколько каждый из клиентов сделал заказов, вывести все личные данные 
--клиента, количество заказов и сумму заказов. Вывести в алфавитном порядке. РАБОТАЕТ
SELECT Клиенты.full_name, Клиенты.adress, Клиенты.phone_number, COUNT(Заказы.order_id) AS количество_заказов, SUM(Заказы.sum_of_order) AS сумма_заказов
FROM Клиенты
LEFT JOIN Заказы ON Клиенты.client_id = Заказы.client
GROUP BY Клиенты.client_id
ORDER BY Клиенты.full_name ASC;

-- 3
-- Вычислить зарплату всех продавцов. В итоговой ведомости указать Имя,
-- Отчество, Фамилию продавца, количество выполненных и невыполненных им заказов,
-- оплату за выполненные заказы и штрафы за невыполненные, итоговую причитающуюся РАБОТАЕТ
-- сумму продавцу.
SELECT
    Продавцы.full_name AS Имя,
    COUNT(CASE WHEN Заказы.status_of_order = 1 THEN Заказы.order_id END) AS количество_выполненных_заказов,
	SUM(CASE WHEN Заказы.status_of_order = 1 THEN Заказы.sum_of_order * 0.1 ELSE 0 END) AS оплата_за_выполненные_заказы,
    COUNT(CASE WHEN Заказы.status_of_order = 2 THEN Заказы.order_id END) AS количество_невыполненных_заказов,
    SUM(CASE WHEN Заказы.status_of_order = 2 THEN Заказы.sum_of_order * 0.5 ELSE 0 END) AS штраф_за_невыполненный_заказ,
	COALESCE(SUM(Штрафы.sum_of_penalty), 0) AS штраф_по_ведомости,
    CASE 
        WHEN SUM(CASE WHEN Заказы.status_of_order = 1 THEN Заказы.sum_of_order * 0.1 ELSE 0 END) - SUM(CASE WHEN Заказы.status_of_order = 2 THEN Заказы.sum_of_order * 0.5 ELSE 0 END) - COALESCE(SUM(Штрафы.sum_of_penalty), 0) < 0 
        THEN 0 
        ELSE SUM(CASE WHEN Заказы.status_of_order = 1 THEN Заказы.sum_of_order * 0.1 ELSE 0 END) - SUM(CASE WHEN Заказы.status_of_order = 2 THEN Заказы.sum_of_order * 0.5 ELSE 0 END) - COALESCE(SUM(Штрафы.sum_of_penalty), 0) 
    END AS Итоговая_сумма
FROM Продавцы
LEFT JOIN Заказы ON Продавцы.seller_id = Заказы.seller
LEFT JOIN Штрафы ON Продавцы.seller_id = Штрафы.customer
GROUP BY Продавцы.seller_id;


-- 4 
-- Сколько денег потратили сами продавцы на продукцию своей фирмы.
-- Указать имена продавцов, количество сделанных ими заказов и суммы.  РАБОТАЕТ?

SELECT Продавцы.full_name AS Имя_продавца,
COUNT(Заказы.order_id) AS количество_заказов,
SUM(Заказы.sum_of_order) AS сумма_потраченных_денег
FROM Продавцы
JOIN Заказы ON Продавцы.seller_id = Заказы.seller
GROUP BY Продавцы.seller_id;

-- 5
--  Список проданных блюд (рецептов), отсортированных в порядке убывания количества продаж. РАБОТАЕТ
SELECT
    Блюда.naming AS название_блюда,
    COUNT(Состав_заказа.order_id) AS количество_продаж
FROM Блюда
LEFT JOIN Состав_заказа ON Блюда.dishe_id = Состав_заказа.dishe_id
GROUP BY Блюда.naming
ORDER BY количество_продаж DESC;
-- 6 
-- Прибыль, полученная фирмой. Не учитывать зарплату продавцам, считать прибыль
-- как разницу между закупочной стоимостью потраченных ингредиентов и продажной. РАБОТАЕТ?
SELECT 
    SUM(Заказы.sum_of_order) - SUM(Поставки.amount_of_ingridients * Ингридиенты.price) AS Прибыль
FROM 
    Заказы
JOIN 
    Состав_заказа ON Заказы.order_id = Состав_заказа.order_id
JOIN 
    Блюда ON Состав_заказа.dishe_id = Блюда.dishe_id
JOIN 
    Поставки ON Блюда.dishe_id = Поставки.ingridient
JOIN 
    Ингридиенты ON Поставки.ingridient = Ингридиенты.ingridient_id;
    
-- 7 
-- Меню, указывается наименование блюда, перечисляются все его ингредиенты, указывается калорийность и состав. РАБОТАЕТ
SELECT
    Блюда.naming AS Наименование_блюда,
    ARRAY_AGG(Ингридиенты.naming) AS Ингредиенты,
    Блюда.calory AS Калорийность,
    ARRAY_AGG(Ингридиенты.naming || ' (' || Состав_Блюда.amount_of_ingridients || ')' ) AS Состав
FROM Блюда
JOIN Состав_Блюда ON Блюда.dishe_id = Состав_Блюда.dishe_id
JOIN Ингридиенты ON Состав_Блюда.ingridient_id = Ингридиенты.ingridient_id
GROUP BY Блюда.naming, Блюда.calory;

-- 8 
-- Отчет по поставкам. Указать поставщика, наименование ингредиента,
--количество поставленного ингредиента за 10.2001 РАБОТАЕТ
SELECT
    Поставщики.naming AS Поставщик,
    Ингридиенты.naming AS Наименование_ингредиента,
    Поставки.amount_of_ingridients AS Количество_поставленного_ингредиента
FROM
    Поставки
JOIN
    Поставщики ON Поставки.supply_id = Поставщики.supplier_id
JOIN
    Ингридиенты ON Поставки.ingridient = Ингридиенты.ingridient_id
WHERE
    EXTRACT(YEAR FROM Поставки.date_of_suply) = 2024
    AND EXTRACT(MONTH FROM Поставки.date_of_suply) = 4;

-- 9 
-- Список использованных ингредиентов и их количества, по каждой неделе.
-- Указать номер недели, наименование ингредиента, количество. РАБОТАЕТ
SELECT
    EXTRACT(WEEK FROM Заказы.date_of_order) AS Номер_недели,
    Ингридиенты.naming AS Наименование_ингредиента,
    SUM(Состав_Блюда.amount_of_ingridients) AS Количество
FROM
    Заказы
JOIN
    Состав_заказа ON Заказы.order_id = Состав_заказа.order_id
JOIN
    Блюда ON Состав_заказа.dishe_id = Блюда.dishe_id
JOIN
    Состав_Блюда ON Блюда.dishe_id = Состав_Блюда.dishe_id
JOIN
    Ингридиенты ON Состав_Блюда.ingridient_id = Ингридиенты.ingridient_id
GROUP BY
    Номер_недели, Ингридиенты.naming
ORDER BY
    Номер_недели;


-- 10
-- 10.1 РАБОТАЕТ
SELECT seller_id, full_name, SUM(sum_of_order) AS total_sales
FROM Заказы
JOIN Продавцы ON Заказы.seller = Продавцы.seller_id
GROUP BY seller_id, full_name
ORDER BY total_sales DESC;

-- 10.2 РАБОТАЕТ
SELECT seller_id, full_name, COUNT(order_id) AS total_orders
FROM Заказы
JOIN Продавцы ON Заказы.seller = Продавцы.seller_id
GROUP BY seller_id, full_name
ORDER BY total_orders DESC;

-- 10.3  работает
SELECT 
Продавцы.full_name AS Имя_продавца,
COUNT(CASE WHEN Заказы.status_of_order = 2 THEN Заказы.order_id END) AS количество_невыполненных_заказов
FROM Продавцы
LEFT JOIN Заказы ON Продавцы.seller_id = Заказы.seller
WHERE Заказы.status_of_order = 2
GROUP BY Продавцы.full_name
ORDER BY количество_невыполненных_заказов ASC;


-- 6
-- Прибыль, полученная фирмой. Не учитывать зарплату продавцам, считать прибыль
-- как разницу между закупочной стоимостью потраченных ингредиентов и продажной.