// controllers/task.go

package controllers

import (
	"service_e/models"
	"fmt"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

type CreateBookInput struct {
	ISBN      string `form:"isbn" json:"isbn"`
	Title     string `form:"title" json:"title"`
	Author    string `form:"author" json:"author"`
	Publisher string `form:"publisher" json:"publisher"`
}

type UpdateBookInput struct {
	ISBN      string `form:"isbn" json:"isbn"`
	Title     string `form:"title" json:"title"`
	Author    string `form:"author" json:"author"`
	Publisher string `form:"publisher" json:"publisher"`
}

func HealthCheck(c *gin.Context) {
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

func GetBooks(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	var books []models.Book
	db.Find(&books)

	c.JSON(http.StatusOK, gin.H{"data": books})
}

func AddBook(c *gin.Context) {
	// Validate input
	var input CreateBookInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	book := models.Book{ISBN: input.ISBN, Title: input.Title, Author: input.Author, Publisher: input.Publisher}

	db := c.MustGet("db").(*gorm.DB)
	db.Create(&book)

	c.JSON(http.StatusOK, gin.H{"data": book})
}

func GetBook(c *gin.Context) {
	var book models.Book

	db := c.MustGet("db").(*gorm.DB)
	if err := db.Where("id = ?", c.Param("id")).First(&book).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": book})
}

func UpdateBook(c *gin.Context) {

	db := c.MustGet("db").(*gorm.DB)
	// Get model if exist
	var book models.Book
	if err := db.Where("id = ?", c.Param("id")).First(&book).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	// Validate input
	var input UpdateBookInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	var updatedInput models.Book
	updatedInput.ISBN = input.ISBN
	updatedInput.Title = input.Title
	updatedInput.Author = input.Author
	updatedInput.Publisher = input.Publisher

	db.Model(&book).Updates(updatedInput)

	c.JSON(http.StatusOK, gin.H{"data": book})
}

func DeleteBook(c *gin.Context) {
	// Get model if exist
	db := c.MustGet("db").(*gorm.DB)
	var book models.Book
	if err := db.Where("id = ?", c.Param("id")).First(&book).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	db.Delete(&book)

	c.JSON(http.StatusOK, gin.H{"message": "Data berhasil dihapus!"})
}
