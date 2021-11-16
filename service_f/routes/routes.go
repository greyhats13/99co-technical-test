package routes

import (
	"service_f/controllers"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

func Routes(db *gorm.DB) *gin.Engine {
	r := gin.Default()
	r.Use(func(c *gin.Context) {
		c.Set("db", db)
	})
	r.GET("/", controllers.Health)
	r.GET("/list", controllers.List)
	r.POST("/add", controllers.Add)
	r.GET("/get-member/:id", controllers.Get)
	r.PUT("/update-member/:id", controllers.Update)
	r.DELETE("/delete-member/:id", controllers.Delete)
	return r
}
