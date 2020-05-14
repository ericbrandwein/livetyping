Class {
	#name : #EffectiveTypeCastApplierBuilder,
	#superclass : #TypeCastApplierBuilder,
	#instVars : [
		'castingBlock',
		'rejectingBlock',
		'objectToCast',
		'afterMessageTypeCasts'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'type casts' }
EffectiveTypeCastApplierBuilder >> addAfterMessageTypeCastsTo: aCastingStrategy [ 
	
	aCastingStrategy addTypeCasts: afterMessageTypeCasts 
]

{ #category : #initialization }
EffectiveTypeCastApplierBuilder >> addToAfterMessageTypeCasts: aTypeCastBlockBuilder ifReturns: anArgumentBlock [
	
	anArgumentBlock isBlockNode 
		ifTrue: [ anArgumentBlock returns 
			ifTrue: [ afterMessageTypeCasts add: aTypeCastBlockBuilder value ]].

]

{ #category : #'building applier' }
EffectiveTypeCastApplierBuilder >> buildCastApplierBefore: aPreviousCastingStrategy [ 
	
	 self subclassResponsibility 
]

{ #category : #'building applier' }
EffectiveTypeCastApplierBuilder >> buildRejectApplierBefore: aPreviousCastingStrategy [
	
	 self subclassResponsibility 
]

{ #category : #'building cast' }
EffectiveTypeCastApplierBuilder >> buildTypeCast [

	self subclassResponsibility 
]

{ #category : #'building cast' }
EffectiveTypeCastApplierBuilder >> buildTypeReject [ 

	self subclassResponsibility 
]

{ #category : #'building applier' }
EffectiveTypeCastApplierBuilder >> for: aBlockNode previous: aPreviousCastingApplier [ 
	
	aBlockNode = castingBlock ifTrue: [ ^self buildCastApplierBefore: aPreviousCastingApplier ].
	aBlockNode = rejectingBlock ifTrue: [ ^self buildRejectApplierBefore: aPreviousCastingApplier ].
	
	^EffectiveTypeCastApplier previous: aPreviousCastingApplier 
]

{ #category : #initialization }
EffectiveTypeCastApplierBuilder >> initializeAfterMessageTypeCasts [

	afterMessageTypeCasts := OrderedCollection new.
	self 
		addToAfterMessageTypeCasts: [ self buildTypeReject ] ifReturns: castingBlock;
		addToAfterMessageTypeCasts: [ self buildTypeCast ] ifReturns: rejectingBlock
			
	
]
