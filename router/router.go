package router

import (
	"net/http"

	"github.com/gorilla/mux"

	"html/template" // Move this to controllers - just here for prelim testing
	//"reviewax/model" // Move this to controllers - just here for prelim testing
)

// appHome variable needs to be loaded from a config file
// static assignement of appHome below is temporary
var appRoot = "/home/bmaxwell/go/src/reviewax"

// Listen is the first method handling incoming requests
func Listen() {
	r := mux.NewRouter()
	r.HandleFunc("/", RootHandler)
	r.HandleFunc("/test", TestHandler)

	http.ListenAndServe(":8080", r)
}

func RootHandler(w http.ResponseWriter, r *http.Request) {
	// Successfully servers file. Static content served via nginx
	//http.ServeFile(w, r, appRoot+"/view/index.html")

	// This block worked
	//	t, _ := template.ParseFiles(appRoot + "/view/test.html")
	//	p := model.Person{Email: "test@test.com", FirstName: "John", LastName: "Doe", Title: "Test Title Variable Value"}
	//	t.Execute(w, p)

	t, _ := template.ParseFiles(appRoot + "/view/index.html")
	t.Execute(w, nil)
}

func TestHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Gorilla Mux Test - TestHandler\n"))

}
