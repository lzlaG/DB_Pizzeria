-- 1
-- Количество клиентов, которых обслужили за месяц. не робит

SELECT COUNT(DISTINCT client)
FROM Заказы
WHERE EXTRACT(MONTH FROM date_of_order) = 3;

-- 2
-- Сколько каждый из клиентов сделал заказов, вывести все личные данные 
--клиента, количество заказов и сумму заказов. Вывести в алфавитном порядке. СОМНИТЕЛЬНО
SELECT 
    c.client_id,
    c.full_name,
    c.adress,
    c.phone_number,
    COUNT(o.order_id) AS количество_заказов,
    SUM(o.sum_of_order) AS сумма_заказов
FROM  Клиенты c
LEFT JOIN Заказы o ON c.client_id = o.client
GROUP BY c.client_id, c.full_name, c.adress, c.phone_number
ORDER BY  c.full_name;

-- 3
-- Вычислить зарплату всех продавцов. В итоговой ведомости указать Имя,
-- Отчество, Фамилию продавца, количество выполненных и невыполненных им заказов,
-- оплату за выполненные заказы и штрафы за невыполненные, итоговую причитающуюся СОМНИТЕЛЬНО
-- сумму продавцу.
SELECT
    p.full_name,
    p.salary,
    COUNT(CASE WHEN o.status_of_order = 1 THEN 1 END) AS выполненные_заказы,
    COUNT(CASE WHEN o.status_of_order = 2 THEN 1 END) AS невыполненные_заказы,
    COALESCE(SUM(CASE WHEN o.status_of_order = 1 THEN o.sum_of_order END), 0) AS оплата_за_выполненные_заказы,
    COALESCE(SUM(CASE WHEN o.status_of_order = 2 THEN penalty.sum_of_penalty END), 0) AS штрафы_за_невыполненные_заказы,
    COALESCE(SUM(CASE WHEN o.status_of_order = 1 THEN o.sum_of_order ELSE -penalty.sum_of_penalty END), 0) AS итоговая_сумма
FROM Продавцы p
LEFT JOIN Заказы o ON p.seller_id = o.seller
LEFT JOIN Штрафы penalty ON p.seller_id = penalty.customer
GROUP BY p.full_name, p.salary
ORDER BY p.full_name;

-- 4 
-- Сколько денег потратили сами продавцы на продукцию своей фирмы.
-- Указать имена продавцов, количество сделанных ими заказов и суммы.  НЕ РАБОТАЕТ

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
-- Прибыль, полученная фирмой. Не учитывать зарплату продавцам, считать прибыль7
-- как разницу между закупочной стоимостью потраченных ингредиентов и продажной. РАБОТАЕТ
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
--количество поставленного ингредиента за 10.2001
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
    EXTRACT(YEAR FROM Поставки.date_of_suply) = 2001
    AND EXTRACT(MONTH FROM Поставки.date_of_suply) = 10;

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
-- 10.1 
SELECT seller_id, full_name, SUM(sum_of_order) AS total_sales
FROM Заказы
JOIN Продавцы ON Заказы.seller = Продавцы.seller_id
GROUP BY seller_id, full_name
ORDER BY total_sales DESC
LIMIT 1;

-- 10.2 
SELECT seller_id, full_name, COUNT(order_id) AS total_orders
FROM Заказы
JOIN Продавцы ON Заказы.seller = Продавцы.seller_id
GROUP BY seller_id, full_name
ORDER BY total_orders DESC
LIMIT 1;

-- 10.3  не работает
SELECT seller_id, full_name, COUNT(penalty_id) AS total_penalties
FROM Штрафы
JOIN Продавцы ON Штрафы.customer = Продавцы.seller_id
GROUP BY seller_id, full_name
ORDER BY total_penalties ASC
LIMIT 1;

-- 6
-- Прибыль, полученная фирмой. Не учитывать зарплату продавцам, считать прибыль7
-- как разницу между закупочной стоимостью потраченных ингредиентов и продажной.