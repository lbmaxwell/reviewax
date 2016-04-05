package router

import (
	"net/http"
	"reviewax/control"

	"github.com/gorilla/mux"

	// Move this to controllers - just here for prelim testing
	"html/template"
	"reviewax/config"
	"reviewax/db"
	//"reviewax/model" // Move this to controllers - just here for prelim testing
	// db should not be called from here for prod - called here for testing
)

// Listen is the first method handling incoming requests
func Listen() {
	r := mux.NewRouter()
	r.HandleFunc("/setup", control.SetupIndex)
	r.HandleFunc("/ttest", control.TemplateTest)
	r.HandleFunc("/gtest", GorillaTestHandler)
	r.HandleFunc("/dbtest", DbTestHandler)
	http.ListenAndServe(":8080", r)
}

func DbTestHandler(w http.ResponseWriter, r *http.Request) {
	// Successfully servers file. Static content served via nginx
	//http.ServeFile(w, r, appRoot+"/view/index.html")

	// This block worked
	t, _ := template.ParseFiles(config.AppRoot + "/view/dbtest.html")
	//p := model.Person{Email: "test@test.com", FirstName: "John", LastName: "Doe", Title: "Test Title Variable Value"}
	p := db.GetPersonByEmail("admin@domain.com")
	t.Execute(w, p)

	// This block worked
	//	t, _ := template.ParseFiles(appRoot + "/view/index.html")
	//	t.Execute(w, nil)
}

func GorillaTestHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Gorilla Mux Test - TestHandler\n"))
}
