# База данных для пиццерии
Для поднятия базы локально:
1) git clone "ссылка на репозиторий"
2) cd DB_Pizzeria
3) создать .env файл в корне репозитория, где будут определены переменные DB_NAME, DB_PORT, DB_PASSWORD,DB_USER
3) docker compose build -p <название_проекта>
4) docker compose up -p <название_проекта>
5) далее, можно подключиться к базе по данным, которые определили в .env(хостом будет localhost)
****

____
