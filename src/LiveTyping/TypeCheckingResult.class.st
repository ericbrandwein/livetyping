Class {
	#name : #TypeCheckingResult,
	#superclass : #Object,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #printing }
TypeCheckingResult >> displayStringOrText [

	^ self problemTypeIdentifierString, ': ', self problemDescription
]

{ #category : #method }
TypeCheckingResult >> method [

	self subclassResponsibility 
]

{ #category : #printing }
TypeCheckingResult >> problemDescription [

	self subclassResponsibility 
]

{ #category : #printing }
TypeCheckingResult >> problemTypeIdentifierString [

	self subclassResponsibility 
]

{ #category : #method }
TypeCheckingResult >> sourceCodeRange [

	self subclassResponsibility 
]
