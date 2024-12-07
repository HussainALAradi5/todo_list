package main

import (
	"fmt"
	"net/http"
	"strconv"
)

var taskItems []string // Global variable to hold tasks

func main() {
	// Initialize tasks
	taskItems = []string{"Learn Go", "Learn Fiber framework", "Learn Algorithms"}

	fmt.Println("Welcome to the todo list!")
	port := ":8080"

	// Routes
	http.HandleFunc("/", helloUser)
	http.HandleFunc("/show_tasks", showTasks)
	http.HandleFunc("/add_task", addTaskHandler)
	http.HandleFunc("/remove_task", removeTaskHandler)

	http.ListenAndServe(port, nil)
}

// Print a welcome message
func helloUser(writer http.ResponseWriter, request *http.Request) {
	greeting := "Welcome to our app"
	fmt.Fprintln(writer, greeting)
}

// Show all tasks
func showTasks(writer http.ResponseWriter, request *http.Request) {
	fmt.Fprintln(writer, "List of Todos:")
	for i, task := range taskItems {
		fmt.Fprintf(writer, "%d: %s\n", i+1, task)
	}
}

// Add a task
func addTaskHandler(writer http.ResponseWriter, request *http.Request) {
	if request.Method == http.MethodPost {
		task := request.URL.Query().Get("task") // Get "task" from query params
		if task == "" {
			http.Error(writer, "Task is required", http.StatusBadRequest)
			return
		}
		taskItems = append(taskItems, task)
		fmt.Fprintf(writer, "Task added: %s\n", task)
	} else {
		http.Error(writer, "Invalid method. Use POST to add tasks.", http.StatusMethodNotAllowed)
	}
}

// Remove a task
func removeTaskHandler(writer http.ResponseWriter, request *http.Request) {
	if request.Method == http.MethodPost {
		indexStr := request.URL.Query().Get("index") // Get "index" from query params
		if indexStr == "" {
			http.Error(writer, "Index is required", http.StatusBadRequest)
			return
		}

		index, err := strconv.Atoi(indexStr)
		if err != nil || index < 1 || index > len(taskItems) {
			http.Error(writer, "Invalid index", http.StatusBadRequest)
			return
		}

		taskItems = append(taskItems[:index-1], taskItems[index:]...) // Remove the task
		fmt.Fprintf(writer, "Task removed at index: %d\n", index)
	} else {
		http.Error(writer, "Invalid method. Use POST to remove tasks.", http.StatusMethodNotAllowed)
	}
}
