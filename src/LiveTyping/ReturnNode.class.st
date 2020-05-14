Class {
	#name : #ReturnNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
ReturnNode >> identifierPrintString [
	
	^'^'
]

{ #category : #'as yet unclassified' }
ReturnNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^aCompiledMethod returnTypes

]
