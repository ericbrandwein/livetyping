Class {
	#name : #IsKindOfManyTypeCastApplierBuilder,
	#superclass : #EffectiveTypeCastApplierBuilder,
	#instVars : [
		'typesToCastTo',
		'typesToReject'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
IsKindOfManyTypeCastApplierBuilder class >> to: aTypesToCastTo rejecting: aTypesToRejet on: anObjectToCast during: aBlockToCastType rejectingDuring: aBlockToRejectType [ 

	^self new initializeTo: aTypesToCastTo rejecting: aTypesToRejet on: anObjectToCast during: aBlockToCastType rejectingDuring: aBlockToRejectType 
]

{ #category : #'building applier' }
IsKindOfManyTypeCastApplierBuilder >> buildCastApplierBefore: aPreviousCastingApplier [ 

	^EffectiveTypeCastApplier 
		casts: (OrderedCollection with: self buildTypeCast)
		rejections: OrderedCollection new
		previous: aPreviousCastingApplier
]

{ #category : #'building applier' }
IsKindOfManyTypeCastApplierBuilder >> buildRejectApplierBefore: aPreviousCastingApplier [

	^EffectiveTypeCastApplier 
		casts: OrderedCollection new
		rejections: (OrderedCollection with: self buildTypeReject)
		previous: aPreviousCastingApplier
]

{ #category : #'building cast' }
IsKindOfManyTypeCastApplierBuilder >> buildTypeCast [
		
	^ManyTypesCast to: typesToCastTo rejecting: typesToReject of: objectToCast
]

{ #category : #'building cast' }
IsKindOfManyTypeCastApplierBuilder >> buildTypeReject [

	^ManyTypesCast to: typesToReject rejecting: typesToCastTo of: objectToCast
]

{ #category : #initialization }
IsKindOfManyTypeCastApplierBuilder >> initializeTo: aTypesToCastTo rejecting: aTypesToRejet on: anObjectToCast during: aBlockToCastType rejectingDuring: aBlockToRejectType [ 

	typesToCastTo := aTypesToCastTo.
	typesToReject := aTypesToRejet.
	objectToCast := anObjectToCast.
	castingBlock := aBlockToCastType.
	rejectingBlock := aBlockToRejectType.
	self initializeAfterMessageTypeCasts 
	
]
