CREATE TABLE IF NOT EXISTS `book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `isbn` varchar(50),
  `title` varchar(50),
  `author` varchar(50),
  `publisher` varchar(50),
  PRIMARY KEY (`id`),
  UNIQUE (`isbn`)
);

INSERT INTO book (`isbn`, `title`, `author`, `publisher`)
VALUES 
  ('978-623-97782-7-9', 'Matematika', 'Ida Bagus Darmatika', 'CV. Lontara Pusaka'),
  ('978-623-98051-0-4', 'Panduan Alat Peraga Matematika', 'Tiur Malasari Siregar', 'LPPM Unimed'),
  ('978-623-379-030-7', 'Pembelajaran inovatif matematika', 'Budi Prihartini', 'CV. Arindri Hijrah');