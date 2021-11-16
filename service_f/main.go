package main

import (
	"service_f/helpers"
	"service_f/models"
	"service_f/routes"
)

func main() {

	db := helpers.MySQL()
	db.AutoMigrate(&models.Member{})

	r := routes.Routes(db)
	r.Run()
}
