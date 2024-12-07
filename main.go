package main

import (
	"fmt"
	"net/http"
)

func main() {
	fmt.Println("Welcome to the todo list!")
	port := ":8080"
	http.HandleFunc("/", helloUser)
	http.ListenAndServe(port, nil)
}

func printTasks(taskItems []string) {

	fmt.Println("List of Todos")
	for index, task := range taskItems {
		fmt.Println("task#", index+1, task)
	}
}
func addTask(taskItems []string, newTask string) []string {
	update := append(taskItems, newTask)
	return update
}
func removeTask(taskItems []string, index int) []string {
	if index < 0 || index > len(taskItems) {
		fmt.Println("Invalid!!")
		return taskItems
	}
	updatedList := append(taskItems[:index], taskItems[index+1:]...)
	return updatedList
}
func helloUser(writer http.ResponseWriter, request *http.Request) {
	greeting := "Welcome to our app"
	fmt.Fprintln(writer, greeting)
}
