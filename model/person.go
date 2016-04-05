package model

import (
	"time"
)

type Person struct {
	Id        uint64    `db:"id"`
	Email     string    `db:"email"`
	LastName  string    `db:"last_name"`
	FirstName string    `db:"first_name"`
	CreatedBy uint64    `db:"created_by"`
	CreatedAt time.Time `db:"created_at"`
	UpdatedBy uint64    `db:"updated_by"`
	UpdatedAt time.Time `db:"updated_at"`
	Version   uint32    `db:"version"`
}

/*
func GetAll() []Person {
  // Needs to be replaced by real loo
   p := []Person
   p.append(Person{Email: "test@test.com", FirstName: "John", LastName: "Doe", Title: "Test Title Variable Value"})
return p
}
*/

/*
func User() {
  // Return in-memory representation of the user record related to this person
  // Return nil, null, empty string? - whatever is correct in Go - if the person is not a user
}
*/
