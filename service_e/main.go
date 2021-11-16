package main

import (
	"service_e/helpers"
	"service_e/models"
	"service_e/routes"
)

func main() {

	db := helpers.MySQL()
	db.AutoMigrate(&models.Book{})

	r := routes.Routes(db)
	r.Run()
}
