DROP TABLE IF EXISTS Orderline_t CASCADE ;
DROP TABLE IF EXISTS QA_t CASCADE ;
DROP TABLE IF EXISTS Review_t CASCADE ;
DROP TABLE IF EXISTS Order_t CASCADE ;
DROP TABLE IF EXISTS Product_t CASCADE ;
DROP TABLE IF EXISTS Employee_t CASCADE ;
DROP TABLE IF EXISTS Customer_t CASCADE;
DROP TABLE IF EXISTS User_t CASCADE ;

CREATE TABLE User_t
         	(User_id 		NUMERIC(11,0)		NOT NULL,
	    	FirstName     	VARCHAR(25)    		NOT NULL,
		    LastName       	VARCHAR(25)    		NOT NULL,
	    	UserType    	VARCHAR(25) 		NOT NULL,
            Password      	VARCHAR(20) 		NOT NULL,              
          	Email       	VARCHAR(30) 		NOT NULL,
CONSTRAINT User_PK PRIMARY KEY (User_id));

CREATE TABLE Customer_t
         	(User_id 		NUMERIC(11,0)		NOT NULL,    	
CONSTRAINT CUSTOMER_t_User_id_FK FOREIGN KEY (User_id) REFERENCES User_t(User_id));

CREATE TABLE Employee_t
         	(User_id 		NUMERIC(11,0)		NOT NULL,
		    Supervisor		NUMERIC(11,0)		NOT NULL,
CONSTRAINT EMPLOYEE_t_User_id_FK FOREIGN KEY (User_id) REFERENCES User_t(User_id),
CONSTRAINT EMPLOYEE_t_Supervisor_FK FOREIGN KEY (Supervisor) REFERENCES User_t(User_id));

CREATE TABLE Product_t
         	(Product_id 	NUMERIC(11,0)		NOT NULL,
		    Price			NUMERIC(5,0)		NOT NULL,
            Description	    VARCHAR(250)		NOT NULL,	       	
CONSTRAINT PRODUCT_t_Product_id_PK PRIMARY KEY (Product_id));

CREATE TABLE Order_t
         	(User_id 		NUMERIC(11,0)		NOT NULL,
		    Order_id 		NUMERIC(11,0)		NOT NULL,
            Order_date		DATE				NOT NULL,	       	
CONSTRAINT ORDER_t_Order_id_PK PRIMARY KEY (Order_id),
CONSTRAINT ORDER_t_User_id_FK FOREIGN KEY (User_id) REFERENCES User_t(User_id));

CREATE TABLE Orderline_t
         	(Order_id 		NUMERIC(11,0)		NOT NULL,
		    Product_id 	    NUMERIC(11,0)		NOT NULL,
            Quantity		NUMERIC(5,0)		NOT NULL,	       	
CONSTRAINT ORDERLINE_t_Order_id_FK FOREIGN KEY (Order_id) REFERENCES Order_t(Order_id),
CONSTRAINT ORDERLINE_t_Product_id_FK FOREIGN KEY (Product_id) REFERENCES Product_t(Product_id));

CREATE TABLE QA_t
         	(User_id 		NUMERIC(11,0)		NOT NULL,
            Product_id 	    NUMERIC(11,0)		NOT NULL,
		    Rating 		    NUMERIC(1,0)		NOT NULL,	       	
CONSTRAINT QA_t_User_id_FK FOREIGN KEY (User_id) REFERENCES User_t(User_id),
CONSTRAINT QA_t_Product_id_FK FOREIGN KEY (Product_id) REFERENCES Product_t(Product_id));

CREATE TABLE Review_t
         	(User_id 		NUMERIC(11,0)		NOT NULL,
		    Product_id 	    NUMERIC(11,0)		NOT NULL,
            Rating 		    NUMERIC(1,0)		NOT NULL,
	    	Review     	    VARCHAR(250)    	NOT NULL,	       	
CONSTRAINT REVIEW_t_User_id_FK FOREIGN KEY (User_id) REFERENCES User_t(User_id),
CONSTRAINT REVIEW_t_Product_id_FK FOREIGN KEY (Product_id) REFERENCES Product_t(Product_id));