//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//::::::::::::::::::::::::::::::::::::::Week 2 Code Challenge :::::::::::::::::::::::::::::::::::::::::::::://

/*Day 1********Code Challenge: Write a function that determines how many words there are in a sentence
geeksforgeeks.org*/

let strOfWords = "How many words are in this string? \t"
let blank = " "

//let whiteSpaceNewLine = NSCharacterSet.whitespaceAndNewlineCharacterSet()
//
//let wordArray = strOfWords.componentsSeparatedByString(" ")
//wordArray.count


func strCounter(str:String) -> Int{
	
	var state = false
	var wordcounter = 0
	
	for character in str{
		if character == " " || character == "\n" || character == "\t"{
			state = false
		}
		else if state == false{
			state = true
			++wordcounter
		}
	}
	
	return wordcounter
	
}

strCounter(strOfWords)
strCounter(blank)



/*Day 2 ******Code Challenge: Write a function that returns all the odd elements of an array************/
let array = [1,3,5,6,8,10,12]

func oddElements(array:[Int]) -> [Int]{
	var oddArray = [Int]()
	
	for var i = 0; i < array.count; ++i{
		if array[i]%2 == 1{
			oddArray.append(array[i])
		}
		
	}
	return oddArray
}

oddElements(array)



//Day 3 Code Challenge: Write a function that computes the list of the first 100 Fibonacci numbers.

func fibonacci1(n: Int) -> Int {
	if n < 2 {
		return n
	}
	var fibPrev = 1
	var fib = 1
	for num in 2...n {
		(fibPrev, fib) = (fib, fib + fibPrev)
	}
	return fib
}

fibonacci1(100)


func fibonacci(n: Int) -> Int {
	if n < 2 {
		return n
	} else {
		return fibonacci(n-1) + fibonacci(n-2)
	}
}

println(fibonacci(30))

