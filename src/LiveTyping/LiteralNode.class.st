Class {
	#name : #LiteralNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
LiteralNode >> nodeTypePrintString [

	^'literal'
]

{ #category : #'as yet unclassified' }
LiteralNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^Array with: self literalValue class
]
