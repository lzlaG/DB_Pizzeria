-- Active: 1713459991667@@127.0.0.1@5432@DB_Pizzeria
COPY Продавцы FROM '/my_data/sellers.csv' DELIMITER ',' CSV HEADER;
COPY Клиенты FROM '/my_data/clients.csv' DELIMITER ',' CSV HEADER;
COPY Поставщики FROM '/my_data/suppliers.csv' DELIMITER ',' CSV HEADER;
COPY Ингридиенты FROM '/my_data/ingridients.csv' DELIMITER ',' CSV HEADER;
COPY Поставки FROM '/my_data/supply.csv' DELIMITER ',' CSV HEADER;
COPY Блюда FROM '/my_data/dishes.csv' DELIMITER ',' CSV HEADER;
COPY Состав_Блюда FROM '/my_data/sostav_of_dish.csv' DELIMITER ',' CSV HEADER;
INSERT INTO Статус_заказа
VALUES
(1, 'выполнен'),
(2, 'не выполнен');
COPY Заказы FROM '/my_data/orders.csv' DELIMITER ',' CSV HEADER;
COPY Состав_заказа FROM '/my_data/sostav_of_order.csv' DELIMITER ',' CSV HEADER;
COPY Штрафы FROM '/my_data/penalty.csv' DELIMITER ',' CSV HEADER;