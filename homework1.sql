/* 1. Создайте таблицу с мобильными телефонами, используя графический интерфейс. Необходимые поля таблицы:
product_name (название товара), manufacturer (производитель), product_count (количество), price (цена).
Заполните БД произвольными данными. */
CREATE TABLE `geekbrains`.`lesson1`
(
    `phone_number`  VARCHAR(14)  NOT NULL,
    `product_name`  VARCHAR(255) NOT NULL,
    `manufacturer`  VARCHAR(255) NOT NULL,
    `product_count` MEDIUMINT UNSIGNED NOT NULL,
    `price`         BIGINT UNSIGNED NOT NULL,
    `moment`        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

INSERT INTO `lesson1` (`phone_number`, `product_name`, `manufacturer`, `product_count`, `price`)
VALUES ('+79990000000', 'Смартфон Xiaomi Redmi Note 10 Pro', 'Xiaomi', 2, 2250000),
       ('+79990000000', 'iPhone 10', 'Apple', 1, 2000000),
       ('+79990000000', 'Яблоки', 'ООО \"Ромашка\"', 10, 10000),
       ('+79990000000', 'Стиральная машина', 'Samsung', 10, 5000000),
       ('+79990000000', 'Стиральная машина 88', 'Samsung', 1, 5000000);
use `geekbrains`;
/* 2. Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, количество которых превышает 2 */
SELECT `product_name`, `manufacturer`, `price` FROM `lesson1` WHERE `product_count` > 2;

/* 3. Выведите SELECT-запросом весь ассортимент товаров марки “Samsung” */
SELECT * FROM `lesson1` WHERE `manufacturer` = 'Samsung';

/* 4.* С помощью SELECT-запроса с оператором LIKE / REGEXP найти: */

-- 4.1.* Товары, в которых есть упоминание "Iphone"
SELECT * FROM `lesson1` WHERE `product_name` LIKE '%Iphone%';

-- 4.2.* Товары, в которых есть упоминание "Samsung"
SELECT * FROM `lesson1` WHERE `product_name` LIKE '%Samsung%';

-- 4.3.* Товары, в названии которых есть ЦИФРЫ
SELECT * FROM `lesson1` WHERE `product_name` REGEXP '[0-9]+';

-- 4.4.* Товары, в названии которых есть ЦИФРА "8"
SELECT * FROM `lesson1` WHERE `product_name` LIKE '%8%';
