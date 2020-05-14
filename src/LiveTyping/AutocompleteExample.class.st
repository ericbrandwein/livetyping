Class {
	#name : #AutocompleteExample,
	#superclass : #TestCase,
	#category : #'LiveTyping-Playground'
}

{ #category : #'as yet unclassified' }
AutocompleteExample >> doSomething [
	
	^10 factorial 
]

{ #category : #examples }
AutocompleteExample >> testAutoCompleteExample [

	 10 factorial isInteger not.
	
]

{ #category : #examples }
AutocompleteExample >> testExample [

	| temp1 |
	
	temp1 := self doSomething.
	
	temp1 isInteger not 
]

{ #category : #examples }
AutocompleteExample >> testExampleMessagesOfDifferentSubclasses [

	| aCollection |
	
	aCollection := Array new.
	aCollection := OrderedCollection new.
	
	aCollection addAllFirst: #(1 2 3).
	
]

{ #category : #examples }
AutocompleteExample >> testExampleWithNoCommonSupertype [

	| oneHour today s |
	
	s :='hola'.
	
	"Chalten time measures"
	oneHour := 1*hour.
	self assert: 2*hour equals: oneHour + oneHour.
	 
	"Chronology time measures"
	oneHour := 1 hours.
	self assert: 2 hours equals: oneHour + oneHour.
	
	"Chalten date"
	today := February/1/ 2019.
	self assert: February equals: today month.
	self assert: February, 2019 equals: today monthOfYear.
	today .
	"Chronology date"
	today := Date year: 2019 month: 2 day: 1.
	self assert: 'February' equals: today monthName.
	self assert: (Month month: 'February' year: 2019) equals: today month 
	
	
	
	
	
	
	
	
	
]
