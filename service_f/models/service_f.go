package models

type Member struct {
	ID       uint   `form:"id" json:"id" gorm:"primary_key;AUTO_INCREMENT;not null"`
	Email    string `form:"email" json:"email" gorm:"unique"`
	Password string `form:"password" json:"password"`
	Name     string `form:"name" json:"name"`
	Address  string `form:"address" json:"address"`
	Phone    string `form:"phone" json:"phone"`
	Role     string `form:"role" json:"role"`
}
