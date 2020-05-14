Class {
	#name : #MethodNotAnnotatingTypesProblem,
	#superclass : #TypeCheckingResult,
	#instVars : [
		'method'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
MethodNotAnnotatingTypesProblem class >> for: aMethod [
	
	^self new initializeFor: aMethod
]

{ #category : #initialization }
MethodNotAnnotatingTypesProblem >> initializeFor: aMethod [
	
	method := aMethod
]

{ #category : #method }
MethodNotAnnotatingTypesProblem >> method [
	
	^method
]

{ #category : #printing }
MethodNotAnnotatingTypesProblem >> problemDescription [

	^ 'Method is not annotating types'
]

{ #category : #printing }
MethodNotAnnotatingTypesProblem >> problemTypeIdentifierString [

	^ 'Problem'
]

{ #category : #method }
MethodNotAnnotatingTypesProblem >> sourceCodeRange [
	
	^#()
]
