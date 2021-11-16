package models

type Book struct {
	ID        uint   `form:"id" json:"id" gorm:"primary_key;AUTO_INCREMENT;not null"`
	ISBN      string `form:"isbn" json:"isbn" gorm:"unique"`
	Title     string `form:"title" json:"title"`
	Author    string `form:"author" json:"author"`
	Publisher string `form:"publisher" json:"publisher"`
}
