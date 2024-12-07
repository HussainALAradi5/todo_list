package main

import "fmt"

func main() {
	test()
}
func test() {
	taskOne := "Learn go"
	taskTwo := "Learn Fiber framework"
	taskThree := "Learn Algorithms"
	taskItems := []string{taskOne, taskTwo, taskThree}
	fmt.Println("Welcome to our todolist app")
	printTasks(taskItems)
}
func printTasks(taskItems []string) {

	fmt.Println("List of Todos")
	for index, task := range taskItems {
		fmt.Println("task#", index+1, task)
	}
}
