create table customer 
(
    customer_id int4,
    first_name varchar(50),
    last_name varchar(50),
    gender varchar(30),
    dob varchar(50),
    job_title varchar(50),
    job_industry_category varchar(50),
    wealth_segment varchar(50),
    deceased_indicator varchar(50),
    owns_car varchar(30),
    address varchar(50),
    postcode varchar(30),
    state varchar(30),
    country varchar(30),
    property_valuation int4,
    constraint customer_pk primary key (customer_id)
);

create table "transaction"
(
    transaction_id int4,
    product_id int4,
    customer_id int4,
    transaction_date varchar(30),
    online_order varchar(30),
    order_status varchar(30),
    brand varchar(30),
    product_line varchar(30),
    product_class varchar(30),
    product_size varchar(30),
    list_price float4,
    standard_cost float4,
    constraint transaction_pk primary key (transaction_id)
);

-- Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.
-- Количество строк: 6

select
	distinct brand
from
	"transaction" t
where
	standard_cost > 1500;

-- Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.
-- Количество строк: 531

select
	*
from
	"transaction" t
where
	order_status = 'Approved'
	and transaction_date::date between '2017-04-01'::date and '2017-04-09'::date;

-- Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
-- Количество строк: 6

select
	distinct job_title
from
	customer c
where
	job_industry_category in ('IT', 'Financial Services')
	and job_title like 'Senior%';

-- Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
-- Количество строк: 6

select
	distinct brand
from
	"transaction" t
where
	t.customer_id in (
	select
		distinct customer_id
	from
		customer c
	where
		job_industry_category = 'Financial Services')
	and brand is not null;

-- Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
-- Количество строк: 10

select
	*
from
	customer c
where
	customer_id in (
	select
		distinct customer_id
	from
		"transaction" t
	where
		online_order = 'True'
		and brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'))
limit 10;

-- Вывести всех клиентов, у которых нет транзакций.
-- Количество строк: 507

select
	c.*
from
	customer c
left join "transaction" t on
	c.customer_id = t.customer_id
where
	t.transaction_id is null;

-- Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
-- Количество строк: 9

select
	*
from
	customer c
where
	job_industry_category = 'IT'
	and customer_id in (
	select
		customer_id
	from
		"transaction" t1
	where
		standard_cost = (select max(standard_cost) from "transaction" t2));

-- Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
-- Количество строк: 115

select
	*
from
	customer c
where
	job_industry_category in ('IT', 'Health')
	and customer_id in (
	select
		distinct customer_id
	from
		"transaction" t
	where
		order_status = 'Approved'
		and transaction_date::date between '2017-07-07'::date and '2017-07-17'::date);
