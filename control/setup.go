package control

import "net/http"

func SetupIndex(w http.ResponseWriter, r *http.Request) {

	renderTemplate(w, "setup")
}
