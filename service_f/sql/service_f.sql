CREATE TABLE IF NOT EXISTS `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberid` varchar(50),
  `bookid` varchar(100),
  `borrowat` varchar(50),
  `address` varchar(100),
  `phone` varchar(15),
  `role` varchar(15),
  PRIMARY KEY (`id`),
  UNIQUE (`email`)
);

INSERT INTO members (`email`, `password`, `name`, `address`, `phone`, `role`)
VALUES 
  ('imam.rahman@ralali.com', 'test123', 'Imam Arief Rahman', 'Jl. Pasteur No 32, Sukajadi, Coblong, Bandung, Jawa Barat 40133', "081212134345", "admin"),
  ('idanfeak@gmail.com', 'test124', 'Danny Setiadi', 'Jl. Dago No 14, Dipati Ukur, Coblong, Bandung, Jawa Barat 40132', "081212176432", "member");