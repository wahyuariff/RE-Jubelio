create Table promo_code(
	promo_id int primary key,
	promo_name varchar,
	price_deduction int,
	description varchar,
	duration int
);

create table q3_q4_review(
	sales_id int,
	purchase_date date,
	item_name varchar,
	quantity int,
	total_price int,
	promo_code varchar,
	sales_after_promo int
);

INSERT INTO q3_q4_review (sales_id, purchase_date, item_name, quantity, total_price, promo_code, sales_after_promo)
SELECT
    s.sales_id,
    s.purchase_date,
    m.item_name,
    s.quantity,
    (s.quantity * m.price) AS total_price,
    COALESCE(p.promo_name, 'TANPA_PROMO') AS promo_code,
    (s.quantity * m.price - COALESCE(p.price_deduction, 0)) AS sales_after_promo
FROM sales_table s
JOIN marketplace_table m 
    ON s.item_id = m.item_id
LEFT JOIN promo_code p 
    ON s.promo_id = p.promo_id
WHERE s.purchase_date BETWEEN '2022-07-01' AND '2022-12-31'
ORDER BY purchase_date ASC;


create table shipping_summary(
	shipping_date date, 
	seller_name varchar, 
	buyer_name varchar,
	buyer_address varchar, 
	buyer_city varchar, 
	buyer_zipcode int,
	kode_resi varchar
);

INSERT INTO shipping_summary(
shipping_date, seller_name, buyer_name, buyer_address, buyer_city, buyer_zipcode, kode_resi
)
SELECT
  sh.shipping_date,
  se.seller_name,
  b.buyer_name,
  b.address AS buyer_address,
  b.city AS buyer_city,
  b.zipcode AS buyer_zipcode,
  CONCAT(
    sh.shipping_id, '-', 
    TO_CHAR(sh.purchase_date, 'YYYYMMDD'), '-', 
    TO_CHAR(sh.shipping_date, 'YYYYMMDD'), '-', 
    sh.buyer_id, '-', 
    sh.seller_id) AS kode_resi
FROM shipping_table sh
LEFT JOIN seller_table se ON sh.seller_id = se.seller_id
LEFT JOIN buyer_table  b  ON sh.buyer_id  = b.buyer_id
WHERE sh.shipping_date BETWEEN '2022-12-01' AND '2022-12-31'
ORDER BY shipping_date ASC;





