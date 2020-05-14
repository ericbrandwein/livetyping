Class {
	#name : #ClosureVariablesTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #'as yet unclassified' }
ClosureVariablesTest >> methodWithoutClosure: p1 [

	| t1 t2 |
	
	t1 := p1.
	t2 := t1 + 1.
	
	^t2
]

{ #category : #'as yet unclassified' }
ClosureVariablesTest >> testOneArrayForTypesIsCreatedWhenAMethodHasNoClosures [

	| method |
	method := self class>>#methodWithoutClosure:.
	method initializeTypeInformation
]
