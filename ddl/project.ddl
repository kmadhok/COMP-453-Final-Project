DROP TABLE IF EXISTS Orderline_t CASCADE ;
DROP TABLE IF EXISTS QA_t CASCADE ;
DROP TABLE IF EXISTS Review_t CASCADE ;
DROP TABLE IF EXISTS Order_t CASCADE ;
DROP TABLE IF EXISTS Product_t CASCADE ;
DROP TABLE IF EXISTS User_t CASCADE ;

CREATE TABLE User_t
         	(User_id 		int(11)		NOT NULL	AUTO_INCREMENT,
			Username		VARCHAR(25)			NOT NULL,
	    	FirstName     	VARCHAR(25)    		NOT NULL,
		    LastName       	VARCHAR(25)    		NOT NULL,
	    	AccountType    	VARCHAR(1) 		    NOT NULL,
            Password      	VARCHAR(60) 		NOT NULL,              
          	Email       	VARCHAR(120) 		NOT NULL,
			Supervisor      int(11)       NULL,
CONSTRAINT User_PK PRIMARY KEY (User_id),
CONSTRAINT User_Supervisor_FK FOREIGN KEY (Supervisor) REFERENCES User_t(User_id));

CREATE TABLE Product_t
         	(Product_id 	int(11)		NOT NULL AUTO_INCREMENT,
		    Price			NUMERIC(5,0)		NOT NULL,
            Description	    VARCHAR(250)		NOT NULL,	       	
CONSTRAINT PRODUCT_t_Product_id_PK PRIMARY KEY (Product_id));

CREATE TABLE Order_t
         	(User_id 		int(11)		NOT NULL,
		    Order_id 		int(11)		NOT NULL AUTO_INCREMENT,
            Order_date		DATE				NOT NULL,	       	
CONSTRAINT ORDER_t_Order_id_PK PRIMARY KEY (Order_id),
CONSTRAINT ORDER_t_User_id_FK FOREIGN KEY (User_id) REFERENCES User_t(User_id));

CREATE TABLE Orderline_t
         	(Order_id 		int(11)		NOT NULL AUTO_INCREMENT,
		    Product_id 	    int(11)		NOT NULL,
            Quantity		NUMERIC(5,0)		NOT NULL,
CONSTRAINT ORDERLINE_t_PK PRIMARY KEY (Order_id, Product_id),	       	
CONSTRAINT ORDERLINE_t_Order_id_FK FOREIGN KEY (Order_id) REFERENCES Order_t(Order_id),
CONSTRAINT ORDERLINE_t_Product_id_FK FOREIGN KEY (Product_id) REFERENCES Product_t(Product_id));

CREATE TABLE QA_t
         	(User_id 		int(11)		NOT NULL,
            Product_id 	    int(11)		NOT NULL,
		    Rating 		    varchar(4)		NULL,	
CONSTRAINT QA_t_PK PRIMARY KEY (User_id, Product_id),       	
CONSTRAINT QA_t_User_id_FK FOREIGN KEY (User_id) REFERENCES User_t(User_id),
CONSTRAINT QA_t_Product_id_FK FOREIGN KEY (Product_id) REFERENCES Product_t(Product_id));

CREATE TABLE Review_t
         	(User_id 		int(11)		NOT NULL,
		    Product_id 	    int(11)		NOT NULL,
            Rating 		    NUMERIC(1,0)		NOT NULL,
	    	Review     	    VARCHAR(250)    	NOT NULL,	      
CONSTRAINT REVIEW_t_PK PRIMARY KEY (User_id, Product_id), 	
CONSTRAINT REVIEW_t_User_id_FK FOREIGN KEY (User_id) REFERENCES User_t(User_id),
CONSTRAINT REVIEW_t_Product_id_FK FOREIGN KEY (Product_id) REFERENCES Product_t(Product_id));
										

delete from User_t;
delete from Product_t;
delete from Order_t;
delete from Orderline_t;
delete from QA_t;
delete from Review_t;

INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(1, 'rLewis', 'Robert', 'Lewis', 'e', '$2b$12$Iw4kCH74YmyA.WwAdGQDTOBcQ3gtfXYHDljTL28MrCXEs9wosjXTS', 'rlewis@gmail.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(2, 'dHenny', 'Doug', 'Henny', 'e', '$2b$12$wWdeWN7lQiirqlM0Sj1Cpe3BHsN7/sEN5C8lbncbCNf4UR.0dExcG', 'dhenny@gmail.com', 1);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(3, 'wStrong', 'William', 'Strong', 'e', '$2b$12$xFAB1bNhKJNOecp/JQYjRuJwUMgCdqOcMVrjt8VV6o5rXskdfdvOS', 'wstrong@gmail.com', 1);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(4, 'jDawson', 'Julie', 'Dawson', 'e', '$2b$12$BInG.bRlz.vSYvVpTYKrTO2INJ.PK6nRJZLKHaFs44moyNOtsvtDK', 'jdawson@gmail.com', 1);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(5, 'jWinslow', 'Jacob', 'Winslow', 'e', '$2b$12$F3vYo6SXjUAnrdlSaL8tS.60xPPzksjE7y69WoWuIJ3WqGqfK.M9C', 'jwinslow@gmail.com', 1);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(6, 'avgconsumer1', 'Oscar', 'Nunez', 'c', '$2b$12$5PozQRmpB/Vfg42fMSfLceQsS7GHPfRpi8dw9vXXyR2X0C6pLRIcS', 'onunez@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(7, 'rHoward', 'Ryan', 'Howard', 'c', '$2b$12$FRrExth50QFloi8EA4hw5.56YTi15jwcVnxvM.zkiWoXMqKXPxaxe', 'rhoward@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(8, 'aMartin', 'Angela', 'Martin', 'c', '$2b$12$Nzl45hco5GYQgEGKYQ/dyeqovH6uA.UeBol0.V0FLobUUz5eyCVH6', 'amartin@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(9, 'mScott', 'Micheal', 'Scott', 'c', '$2b$12$23rYfEjdmfZVDLg/h8P/x.9lkZmdveGwQY1lZRDMfOTznjiWu8Mle', 'mscott@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(10, 'cBratton', 'Creed', 'Bratton', 'c', '$2b$12$t9GZBG90MoZmBxUylSSzaeD3UlGWrblDTtROv3Hvy9nm3uKIB3paK', 'cbratton@dmifflin.com', NULL);

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (1, 30, 'DWCN Blackout Curtains – Thermal Insulated, Energy Saving & Noise Reducing Bedroom and Living Room Curtains, Black, W 42x L 63 Inch, Set of 2 Rod Pocket Curtain Panels');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (2, 11, 'Kenney Beckett 5/8" Standard Decorative Window Curtain Rod, 28-48", Black');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (3, 20, 'Easy-Going Blackout Curtains for Bedroom, Solid Thermal Insulated Grommet and Noise Reduction Window Drapes, Room Darkening Curtains for Living Room, 2 Panels(52x63 in,Gray)');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (4, 33, 'NICETOWN 100% Blackout Curtains with Black Liners, Thermal Insulated Full Blackout 2-Layer Lined Drapes, Energy Efficiency Window Draperies for Bedroom (Grey, 2 Panels, 52-inch W by 63-inch L)');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (5, 17, 'Hiasan Blackout Curtains for Bedroom, 42 x 63 Inches Length - Thermal Insulated & Light Blocking Window Curtains for Living Room/Kids Room, 2 Drape Panels Sewn with Tiebacks, Dark Grey');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (6, 55, 'SHEEROOM 100% Blackout Velvet Curtains for Bedroom and Living Room, 52 x 63 inch Length, Light Grey - Thermal Insulated, Energy Saving, Sun Blocking Grommet Window Drapes, Set of 2 Curtain Panels');


INSERT INTO Order_t  (User_id, Order_id, Order_date)
VALUES  (6, 1, '2021-04-05');

INSERT INTO Order_t  (User_id, Order_id, Order_date)
VALUES  (6, 2, '2021-04-05');

INSERT INTO Order_t  (User_id, Order_id, Order_date)
VALUES  (8, 3, '2021-04-14');

INSERT INTO Order_t  (User_id, Order_id, Order_date)
VALUES  (7, 4, '2021-04-18');


INSERT INTO Orderline_t  (Order_id, Product_id, Quantity)
VALUES  (1, 3, 1);

INSERT INTO Orderline_t  (Order_id, Product_id, Quantity)
VALUES  (2, 1, 4);

INSERT INTO Orderline_t  (Order_id, Product_id, Quantity)
VALUES  (3, 6, 2);

INSERT INTO Orderline_t  (Order_id, Product_id, Quantity)
VALUES  (4, 5, 2);


INSERT INTO QA_t  (User_id, Product_id, Rating)
VALUES  (6, 3, 'pass');

INSERT INTO QA_t  (User_id, Product_id, Rating)
VALUES  (6, 1, 'fail');

INSERT INTO QA_t  (User_id, Product_id, Rating)
VALUES  (8, 6, 'pass');

INSERT INTO QA_t  (User_id, Product_id, Rating)
VALUES  (7, 5, 'pass');


INSERT INTO Review_t  (User_id, Product_id, Rating, Review)
VALUES  (6, 3, 5, 'Very good quality for the price and is 100% blackout.');

INSERT INTO Review_t  (User_id, Product_id, Rating, Review)
VALUES  (6, 1, 4, 'Quality of my curtains is worth what l payed love them can’t wait to hang them up.');

INSERT INTO Review_t  (User_id, Product_id, Rating, Review)
VALUES  (8, 6, 2, "They're good quality although I got the light gray ones and they looked a little greenish not as they pictured them.");

INSERT INTO Review_t  (User_id, Product_id, Rating, Review)
VALUES  (7, 5, 5, "I like the fabric, is very soft and tick. It's 100% blackout. The blush color is very elegant and warm. I love this courtain!");


describe User_t;
describe Product_t;
describe Order_t;
describe Orderline_t;
describe QA_t;
describe Review_t;

select * from User_t;
select * from Product_t;
select * from Order_t;
select * from Orderline_t;
select * from QA_t;
select * from Review_t;

COMMIT;