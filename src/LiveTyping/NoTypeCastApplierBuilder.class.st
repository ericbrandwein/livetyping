Class {
	#name : #NoTypeCastApplierBuilder,
	#superclass : #TypeCastApplierBuilder,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'type casts' }
NoTypeCastApplierBuilder >> addAfterMessageTypeCastsTo: aCastingStrategy [ 
	
	
]

{ #category : #building }
NoTypeCastApplierBuilder >> for: aBlockNode previous: aPreviousCastingApplier [

	"I don't use NoCastingTypeApplier because rejects can be added to the strategy for example 
	when: x ifNil: [ ^... ] - Hernan"
	^EffectiveTypeCastApplier previous: aPreviousCastingApplier 
]
