/** 
1) You are required to create tables for supplier,customer,category,product,supplier_pricing,order,rating to store the data for the
E-commerce with the schema definition given below.
2) You are required to develop SQL based programs (Queries) to facilitate the Admin team of the E-Commerce company to retrieve the data in
summarized format - The Data Retrieval needs are described below.
*/

CREATE TABLE IF NOT EXISTS supplier(
SUPP_ID int primary key,
SUPP_NAME varchar(50) NOT NULL,
SUPP_CITY varchar(50) NOT NULL, 
SUPP_PHONE varchar(10) NOT NULL
); 
CREATE TABLE IF NOT EXISTS customer(
CUS_ID int primary key,
CUS_NAME varchar(20) NOT NULL,
CUS_PHONE varchar(10) NOT NULL,
CUS_CITY varchar(30) NOT NULL,
CUS_GENDER CHAR
);
CREATE TABLE IF NOT EXISTS category(
CAT_ID int primary key,
CAT_NAME varchar(20) NOT NULL
);
CREATE TABLE IF NOT EXISTS product(
PROD_ID int primary key,
PRO_NAME varchar(20) NOT NULL DEFAULT "Dummy",
PRO_DESC varchar(60),
CAT_ID INT NOT NULL,
FOREIGN KEY (CAT_ID) REFERENCES CATEGORY (CAT_ID)
);
ALTER TABLE product
RENAME COLUMN PROD_ID to PRO_ID;
CREATE TABLE IF NOT EXISTS supplier_pricing(
PRICING_ID INT primary key,
PRO_ID INT NOT NULL,
SUPP_ID INT NOT NULL,
SUPP_PRICE INT DEFAULT 0,
FOREIGN KEY (PRO_ID) REFERENCES PRODUCT (PRO_ID),
FOREIGN KEY (SUPP_ID) REFERENCES SUPPLIER (SUPP_ID)
);
CREATE TABLE IF NOT EXISTS `order`(
ORD_ID INT NOT NULL,
ORD_AMOUNT INT NOT NULL,
ORD_DATE DATE,
CUS_ID INT NOT NULL,
PRICING_ID INT NOT NULL,
PRIMARY KEY (ORD_ID),
FOREIGN KEY (CUS_ID) REFERENCES CUSTOMER(CUS_ID),
FOREIGN KEY (PRICING_ID) REFERENCES SUPPLIER_PRICING(PRICING_ID)
);
CREATE TABLE IF NOT EXISTS rating(
RAT_ID INT primary key,
ORD_ID INT NOT NULL,
RAT_RATSTARS INT NOT NULL,
FOREIGN KEY (ORD_ID) REFERENCES `order` (ORD_ID)
);







