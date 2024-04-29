from faker import Faker
import csv
from faker.providers import *
import random
from datetime import datetime, timedelta

fake = Faker('ru_RU')

def Clients (id):
    return [id,fake.name(), fake.street_address(),fake.phone_number()]


def Suppliers(id):
    return [id, fake.company()]

def Sellers(id):
    x = random.randint(18000, 100000)
    return [id, fake.name(), x]

def Supply(id):
    start_date = datetime(2024,4,1)
    end_date = datetime(2024,4,30)
    return [id, random.randint(1,15),random.randint(1,15),random.randint(1,10),str(fake.date_between_dates(start_date,end_date))]

def Dishes(id):
    pizza_names = [
        "Классическая Маргарита",
        "Пепперони Парти",
        "Грибная Фантазия",
        "Вегетарианский Деликатес",
        "Мексиканский Фестиваль",
        "Итальянский Фаворит",
        "Гавайская Радуга",
        "Пикантная Четыре Сыра",
        "Пикантная Курочка",
        "Бекон Бум",
        "Морепродуктовая Симфония",
        "Фармерская Пицца",
        "Тосканский Ужин",
        "Экзотический Удивительный",
        "Деревенская Специальность",
        "ультра ананасовая"
    ]
    return [id, pizza_names[id], random.randint(250,1600),random.randint(1500,5000)]

def Ingridients(id):
    ingredients = [
        "тесто для пиццы",
        "томатный соус",
        "сыр моцарелла",
        "пепперони",
        "шампиньоны",
        "помидоры",
        "перец",
        "оливки",
        "ветчина",
        "ананасы",
        "куриное филе",
        "базилик",
        "бекон",
        "сыр чеддер",
        "пармезан",
        "сырный соус"
    ]
    return [id, ingredients[id], random.randint(25,600)]

def Orders(id):
    start_date = datetime(2024,4,1)
    end_date = datetime(2024,4,30)
    return [id, random.randint(1,15), random.randint(1,15),random.randint(1,3),fake.date_between_dates(start_date, end_date), 1]

def Sostav_of_dish(id,k,x):
    return [id,k,x]

def Sostav_of_order(id,k):
    return [id,k]

with open ('./data/clients.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    for i in range (16):
        writer.writerow(Clients(i))

with open('./data/suppliers.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    for i in range (16):
        writer.writerow(Suppliers(i))

with open('./data/sellers.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    for i in range (16):
        writer.writerow(Sellers(i))

with open('./data/orders.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    for i in range(16):
        writer.writerow(Orders(i))

with open('./data/sostav_of_dish.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['id_блюда', 'id_ингридиента', 'количество ингридиентов'])
    for i in range(15):
        x = random.randint(3,5)
        numbers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        uniq_numbers = fake.words(nb=5, ext_word_list=numbers, unique=True)
        if x ==3:
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[0],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[1],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[2],x))
        if x==4:
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[0],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[1],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[2],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[3],x))
        if x==5:
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[0],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[1],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[2],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[3],x))
            writer.writerow(Sostav_of_dish(i+1,uniq_numbers[4],x))



with open('./data/sostav_of_order.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['id_заказа', 'id_блюда'])
    for i in range(15):
        amount_of_dishes = random.randint(1,3)
        numbers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        uniq_numbers = fake.words(nb=3, ext_word_list=numbers, unique=True)
        if amount_of_dishes == 1:
            writer.writerow(Sostav_of_order(i+1, uniq_numbers[0]))
        if amount_of_dishes == 2:
            writer.writerow(Sostav_of_order(i+1,uniq_numbers[0]))
            writer.writerow(Sostav_of_order(i+1,uniq_numbers[1]))
        if amount_of_dishes == 3:
            writer.writerow(Sostav_of_order(i+1,uniq_numbers[0]))
            writer.writerow(Sostav_of_order(i+1,uniq_numbers[1]))
            writer.writerow(Sostav_of_order(i+1,uniq_numbers[2]))

with open ('./data/supply.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    for i in range(16):
        writer.writerow(Supply(i))

with open('./data/ingridients.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    for i in range(16):
        writer.writerow(Ingridients(i))

with open('./data/dishes.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    for i in range(16):
        writer.writerow(Dishes(i))
