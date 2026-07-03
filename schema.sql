
CREATE TABLE public.products (
  product_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  product_name character varying NOT NULL,
  category character varying,
  unit_price numeric,
  cost numeric,
  CONSTRAINT products_pkey PRIMARY KEY (product_id)
);
CREATE TABLE public.orders (
  order_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  customer_id integer NOT NULL,
  order_date date,
  status character varying,
  CONSTRAINT orders_pkey PRIMARY KEY (order_id),
  CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id)
);
CREATE TABLE public.order_items (
  order_item_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  order_id bigint NOT NULL,
  product_id bigint,
  quantity numeric,
  unit_price_at_sale numeric,
  CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id),
  CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id),
  CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id)
);
CREATE TABLE public.customers (
  customer_id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  first_name character varying NOT NULL,
  last_name character varying,
  state character varying,
  city character varying,
  email character varying,
  signup_date date,
  CONSTRAINT customers_pkey PRIMARY KEY (customer_id)
);
CREATE TABLE public.employees (
  employee_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  name character varying NOT NULL,
  region character varying,
  CONSTRAINT employees_pkey PRIMARY KEY (employee_id)
);