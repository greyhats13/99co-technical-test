package models

import (
	"time"
)

type Transaction struct {
	ID         uint      `form:"id" json:"id" gorm:"primary_key;AUTO_INCREMENT;not null"`
	MemberID   string    `form:"memberid" json:"memberid"`
	BookID     string    `form:"bookid" json:"bookid"`
	BorrowAt   time.Time `form:"borrowat" json:"borrowat" gorm:"default:CURRENT_TIMESTAMP"`
	ReturnAt   time.Time `form:"returnat" json:"returnat"`
	EmployeeID string    `form:"employeeid" json:"employeeid"`
	Status     uint      `form:"status" json:"status" gorm:"default:0"`
}
