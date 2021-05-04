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
			Review_date		DATE				NOT NULL,
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
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(11, 'jJohn', 'James', 'John', 'c', '$asdfas2b$12$t9GZBG90MoZmBxUylSSzaeD3UlGWrblDTtROv3Hvy9nm3uKIB3paK', 'jJohn@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(12, 'tRon', 'Tabitha', 'Ron', 'c', '$asdfas2b$12$t9GZBG90MoZmBxUy', 'tRon@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(13, 'kJohn', 'Kirby', 'John', 'c', '$aasdfdsasdfas2b$12$t9GZBG90MoZmBxUy', 'kJohn@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(14, 'cKelly', 'Chris', 'Kelly', 'c', '$aaasdf#@$2$t9GZBG90MoZmBxUy', 'cKelly@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(15, 'rKelly', 'Rick', 'Kelly', 'c', '$aa$$$$$$$asdf#@$2$t9GZBG90MoZmBxUy', 'rKelly@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(16, 'lKelly', 'Larry', 'Kelly', 'c', '$aa$$&&&$asdf#@$2$t9GZBG90MoZmBxUy', 'lKelly@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(17, 'mMack', 'Mason', 'Mack', 'c', '$$$aaaaa$$asdf#@$2$t9GZBG90MoZmBxUy', 'mMack@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(18, 'tRack', 'Tyrone', 'Rack', 'c', '$abababa$$$$$$$asdf#@$2$t9GZBG90MoZmBxUy', 'tRack@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(19, 'bBilly', 'Bob', 'Billy', 'c', '$aa$$$$000#@$2$t9GZBG90MoZmBxUy', 'bBilly@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(20, 'bRack', 'Brandon', 'Rack', 'c', 'pppppp#@$2$t9GZBG90MoZmBxUy', 'bRack@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(21, 'pPod', 'Perry', 'Pod', 'c', '$$$$tttttasdf#@$2$t9GZBG90MoZmBxUy', 'pPod@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(22, 'hHone', 'Heather', 'Hone', 'c', '$ppp$$f#@$2$t9GZBG90MoZmBxUy', 'hHone@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(23, 'lRay', 'Lana', 'Ray', 'c', '$abab###df#@$2$t9GZBG90MoZmBxUy', 'lRay@dmifflin.com', NULL);
INSERT INTO User_t (User_id, Username, FirstName, LastName, AccountType, `Password`, Email, Supervisor) VALUES(24, 'aMarge', 'Ashley', 'marge', 'c', '$aa$$$999$2$t9GZBG90MoZmBxUy', 'aMarge@dmifflin.com', NULL);


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

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (7, 129, 'DEWALT 20V MAX Cordless Drill / Driver Kit, Compact, 1/2-Inch (DCD771C2)');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (8, 67, 'Hammerhead 20V 2-Speed Cordless Drill Driver Kit with 1.5Ah Battery and Charger - HCDD201 ');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (9, 74, 'BLACK+DECKER 20V MAX Cordless Drill / Driver with 30-Piece Accessories (LD120VA) ');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (10, 119, 'SALEM MASTER Cordless Drill Driver - 21V Max Impact Drill with 3/8'' Auto Chuck 23+1 Clutch 2-Speed Lithium-Ion Battery Built-in LED Compact Drill for Home Improvement & DIY Project (Yellow) ');

INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (11, 129, 'BLACK+DECKER 20V MAX Drill & Drill Bit Set, 100 Piece (BDC120VA100) ');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (12, 72, 'Basics Folding Step Ladder - 4-Step, Aluminum with Wide Pedal, Silver and Black ');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (13, 100, 'charaHOME 4 Step Ladder Step Stool 500 lb Capacity Folding Portable Ladder Steel Frame with Safety Side Handrails Non-Slip Wide Pedal Kitchen and Home Stepladder with Attachable Tool Bag ');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (14, 190, 'Hailo 0850-627 L100 Pro, 6-Ft Folding Lightweight Aluminum Step Platform Ladder, Black');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (15, 180, 'COSCO 2061AABLKE Signature Series Step Ladder, 6ft, Steel ');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (16, 10, 'Curtain Holdback, 2pcs Wall Mounted Drapery Tiebacks with Screws, Heavy Duty Metal Decorative Window Drapery Holder Curtain Hook, Black ');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (17, 14, 'Curtain Holdback, 2pcs Wall Mounted Drapery Tiebacks with Clear Crystal Ball, Heavy Duty Metal Decorative Window Drapery Curtain Holder Curtain Hooks with Screws, Sliver ');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (18, 13, '42 Pack Curtain Rings with Clips Decorative Drapery Rustproof Vintage Compatible with up to 5/8 inch Rod Black');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (19, 7, 'Curtain Rod Clip Rings for 1" Rod, Set of 7, Dark Bronze (Espresso) ');
INSERT INTO Product_t  (Product_id, Price, Description)
VALUES  (20, 8, 'Ivilon Drapery Curtain Clip Rings - Clips Ring for Curtain Panels 1.7", Set of 14 - Oil Rubbed Bronze (ORB)');

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


INSERT INTO QA_t  (User_id, Product_id)
VALUES  (2, 3);

INSERT INTO QA_t  (User_id, Product_id)
VALUES  (4, 1);

INSERT INTO QA_t  (User_id, Product_id)
VALUES  (3, 6);

INSERT INTO QA_t  (User_id, Product_id)
VALUES  (5, 5);


INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (6, 3, 5, 'Very good quality for the price and is 100% blackout.', '2021-04-05' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (6, 1, 4, "Quality of my curtains is worth what l payed love them can’t wait to hang them up.", '2021-04-01' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (8, 6, 2, "They're good quality although I got the light gray ones and they looked a little greenish not as they pictured them.", '2021-04-12' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (7, 5, 5, "I like the fabric, is very soft and tick. It's 100% blackout. The blush color is very elegant and warm. I love this courtain!", '2021-04-08' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (11, 7, 3, "They make it hard to see in the photos, an old advertising trick here. I was hoping for a drill with a light on it, but this one doesn't have one. Also, when using extensions it seems to have a serious problem with keeping the extension bits locked into place for some reason. I have used many drills in my life, but there's nothing special about this one other than the price. The kit is maybe 5 bucks worth of bits, so don't get excited by seeing all the stuff you see in the photos. I used to work in utilities in the field; now I work in IT, which requires a bit less of a heavy duty drill to my thinking, but now I wish I would have spent a few extra bucks and got something better. This thing works well enough...no design flaws except the one mentioned above...but it's not great. Don't let the high reviews fool you. It's just a good price is all. ", '2018-02-19' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (12, 8, 3, "The drill is...serviceable. Pretty slow and not overwhelmingly powerful, but prob fine for occasional use. I bought this with the accessory kit. Don't make the same mistake. Low quality, no hex, and the bit drivers - am I allowed to use the word Failed to drive 3 deck screws. Cammed out every time. It was not the screws that got bunged. It was the driver. Buy the drill, if you just need a cordless drive now and then for this and that. Skip the accessory bundle no matter what. ", '2019-05-03' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (13, 9, 1, "This drill is the worst! It doesn't have enough power to drill a screw into wood without predrilling a hole. Even then it's more likely to strip the screw than push it in. When drilling a hole the chuck let go of the bit when I went to pull out rather than actually pull the drill bit out. Not worth it. Get a better one and pay more. Learn from my mistake! ", '2021-01-05' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (14, 10, 5, "I haven't used many drills, but I think this is a nice drill and I was able to fix my door using it. There wasn't a list of what was included, but I was hoping there would be larger drill bits like a 3/8 drill bit. I was able to do what I needed using the largest drill bit included 1/4. For drilling holes I found the silver/steel ones to be the best.", '2018-12-21' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (15, 11, 1, "Absolutely awful. I bought this drill less then a year ago. I have two other drills I use for work but figured I would buy this one to keep at home since it’s cheap. It is cheap for a reason. The chuck got stuck after the third time using it and have literally tried everything including vise grips to get it undone. I have finally given up on it and gave the thing away. I got a call a week after giving it away saying I was right it is a piece. He ended up throwing it away. Terrible drill. DO NOT WASTE YOUR MONEY!!!! Buy something a little more expensive that will last. You’ll save money in the long wrong. In the reviews a lot of people have this problem with this drill. Gets jammed up easily. ", '2018-12-21' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (16, 12, 5, "I live alone and am strong and agile enough to do my own tasks, but I have a healthy fear of falling. My small Cosco 2 step ladder is used often inside the house. But I needed a ladder for outdoor gutters (extension ladder?) which had to be stable enough for reaching into my fruit trees...I wanted only ONE ladder for both tasks. Decided to go to a big box store to buy an 8' step ladder and had it delivered. Quickly, I realized that the ladder was VERY unwieldy (duh) but more important it weighed a ton, a bad combination. Went to the internet and looked up the Cosco line of ladders and decided to gamble on their version. What a difference! First, it's absolutely lighter, but importantly the handle at the mid-point makes moving it around so much easier. It's very steady and I feel safe using it.  ", '2019-11-21' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (17, 13, 5, "This is the best ladder I have ever purchased or used ...... This is a rock solid ladder and very stable, to include the platform. I am 5 6' and I can reach 12 foot ceilings perfectly. This is a long ladder but very light and it easily folds. I love the little areas to put tools. This is the FIRST ladder that made me feel safe - seriously. I received nothing for this review.", '2020-01-21' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (18, 14, 1, "Since I'm getting up in years I decided it was time to replace my rickety old wooden ladder and what a sweet piece of work this new one is-one of the best purchases ever.It is solid and sturdy but not overly heavy and has some great features.On the top rung is a sturdy wide platform to stand on instead of a narrow rung and it also serves to lock the legs in place.Above that is a platform to set a can of paint on and it contains a shallow pull-out drawer for assorted small tools,etc-really neat.Above that is a handle to hold on to.It even has a paper towel holder.I also love the carrying handle on the side that locks the legs together so you can carry it like a briefcase.Somebody really put some thought into this. ", '2021-02-21' );

INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (19, 15, 5, "This is a really great ladder in our very old home with high ceilings. It is steady and when I purchased it, it wasn't too heavy. Since then I have grown older so it is heavy to carry now. Having said this, as an older person I am very grateful it is steady for changing light bulbs. It could easily be used for painting walls or ceilings. My only complaint was the cost which I found too high. ", '2019-03-15' );
INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (20, 16, 3, " Although this is very nice it was too small for my linen curtains.  ", '2019-09-15' ); 
INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (21, 17, 4, " Item is smaller than hoped for. ", '2019-03-25' );
INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (22, 18, 5, " Great depth and sturdiness to hold our thick blackout curtains ", '2021-02-15' );
INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (23, 19, 5, " The curtain hooks are nicely designed and can be used vertically or horizontally ", '2020-09-15' );
INSERT INTO Review_t  (User_id, Product_id, Rating, Review, Review_date)
VALUES  (24, 20, 5, "I used theses to hold back curtains. They are perfect. Not to big. They do not take away for the look I was going for. ", '2019-11-26' );

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
