/** 4. Display the total number of customers based on gender who have placed individual orders of worth at least Rs.3000. */
SELECT CUS_GENDER, COUNT(CUSTOMER.CUS_ID) AS TOTAL_CUSTOMER
FROM CUSTOMER
INNER JOIN `ORDER` ON CUSTOMER.CUS_ID = `ORDER`.CUS_ID
WHERE `ORDER`.ORD_AMOUNT >= 3000
GROUP BY CUS_GENDER;
----------------------------------------------------------------------------------------------------------------------
/** 5. Display all the orders along with product name ordered by a customer having Customer_Id=2 */
SELECT q.CUS_ID, q.CUS_NAME, q.ord_id, product.pro_name FROM 
(  
	SELECT c.CUS_ID, c.CUS_NAME, p.ORD_ID, p.ORD_AMOUNT, p.PRO_ID FROM
    (
		SELECT O.*, sp.PRO_ID FROM `ORDER` AS O
        INNER JOIN SUPPLIER_PRICING AS sp
        WHERE O.PRICING_ID = sp.PRICING_ID
	) as p
    INNER JOIN CUSTOMER as c
    WHERE p.CUS_ID = c.CUS_ID and c.CUS_ID = 2
) as q
INNER JOIN PRODUCT
ON q.PRO_ID = product.PRO_ID;
----------------------------------------------------------------------------------------------------------------------
 /** 6. Display the Supplier details who can supply more than one product. */
 SELECT SUP.* from SUPPLIER AS SUP WHERE SUP.SUPP_ID IN
(
 SELECT SP.SUPP_ID FROM SUPPLIER_PRICING AS SP GROUP BY SP.SUPP_ID HAVING COUNT(SP.SUPP_ID) > 1
);
----------------------------------------------------------------------------------------------------------------------
/** 7. Find the least expensive product from each category and print the table with category id, name, product name and price of the product
*/
SELECT c.CAT_ID, c.CAT_NAME, min(t3.Min_Price) as Min_Price FROM CATEGORY as c
INNER JOIN
(
	SELECT p.CAT_ID, p.PRO_NAME, t2.* FROM PRODUCT as p
	INNER JOIN 
	(
		SELECT PRO_ID, MIN(SUPP_PRICE) as Min_Price FROM SUPPLIER_PRICING GROUP BY PRO_ID
	) AS t2 on t2.PRO_ID = p.PRO_ID
) AS t3 on t3.CAT_ID = c.CAT_ID GROUP BY t3.CAT_ID;

----------------------------------------------------------------------------------------------------------------------
/** 8. Display the Id and Name of the Product ordered after “2021-10-05”.  */

SELECT p.PRO_ID, p.PRO_NAME FROM 
(
	SELECT O.*, SP.PRO_ID FROM `ORDER` as O 
	INNER JOIN 
	SUPPLIER_PRICING AS SP ON SP.PRICING_ID = O.PRICING_ID
    AND O.ORD_DATE>"2021-10-05"
) as q
INNER JOIN
PRODUCT as p ON q.PRO_ID = p.PRO_ID;
---------------------------------------------------------------------------------------------------------------------
/** 9. Display customer name and gender whose names start or end with character 'A' */
SELECT CUS_NAME, CUS_GENDER FROm CUSTOMER AS C WHERE C.CUS_NAME like 'A%' OR C.CUS_NAME like '%A';
----------------------------------------------------------------------------------------------------------------------
/** 10.  Create a stored procedure to display supplier id, name, Rating(Average rating of all the products sold by every customer) and
Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average
Service” else print “Poor Service”. Note that there should be one rating per supplier. */
DELIMITER $$
USE `a_ecommerce` $$
CREATE PROCEDURE `supplier_ratings`()
BEGIN
	SELECT report.SUPP_ID, report.AVERAGE,  
CASE 
	WHEN report.Average = 5 THEN 'Excellent Service'
	WHEN report.Average > 4 THEN 'Good Service' 
	WHEN report.Average > 2 THEN 'Average Service' 
	ELSE 'Poor Service'
END AS Type_of_Service FROM
(
	SELECT T2.SUPP_ID, AVG(RAT_RATSTARS) AS AVERAGE FROM 
	(
		SELECT SP.SUPP_ID, T1.ORD_ID, T1.RAT_RATSTARS FROM SUPPLIER_PRICING AS SP
		INNER JOIN
		(
			SELECT O.PRICING_ID, RAT.ORD_ID, RAT.RAT_RATSTARS FROM `ORDER` AS O
			INNER JOIN
			RATING AS RAT
			ON O.ORD_ID = RAT.ORD_ID
		) AS T1 ON SP.PRICING_ID = T1.PRICING_ID
	) AS T2 GROUP BY T2.SUPP_ID
) as report; 
END$$
 call supplier_ratings();
 ---------------------------------------------------------------------------------------------------------------------

