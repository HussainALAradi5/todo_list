package main

import "fmt"

func main() {
	test()
}
func test() {
	taskOne := "Learn go"
	taskTwo := "Learn Fiber framework"
	taskThree := "Learn Algorithms"
	var taskItems = []string{taskOne, taskTwo, taskThree}
	fmt.Println("Welcome to our todolist app")
	fmt.Println(taskItems)
}
