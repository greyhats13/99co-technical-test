CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberid` varchar(50),
  `bookid` varchar(100),
  `borrowat` varchar(50),
  `returnat` date,
  `employeeid` varchar(15),
  PRIMARY KEY (`id`)
);