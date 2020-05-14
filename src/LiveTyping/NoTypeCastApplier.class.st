Class {
	#name : #NoTypeCastApplier,
	#superclass : #TypeCastApplier,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #applying }
NoTypeCastApplier >> applyTo: aParseNode with: originalTypes [

	^originalTypes 
]

{ #category : #applying }
NoTypeCastApplier >> typesIfCasting: aParseNode using: originalTypes ifNot: aNotBlock [

	^aNotBlock value
]

{ #category : #applying }
NoTypeCastApplier >> typesIfRejecting: aParseNode using: originalTypes [ 

	^originalTypes 
]
