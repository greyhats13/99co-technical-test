package routes

import (
	"transaction/controllers"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

func Routes(db *gorm.DB) *gin.Engine {
	r := gin.Default()
	r.Use(func(c *gin.Context) {
		c.Set("db", db)
	})
	r.GET("/v1/", controllers.Health)
	r.GET("/v1/list", controllers.List)
	r.POST("/v1/borrow", controllers.Borrow)
	r.PUT("/v1/return/:id", controllers.Return)
	r.GET("/v1/get/:id", controllers.Get)
	r.GET("/v1/list/:memberid", controllers.ListByMember)
	r.PUT("/v1/update/:id", controllers.Update)
	r.DELETE("/v1/delete/:id", controllers.Delete)
	return r
}
