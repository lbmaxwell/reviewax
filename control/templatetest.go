package control

import (
	"html/template"
	"net/http"
	"reviewax/config"
)

func TemplateTest(w http.ResponseWriter, r *http.Request) {
	// Successfully serves file. Static content served via nginx
	//http.ServeFile(w, r, appRoot+"/view/index.html")

	// This block worked
	t, _ := template.ParseFiles(config.AppRoot+"/view/templatetest.html", config.AppRoot+"/view/partialtest.html")
	t.ExecuteTemplate(w, "templatetest", nil)

	// This block worked
	//	t, _ := template.ParseFiles(appRoot + "/view/index.html")
	//	t.Execute(w, nil)
}
