package main

import (
	"fmt"
	"net/http"
)

func main() {
	fmt.Println("Welcome to the todo list!")
	http.ListenAndServe()
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
