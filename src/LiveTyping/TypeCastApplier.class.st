Class {
	#name : #TypeCastApplier,
	#superclass : #Object,
	#instVars : [
		'receiverTypes'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #applying }
TypeCastApplier >> applyTo: aParseNode with: originalTypes [

	self subclassResponsibility 
]

{ #category : #'receiver types' }
TypeCastApplier >> initialize [

	receiverTypes := IdentityDictionary new
]

{ #category : #'receiver types' }
TypeCastApplier >> receiverTypesFor: aMessageNode in: actualMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [ 
	
	^receiverTypes
		at: aMessageNode receiverOrCascadeReceiver
		ifAbsentPut: [ aMessageNode receiverTypesIn: actualMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: self ].
	

]

{ #category : #applying }
TypeCastApplier >> typesIfCasting: aParseNode using: originalTypes ifNot: aNotBlock [

	self subclassResponsibility 
]

{ #category : #applying }
TypeCastApplier >> typesIfRejecting: aParseNode using: originalTypes [ 

	self subclassResponsibility 
]
