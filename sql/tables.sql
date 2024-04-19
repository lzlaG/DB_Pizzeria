CREATE TABLE Клиенты (
    client_id INT PRIMARY KEY NOT NULL,
    full_name VARCHAR(100),
    adress  VARCHAR(100),
    phone_number VARCHAR(10)
);
CREATE TABLE Поставщики (
    supplier_id INT PRIMARY KEY NOT NULL,
    naming VARCHAR(100)
);

CREATE TABLE Продавцы (
    customer_id INT PRIMARY KEY NOT NULL,
    full_name VARCHAR(100),
    salary INT
    -- мб num_of_complited_orders INT,--
    -- мб num_of_uncomplited_orders INT--
);

CREATE TABLE Блюда (
    dishe_id INT PRIMARY KEY NOT NULL,
    naming VARCHAR(50),
    calory INT
);

CREATE TABLE Ингридиенты (
    ingridient_id INT PRIMARY KEY NOT NULL,
    naming VARCHAR(50),
    price INT
);

CREATE TABLE Состав_Блюда(
    dishe_id INT REFERENCES Блюда(dishe_id),
    ingridient_id INT REFERENCES Ингридиенты(ingridient_id)
);

CREATE TABLE Поставки (
    supply_id INT PRIMARY KEY NOT NULL,
    supplier INT REFERENCES Поставщики(supplier_id),
    ingridient INT REFERENCES Ингридиенты(ingridient_id),
    amount_of_ingridients INT,
    date_of_suply DATE
);

CREATE TABLE Штрафы (
    penalty_id INT PRIMARY KEY NOT NULL,
    customer INT REFERENCES Продавцы(customer_id),
    sum_of_penalty INT
);

CREATE TABLE Статус_заказа(
    status_id INT PRIMARY KEY NOT NULL,
    status_of_order VARCHAR(50)
);

CREATE TABLE Заказы(
    order_id INT PRIMARY KEY NOT NULL,
    client INT REFERENCES Клиенты(client_id),
    customer INT REFERENCES Продавцы (customer_id),
    status_of_order INT REFERENCES Статус_заказа(status_id),
    date_of_order date,
    sum_of_order INT
);

CREATE TABLE Состав_заказа(
    order_id INT REFERENCES Заказы(order_id),
    dishe_id INT REFERENCES Блюда(dishe_id)
);



