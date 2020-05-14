Class {
	#name : #TypeCastApplierBuilder,
	#superclass : #Object,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'type casts' }
TypeCastApplierBuilder >> addAfterMessageTypeCastsTo: aCastingStrategy [ 

	self subclassResponsibility 
]

{ #category : #building }
TypeCastApplierBuilder >> for: aBlockNode previous: aPreviousCastingStrategy [

	self subclassResponsibility 
]
