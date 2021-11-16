// controllers/task.go

package controllers

import (
	"fmt"
	"service_f/models"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

type CreateMemberInput struct {
	Email    string `form:"email" json:"email" gorm:"unique"`
	Password string `form:"password" json:"password"`
	Name     string `form:"name" json:"name"`
	Address  string `form:"address" json:"address"`
	Phone    string `form:"phone" json:"phone"`
	Role     string `form:"role" json:"role"`
}

type UpdateMemberInput struct {
	Email    string `form:"email" json:"email" gorm:"unique"`
	Password string `form:"password" json:"password"`
	Name     string `form:"name" json:"name"`
	Address  string `form:"address" json:"address"`
	Phone    string `form:"phone" json:"phone"`
	Role     string `form:"role" json:"role"`
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
	var members []models.Member
	db.Find(&members)

	c.JSON(http.StatusOK, gin.H{"data": members})
}

func Add(c *gin.Context) {
	// Validate input
	var input CreateMemberInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	member := models.Member{Email: input.Email, Password: input.Password, Name: input.Name, Address: input.Address, Phone: input.Phone, Role: input.Role}

	db := c.MustGet("db").(*gorm.DB)
	db.Create(&member)

	c.JSON(http.StatusOK, gin.H{"data": member})
}

func Get(c *gin.Context) {
	var member models.Member

	db := c.MustGet("db").(*gorm.DB)
	if err := db.Where("id = ?", c.Param("id")).First(&member).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": member})
}

func Update(c *gin.Context) {

	db := c.MustGet("db").(*gorm.DB)
	// Get model if exist
	var member models.Member
	if err := db.Where("id = ?", c.Param("id")).First(&member).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	// Validate input
	var input UpdateMemberInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	var updatedInput models.Member
	updatedInput.Email = input.Email
	updatedInput.Password = input.Password
	updatedInput.Name = input.Name
	updatedInput.Address = input.Address
	updatedInput.Phone = input.Phone
	updatedInput.Role = input.Role

	db.Model(&member).Updates(updatedInput)

	c.JSON(http.StatusOK, gin.H{"data": member})
}

func Delete(c *gin.Context) {
	// Get model if exist
	db := c.MustGet("db").(*gorm.DB)
	var member models.Member
	if err := db.Where("id = ?", c.Param("id")).First(&member).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Data tidak ditemukan!"})
		return
	}

	db.Delete(&member)

	c.JSON(http.StatusOK, gin.H{"message": "Data berhasil dihapus!"})
}
