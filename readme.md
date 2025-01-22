# Создание docker-compose под laravel + PostgreSQL + adminer + Правки

## Добавить исходный код приложения в репозиторий

* Миграция внутри контейнера

![Миграция внутри контейнера](help/migrate.png)

## nginx + php должны работать в одном контейнере

## После запуска контейнеров приложение должно быть полностью работоспособным

* Адрес `http://localhost:8080/` отвечает
  ![Сайт Laravel](help/site.png)
* `composer require laravel/ui` работает
  ![laravel/ui](help/laravel_ui.png)
* `docker exec -it laravel-app php artisan test`
  ![artisan test](help/test.png)
