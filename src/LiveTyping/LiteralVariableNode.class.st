Class {
	#name : #LiteralVariableNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
LiteralVariableNode >> isLiteralVariableNode [

	^true
]

{ #category : #'as yet unclassified' }
LiteralVariableNode >> isReferencingBehavior [
	
	^key value isBehavior
]

{ #category : #'as yet unclassified' }
LiteralVariableNode >> nodeTypePrintString [

	^'literal var'
]

{ #category : #'as yet unclassified' }
LiteralVariableNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^ Array with: key value class
]
