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
	for index, task := range taskItems {
		fmt.Println("task#", index, task)
	}
}
