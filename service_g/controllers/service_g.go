// controllers/task.go

package controllers

import (
	"fmt"
	"net/http"
	"os"
	"time"
	"transaction/models"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

type CreateTransactionInput struct {
	MemberID   string    `form:"memberid" json:"memberid"`
	BookID     string    `form:"bookid" json:"bookid"`
	BorrowAt   time.Time `form:"borrowat" json:"borrowat"`
	ReturnAt   time.Time `form:"returnat" json:"returnat"`
	EmployeeID string    `form:"employeeid" json:"employeeid"`
	Status     uint      `form:"status" json:"status"`
}

type UpdateTransactionInput struct {
	MemberID   string    `form:"memberid" json:"memberid"`
	BookID     string    `form:"bookid" json:"bookid"`
	BorrowAt   time.Time `form:"borrowat" json:"borrowat"`
	ReturnAt   time.Time `form:"returnat" json:"returnat"`
	EmployeeID string    `form:"employeeid" json:"employeeid"`
	Status     uint      `form:"status" json:"status"`
}

func Health(c *gin.Context) {
	// Get model if exist
	URL := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8&parseTime=True&loc=Local", os.Getenv("DB_USER"), os.Getenv("DB_PASS"), os.Getenv("DB_HOST"), os.Getenv("DB_PORT"), os.Getenv("DB_NAME"))
	testDB, err := gorm.Open("mysql", URL)
	sqlDB := testDB.DB()
	sqlDB.Ping()
	sqlDB.Close()

	if err != nil {
		panic(err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	} else {
		c.JSON(http.StatusOK, gin.H{"message": "ok"})
	}
}

func List(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	var transactions []models.Transaction
	db.Find(&transactions)

	c.JSON(http.StatusOK, gin.H{"data": transactions})
}

func Borrow(c *gin.Context) {
	// Validate input
	var input CreateTransactionInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	transaction := models.Transaction{MemberID: input.MemberID, BookID: input.BookID, EmployeeID: input.EmployeeID, Status: 0}

	db := c.MustGet("db").(*gorm.DB)
	db.Create(&transaction)

	c.JSON(http.StatusOK, gin.H{"data": transaction})
}

func Return(c *gin.Context) {

	db := c.MustGet("db").(*gorm.DB)
	// Get model if exist
	var transaction models.Transaction
	if err := db.Where("id = ?", c.Param("id")).First(&transaction).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	// Validate input
	var input UpdateTransactionInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	var updatedInput models.Transaction
	currentTime := time.Now()
	updatedInput.ReturnAt = currentTime
	updatedInput.Status = 1

	db.Model(&transaction).Updates(updatedInput)

	c.JSON(http.StatusOK, gin.H{"data": transaction})
}

func Get(c *gin.Context) {
	var transaction models.Transaction

	db := c.MustGet("db").(*gorm.DB)
	if err := db.Where("id = ?", c.Param("id")).First(&transaction).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": transaction})
}

func ListByMember(c *gin.Context) {
	var transaction models.Transaction

	db := c.MustGet("db").(*gorm.DB)
	if err := db.Where("member_id = ?", c.Param("memberid")).First(&transaction).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": transaction})
}

func Update(c *gin.Context) {

	db := c.MustGet("db").(*gorm.DB)
	// Get model if exist
	var transaction models.Transaction
	if err := db.Where("id = ?", c.Param("id")).First(&transaction).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	// Validate input
	var input UpdateTransactionInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	var updatedInput models.Transaction
	updatedInput.MemberID = input.MemberID
	updatedInput.BookID = input.BookID
	updatedInput.BorrowAt = input.BorrowAt
	updatedInput.ReturnAt = input.ReturnAt
	updatedInput.EmployeeID = input.EmployeeID
	updatedInput.Status = input.Status

	db.Model(&transaction).Updates(updatedInput)

	c.JSON(http.StatusOK, gin.H{"data": transaction})
}

func Delete(c *gin.Context) {
	// Get model if exist
	db := c.MustGet("db").(*gorm.DB)
	var transaction models.Transaction
	if err := db.Where("id = ?", c.Param("id")).First(&transaction).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	db.Delete(&transaction)

	c.JSON(http.StatusOK, gin.H{"message": "Data berhasil dihapus!"})
}
