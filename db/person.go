package db

import "reviewax/model"

//"fmt"
//"reviewax/model"

func GetAllPeople() []model.Person {
	db1 := GetDb1()

	q := "SELECT * FROM person"

	p := []model.Person{}
	//p := Person{}
	db1.Select(&p, q)

	return p
}

func GetPersonByEmail(email string) model.Person {
	db1 := GetDb1()

	q := "SELECT * FROM person WHERE email = $1"

	p := model.Person{}
	//p := Person{}

	db1.Get(&p, q, email)
	//fmt.Printf("%#v\n", p)
	return p
}
