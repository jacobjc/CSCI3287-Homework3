use classicmodels;

-- 1
select* from offices order by city; 

-- 2
select employeeNumber, lastName, firstName, extension from employees where officeCode=4; 

-- 3
select productCode, productName, productVendor, quantityInStock, productLine from products where quantityInStock>100 and quantityInStock<1000; 

-- 4
select productCode, productName, productVendor, buyPrice, MSRP from products
	where MSRP=(select min(MSRP) from products); 

-- 5
select (MSRP-buyPrice) as 'profit', productName from products
	where (MSRP-buyPrice)=(select max(MSRP-buyPrice) from products); 
    
-- 6
select test.Customers, test.country from
	(select (count(customerNumber)) as 'Customers', country from customers group by country order by (count(customerNumber))desc)test
    where test.Customers>10; 

-- 7
select Prod.productcode, Prod.productName, Ords.OrderCount from products Prod, 
	(select productcode, count(productCode) as OrderCount from orderdetails group by productCode) Ords 
	order by Ords.OrderCount desc limit 1; 
    
-- 8
select employeeNumber, concat(firstName,' ',lastName) as 'name' from employees  where reportsTo=1002 or reportsTo=1088; 

-- 9
select * from employees where jobTitle = 'President'; 

-- 10
select productName, productLine from products where productLine='Classic Cars' and left(productName, 3)='197';

-- 11
select date_format(orderDate, '%M') as Month, 
	count(date_format(orderDate, '%M')) as Count from orders 
	group by Month 
	order by Count desc; 
    
-- 12
select firstName, lastName from employees where jobTitle='Sales Rep' and employeeNumber not in
	(select distinct salesRepEmployeeNumber as empWithCus from customers where salesRepEmployeeNumber is not null);
    
-- 13
select customerName from customers where country = 'Germany' 
and customerNumber not in (select customerNumber from orders); 

-- 14
select Cus.CustomerName, sum(Det.QuantityOrdered) as totalQuantity from customers Cus
	join orders Ord join orderDetails Det on Cus.CustomerNumber=Ord.CustomerNumber and Ord.OrderNumber = Det.OrderNumber
	group by Cus.CustomerName having totalQuantity > 1700;
    
-- 15
create table TopCustomers(
	CustomerNumber int not null,
    ContactDate date not null,
    OrderTotal decimal(9,2) not null,
    constraint TopCustomer_PK primary key (CustomerNumber));

-- 16
insert into TopCustomers 
    select customerNumber, curdate(), totalValue from (
        select O.customerNumber as customerNUmber, sum(D.orderTotal) as totalValue 
        from orders O, 
        (select sum(priceEach * quantityOrdered) as orderTotal, orderNumber from orderdetails group by orderNumber) D 
        where O.orderNumber = D.orderNumber group by customerNumber
    ) T where totalValue > 140000;

-- 17
select * from TopCustomers order by orderTotal desc;

-- 18
alter table TopCustomers 
    add column orderCount int;

-- 19
update TopCustomers 
    set orderCount = Floor(Rand()* 18);

-- 20
select * from TopCustomers order by orderCount desc;

-- 21
drop table TopCustomers;