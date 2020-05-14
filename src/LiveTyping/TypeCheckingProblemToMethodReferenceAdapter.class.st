Class {
	#name : #TypeCheckingProblemToMethodReferenceAdapter,
	#superclass : #Object,
	#instVars : [
		'typeCheckingProblem',
		'prefix'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
TypeCheckingProblemToMethodReferenceAdapter class >> of: aTypeCheckingProblem [

	^self of: aTypeCheckingProblem prefixing: ''
]

{ #category : #'instance creation' }
TypeCheckingProblemToMethodReferenceAdapter class >> of: aTypeCheckingProblem prefixing: aHeader [

	^self new initializeOf: aTypeCheckingProblem prefixing: aHeader


]

{ #category : #'method reference protocol' }
TypeCheckingProblemToMethodReferenceAdapter >> actualClass [
	
	^typeCheckingProblem method actualClass
]

{ #category : #printing }
TypeCheckingProblemToMethodReferenceAdapter >> displayStringOrText [

	^prefix, typeCheckingProblem displayStringOrText
]

{ #category : #initialization }
TypeCheckingProblemToMethodReferenceAdapter >> initializeOf: aTypeCheckingProblem prefixing: aHeader [

	typeCheckingProblem := aTypeCheckingProblem.
	prefix := aHeader 
]

{ #category : #'method reference protocol' }
TypeCheckingProblemToMethodReferenceAdapter >> methodSymbol [
	
	^typeCheckingProblem method methodSymbol 
]

{ #category : #'method reference protocol' }
TypeCheckingProblemToMethodReferenceAdapter >> sourceCodeRange [
	
	^typeCheckingProblem sourceCodeRange 
]
