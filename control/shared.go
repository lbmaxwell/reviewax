package control

import (
	"html/template"
	"net/http"
	"reviewax/config"
)

// var AppRoot string = "/home/bmaxwell/go/src/reviewax"

var templates = template.Must(template.ParseFiles(config.AppRoot+"/view/header.html", config.AppRoot+"/view/footer.html", config.AppRoot+"/view/navbar.html", config.AppRoot+"/view/setup.html"))

//var templates, err = template.ParseFiles(AppRoot+"/view/header.html", AppRoot+"/view/footer.html", AppRoot+"/view/setup.html")

//var templates = template.Must(template.ParseFiles(AppRoot+"/view/templatetest.html", AppRoot+"/view/partialtest.html"))

func renderTemplate(w http.ResponseWriter, tmpl string) {
	err := templates.ExecuteTemplate(w, tmpl, nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
