CREATE TABLE Клиенты (
    client_id INT PRIMARY KEY NOT NULL,
    full_name VARCHAR(100),
    adres  VARCHAR(100),
    phone_number VARCHAR(10)
);

CREATE TABLE Поставщики (
    supplier_id INT PRIMARY KEY NOT NULL,
    naming VARCHAR(100)
);

CREATE TABLE Продавцы (
    customer_id INT PRIMARY KEY NOT NULL,
    full_name VARCHAR(100),
    salary INT,
    num_of_complited_orders INT,
    num_of_uncomplited_orders INT
);

CREATE TABLE Блюда (
    dishe_id INT PRIMARY KEY NOT NULL,
    naming VARCHAR(50),
    calory INT,
    sostav VARCHAR(100)
);

CREATE TABLE Ингридиенты (
    ingridient_id INT PRIMARY KEY NOT NULL,
    naming VARCHAR(50),
    price INT,
    dishe INT REFERENCES Блюда(dishe_id)
);

CREATE TABLE Поставки (
    supply_id INT PRIMARY KEY NOT NULL,
    supplier INT REFERENCES Поставщики(supplier_id),
    ingridient INT REFERENCES Ингридиенты(ingridient_id)
);

CREATE TABLE Использование_ингридиентов (
    ingridient_usage_id INT PRIMARY KEY NOT NULL,
    ingridient INT REFERENCES Ингридиенты(ingridient_id),
    kolvo INT,
    num_of_week INT
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
    usage INT REFERENCES Использование_ингридиентов (ingridient_usage_id),
    status_of_order INT REFERENCES Статус_заказа(status_id),
    date_of_order date,
    sum_of_order INT
);



