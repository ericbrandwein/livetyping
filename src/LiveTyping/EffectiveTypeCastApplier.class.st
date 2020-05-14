Class {
	#name : #EffectiveTypeCastApplier,
	#superclass : #TypeCastApplier,
	#instVars : [
		'previous',
		'casts',
		'rejections'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
EffectiveTypeCastApplier class >> casts: aCollectionOfCasts rejections: aCollectionOfRejections previous: aPreviousCastingStrategy [ 
	
	^self new initializeCasts: aCollectionOfCasts rejections: aCollectionOfRejections previous: aPreviousCastingStrategy 

]

{ #category : #'instance creation' }
EffectiveTypeCastApplier class >> previous: aPreviousCastingStrategy [

	^self 
		casts: OrderedCollection new 
		rejections: OrderedCollection new
		previous: aPreviousCastingStrategy 
]

{ #category : #adding }
EffectiveTypeCastApplier >> addTypeCasts: aCollectionOfRejections [

	rejections addAll: aCollectionOfRejections.
	receiverTypes removeAll	
]

{ #category : #applying }
EffectiveTypeCastApplier >> applyTo: aParseNode with: originalTypes [

	^self typesIfCasting: aParseNode using: originalTypes ifNot: [ self typesIfRejecting: aParseNode using: originalTypes ]
]

{ #category : #initialization }
EffectiveTypeCastApplier >> initializeCasts: aCollectionOfCasts rejections: aCollectionOfRejections previous: aPreviousCastingStrategy [ 

	casts := aCollectionOfCasts.
	rejections := aCollectionOfRejections.
	previous := aPreviousCastingStrategy.
	
]

{ #category : #previous }
EffectiveTypeCastApplier >> previous [
	
	^previous
]

{ #category : #applying }
EffectiveTypeCastApplier >> typesIfCasting: aParseNode using: originalTypes ifNot: aNotBlock [

	^casts 
		detect: [ :aCastType | aCastType isFor: aParseNode ]
		ifFound: [ :aCastType | aCastType cast: originalTypes ]
		ifNone: [ previous typesIfCasting: aParseNode using: originalTypes ifNot: aNotBlock ]
]

{ #category : #applying }
EffectiveTypeCastApplier >> typesIfRejecting: aParseNode using: originalTypes [ 

	| newTypes |
	
	newTypes := rejections 
		inject: originalTypes 
		into: [ :leftTypes :aRejectType | aRejectType applyTo: aParseNode using: leftTypes ].
		
	^previous typesIfRejecting: aParseNode using: newTypes
]
