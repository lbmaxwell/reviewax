package db

import (
	//"database/sql"
	"log"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

type DB struct {
	*sqlx.DB
}

// Configs need to be moved to a yaml file eventually
func GetDb1() *DB {
	// this Pings the database trying to connect, panics on error
	db, err := sqlx.Connect("postgres", "user=rax_app password=abc123 host=127.0.0.1 dbname=reviewax sslmode=require")
	if err != nil {
		log.Fatalln(err)
	}

	return &DB{db}
}
