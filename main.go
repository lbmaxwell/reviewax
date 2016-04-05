package main

import "reviewax/router"

func main() {
	// TODO - Make AppRoot startup argument or place in config file
	//control.AppRoot = "/home/bmaxwell/go/src/reviewax"

	// TODO - Load all html templates into memory

	router.Listen()
}
