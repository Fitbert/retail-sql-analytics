# Retail SQL Analytics

A SQL analytics project simulating an e-commerce database with 
customers, orders, products, order items, and employees.

## Schema
[brief description or link to schema.sql, maybe an ER diagram image]

![image of schema](image.png)

## Key Queries
- Top customers by spend
- Revenue by category over time
- Product ranking within category (window functions)
- Customer segmentation (CTE)
- Products frequently bought together (self-join)

## What I learned / debugged
Imported 1000 rows via CSV into Supabase (PostgreSQL). Found that 
null values in the source data were breaking joins between 
order_items and products — traced it to [whatever you found], 
fixed by [what you did].

## Tools
PostgreSQL (via Supabase), SQL