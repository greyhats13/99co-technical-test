package routes

import (
	"service_e/controllers"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

func Routes(db *gorm.DB) *gin.Engine {
	r := gin.Default()
	r.Use(func(c *gin.Context) {
		c.Set("db", db)
	})
	r.GET("/", controllers.HealthCheck)
	r.GET("/list-book", controllers.GetBooks)
	r.POST("/add-book", controllers.AddBook)
	r.GET("/get-book/:id", controllers.GetBook)
	r.PUT("/update-book/:id", controllers.UpdateBook)
	r.DELETE("/delete-book/:id", controllers.DeleteBook)
	return r
}
