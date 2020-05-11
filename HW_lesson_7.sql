USE lesson_7;
SHOW TABLES;
SELECT * FROM users u ;
SELECT * FROM products p ;
SELECT * FROM catalogs c ;
DESC products ;
INSERT INTO products (name, desription, price, catalog_id, created_at, updated_at) VALUES("ASUS RX-10000", "ASUS Motherboard", 10000, 2, DATE("23.05.2019"), CURRENT_TIMESTAMP());
INSERT INTO products (name, desription, price, catalog_id, created_at, updated_at) VALUES("Intel ix3", "Intel CPU", 100000, 1, DATE("25.03.2020"), CURRENT_TIMESTAMP());
INSERT INTO products (name, desription, price, catalog_id, created_at, updated_at) VALUES("Nvidia GeeForce3000x", "NVidea GPU", 150000, 3, DATE("14.02.2020"), CURRENT_TIMESTAMP());
INSERT INTO products (name, desription, price, catalog_id, created_at, updated_at) VALUES("Toshiba TS-1000", "Toshiba SSD", 5000, 4, DATE("04.03.2019"), CURRENT_TIMESTAMP());
INSERT INTO products (name, desription, price, catalog_id, created_at, updated_at) VALUES("Intel HDD 1024", "Intel HDD", 50000, 5, DATE("16.10.2019"), CURRENT_TIMESTAMP());



CREATE TABLE orders(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  good_id INT UNSIGNED NOT NULL,
  price_of_good decimal(11,2),
  quantity INT UNSIGNED NOT NULL,
  total_price decimal(11,2),
  created_at DATETIME NOT NULL,
  delivered_at DATETIME NOT NULL);

SELECT * FROM orders ;
INSERT INTO orders (user_id, good_id, quantity, created_at, delivered_at) VALUES(1, 1, 3, DATE("01.03.2020"), DATE("04.03.2020"));
INSERT INTO orders (user_id, good_id, quantity, created_at, delivered_at) VALUES(1, 2, 1, DATE("01.03.2020"), DATE("04.03.2020"));
INSERT INTO orders (user_id, good_id, quantity, created_at, delivered_at) VALUES(1, 4, 3, DATE("01.03.2020"), DATE("04.03.2020"));
INSERT INTO orders (user_id, good_id, quantity, created_at, delivered_at) VALUES(2, 2, 1, DATE("01.03.2020"), DATE("04.03.2020"));
INSERT INTO orders (user_id, good_id, quantity, created_at, delivered_at) VALUES(3, 5, 1, DATE("04.03.2020"), DATE("06.03.2020"));
INSERT INTO orders (user_id, good_id, quantity, created_at, delivered_at) VALUES(4, 3, 2, DATE("07.03.2020"), DATE("09.03.2020"));
UPDATE orders o SET price_of_good = (SELECT p.price FROM products p WHERE p.id = o.good_id);
UPDATE orders o SET o.total_price = o.price_of_good * o.quantity;


-- Make a list of users who have completed at least one order in the online store.
SELECT u.id, u.name, o.total_price AS sum_of_all_orders
 FROM users u 
  JOIN (SELECT user_id, SUM(total_price) as total_price FROM orders GROUP BY user_id) o 
   ON u.id = o.user_id;
   
-- List the products products and catalogs sections that correspond to the product.
SELECT p.id, p.name, p.price, c.name, p.created_at, p.updated_at
 FROM products p 
  JOIN catalogs c
   ON p.catalog_id = c.id;
   
-- (optional) Suppose you have a flights table (id, from, to) and a cities table cities (label, name). 
-- The from, to and label fields contain English city names, the name field is Russian. 
-- Display a list of flights with Russian city names.

DROP TABLE IF EXISTS fligths;
CREATE TABLE fligths(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  from_city VARCHAR(100),
  to_city VARCHAR(100)
);

INSERT INTO fligths (from_city, to_city) VALUES("moscow", "omsk");
INSERT INTO fligths (from_city, to_city) VALUES("novgorod", "kazan");
INSERT INTO fligths (from_city, to_city) VALUES("irkutsk", "moscow");
INSERT INTO fligths (from_city, to_city) VALUES("omsk", "irkutsk");
INSERT INTO fligths (from_city, to_city) VALUES("moscow", "kazan");
SELECT * FROM fligths ;


DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  label VARCHAR(100),
  name VARCHAR(100)
);

INSERT INTO cities (label, name) VALUES("moscow", "Москва");
INSERT INTO cities (label, name) VALUES("irkutsk", "Иркутск");
INSERT INTO cities (label, name) VALUES("novgorod", "Новгород");
INSERT INTO cities (label, name) VALUES("kazan", "Казань");
INSERT INTO cities (label, name) VALUES("omsk", "Омск");
SELECT * FROM cities ;

-- query
SELECT departure.id, departure.name, arrival.name
 FROM
  (SELECT f.id, c.name
    FROM fligths f 
     JOIN cities c 
      ON f.from_city = c.label) AS departure
 JOIN
  (SELECT f.id, c.name
    FROM fligths f
     JOIN cities c 
      ON f.to_city = c.label) AS arrival
 ON departure.id = arrival.id
  ORDER BY id;