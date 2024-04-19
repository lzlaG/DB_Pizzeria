--1. Количество клиентов, которых обслужили за месяц--
SELECT COUNT(DISTINCT client_id) AS num_of_clients
FROM Заказы
WHERE EXTRACT(MONTH FROM date_of_order) = 4;

--Сколько каждый из клиентов сделал заказов, вывести все личные данные клиента,--
--количество заказов и сумму заказов. Вывести в алфавитном порядке:--
SELECT 
    Клиенты.full_name,
    Клиенты.adress,
    Клиенты.phone_number,
    COUNT(Заказы.order_id) AS num_of_orders,
    SUM(Заказы.sum_of_order) AS total_order_sum
FROM 
    Заказы
JOIN 
    Клиенты ON Заказы.client = Клиенты.client_id
GROUP BY 
    Клиенты.full_name, Клиенты.adress, Клиенты.phone_number
ORDER BY 
    Клиенты.full_name ASC;
--3. Вычислить зарплату всех продавцов. В итоговой ведомости указать Имя, Отчество,--
-- Фамилию продавца, количество выполненных и невыполненных им заказов, --
-- оплату за выполненные заказы и штрафы за невыполненные, итоговую причитающуюся сумму продавцу: --

SELECT 
    full_name,
    COUNT(CASE WHEN status_of_order = 'Выполнен' THEN order_id END) AS num_of_complited_orders,
    COUNT(CASE WHEN status_of_order = 'Невыполнен' THEN order_id END) AS num_of_uncomplited_orders,
    salary * COUNT(CASE WHEN status_of_order = 'Выполнен' THEN order_id END) AS total_income,
    COALESCE(SUM(Штрафы.sum_of_penalty), 0) AS total_penalty,
    salary * COUNT(CASE WHEN status_of_order = 'Выполнен' THEN order_id END) - COALESCE(SUM(Штрафы.sum_of_penalty), 0) AS total_salary
FROM 
    Продавцы
LEFT JOIN 
    Заказы ON Продавцы.customer_id = Заказы.customer
LEFT JOIN 
    Штрафы ON Продавцы.customer_id = Штрафы.customer
GROUP BY 
    full_name, salary;

--4. Сколько денег потратили сами продавцы на продукцию своей фирмы.-- 
--Указать имена продавцов, количество сделанных ими заказов и суммы--

SELECT 
    Продавцы.full_name,
    COUNT(Заказы.order_id) AS num_of_orders,
    SUM(Заказы.sum_of_order) AS total_spent
FROM 
    Заказы
JOIN 
    Продавцы ON Заказы.customer = Продавцы.customer_id
GROUP BY 
    Продавцы.full_name;

--5. Список проданных блюд (рецептов), отсортированных в порядке убывания количества продаж--
SELECT 
    Блюда.naming AS dish_name,
    COUNT(Состав_заказа.order_id) AS num_of_sales
FROM 
    Состав_заказа
JOIN 
    Блюда ON Состав_заказа.dishe_id = Блюда.dishe_id
GROUP BY 
    Блюда.naming
ORDER BY 
    num_of_sales DESC;

-- 6. Прибыль, полученная фирмой. Не учитывать зарплату продавцам,-- 
--считать прибыль как разницу между закупочной стоимостью потраченных ингредиентов и продажной--
SELECT 
    SUM(Заказы.sum_of_order) - SUM(Ингридиенты.price * Состав_Блюда.amount_of_ingridients) AS profit
FROM 
    Заказы
JOIN 
    Состав_заказа ON Заказы.order_id = Состав_заказа.order_id
JOIN 
    Состав_Блюда ON Состав_заказа.dishe_id = Состав_Блюда.dishe_id
JOIN 
    Ингридиенты ON Состав_Блюда.ingridient_id = Ингридиенты.ingridient_id;

--7 Меню, указывается наименование блюда, перечисляются все его ингредиенты, указывается калорийность и состав--
SELECT 
    Блюда.naming AS dish_name,
    Блюда.calory
    --GROUP_CONCAT (Ингридиенты.naming SEPARATOR) AS ingredients--
FROM 
    Блюда
JOIN 
    Состав_Блюда ON Блюда.dishe_id = Состав_Блюда.dishe_id
JOIN 
    Ингридиенты ON Состав_Блюда.ingridient_id = Ингридиенты.ingridient_id
GROUP BY 
    Блюда.naming, Блюда.calory;

--8. Отчет по поставкам. Указать поставщика, наименование ингредиента,-- 
--количество поставленного ингредиента за 10.2001--

SELECT 
    Поставщики.naming AS supplier_name,
    Ингридиенты.naming AS ingredient_name,
    SUM(Поставки.amount_of_ingridients) AS total_supply
FROM 
    Поставки
JOIN 
    Поставщики ON Поставки.supplier = Поставщики.supplier_id
JOIN 
    Ингридиенты ON Поставки.ingridient = Ингридиенты.ingridient_id
WHERE 
    EXTRACT(MONTH FROM Поставки.date_of_suply) = 10 AND EXTRACT(YEAR FROM Поставки.date_of_suply) = 2001
GROUP BY 
    Поставщики.naming, Ингридиенты.naming;

--9. Список использованных ингредиентов и их количества,--
--по каждой неделе. Указать номер недели, наименование ингредиента, количество--    

SELECT 
    EXTRACT(WEEK FROM Поставки.date_of_suply) AS week_number,
    Ингридиенты.naming AS ingredient_name,
    SUM(Поставки.amount_of_ingridients) AS total_amount
FROM 
    Поставки
JOIN 
    Ингридиенты ON Поставки.ingridient = Ингридиенты.ingridient_id
GROUP BY 
    EXTRACT(WEEK FROM Поставки.date_of_suply), Ингридиенты.naming;

--10. Показать лучшего продавца:--
