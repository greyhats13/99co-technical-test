package main

import (
	"transaction/helpers"
	"transaction/models"
	"transaction/routes"
)

func main() {

	db := helpers.MySQL()
	db.AutoMigrate(&models.Transaction{})

	r := routes.Routes(db)
	r.Run()
}
