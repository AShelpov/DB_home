USE lesson_5;

SHOW TABLES;
SELECT * FROM products p ;

-- ѕусть в таблице users пол€ created_at и updated_at оказались незаполненными. «аполните их текущими датой и временем.
UPDATE users SET created_at = NOW(), updated_at = NOW();

-- “аблица users была неудачно спроектирована. 
-- «аписи created_at и updated_at были заданы типом VARCHAR и в них долгое врем€ помещались значени€ в формате 
-- "20.10.2017 8:10". Ќеобходимо преобразовать пол€ к типу DATETIME, сохранив введеные ранее значени€.
ALTER TABLE users MODIFY COLUMN created_at DATETIME;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME;


-- ¬ таблице складских запасов storehouses_products в поле value могут встречатьс€ самые разные цифры: 
-- 0, если товар закончилс€ и выше нул€, если на складе имеютс€ запасы. Ќеобходимо отсортировать записи таким образом, 
-- чтобы они выводились в пор€дке увеличени€ значени€ value. ќднако, нулевые запасы должны выводитьс€ в конце, 
-- после всех записей.
SELECT * FROM storehouses_products ORDER BY value = 0, value;
