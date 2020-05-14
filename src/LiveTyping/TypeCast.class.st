Class {
	#name : #TypeCast,
	#superclass : #Object,
	#instVars : [
		'objetToCast'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #applying }
TypeCast >> applyTo: aParseNode using: originalTypes [

	^(self isFor: aParseNode) 
		ifTrue: [ self cast: originalTypes ]
		ifFalse: [ originalTypes ]
]

{ #category : #casting }
TypeCast >> cast: originalTypes [

	self subclassResponsibility
]

{ #category : #testing }
TypeCast >> isFor: aParseNode [

	^objetToCast isSameAs: aParseNode
]
