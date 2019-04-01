package main

import (
	"io/ioutil"
	"net/http"
	"path/filepath"
	"text/template"
)

func main() {
	tpl, err := ioutil.ReadFile(filepath.Join("templates", "index.html"))
	if err != nil {
		panic(err)
	}
	t, err := template.New("index").Parse(string(tpl))

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		data := struct {
			Title   string
			Message string
		}{
			Title:   "Hello App",
			Message: "Whalecome to Docker!",
		}
		t.Execute(w, data)
	})
	http.ListenAndServe(":8080", nil)
}
