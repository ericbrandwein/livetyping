Class {
	#name : #OneTypeCastApplierBuilder,
	#superclass : #EffectiveTypeCastApplierBuilder,
	#instVars : [
		'castType'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
OneTypeCastApplierBuilder class >> to: aClass on: anObject during: aBlockToCastType [ 
	
	^self to: aClass on: anObject during: aBlockToCastType rejectingDuring: BlockNode empty
	
]

{ #category : #'instance creation' }
OneTypeCastApplierBuilder class >> to: aType on: anObjectToCast during: aBlockToCastType rejectingDuring: aBlockToRejectType [ 

	^self new initializeTo: aType on: anObjectToCast during: aBlockToCastType rejectingDuring: aBlockToRejectType 
]

{ #category : #'instance creation' }
OneTypeCastApplierBuilder class >> toUndefinedObjectOn: anObjectToCast during: aBlockToCastType [ 
	
	^self to: UndefinedObject on: anObjectToCast during: aBlockToCastType rejectingDuring: BlockNode empty
]

{ #category : #'instance creation' }
OneTypeCastApplierBuilder class >> toUndefinedObjectOn: anObjectToCast during: aBlockToCastType rejectingDuring: aBlockToRejectType [ 
	
	^self to: UndefinedObject on: anObjectToCast during: aBlockToCastType rejectingDuring: aBlockToRejectType 
]

{ #category : #'instance creation' }
OneTypeCastApplierBuilder class >> toUndefinedObjectOn: anObjectToCast rejectingDuring: aBlockToRejectType [ 
	
	^self to: UndefinedObject on: anObjectToCast during: BlockNode empty rejectingDuring: aBlockToRejectType 
]

{ #category : #initialization }
OneTypeCastApplierBuilder >> initializeTo: aType on: anObjectToCast during: aBlockToCastType rejectingDuring: aBlockToRejectType [ 

	castType := aType .
	objectToCast := anObjectToCast.
	castingBlock := aBlockToCastType.
	rejectingBlock := aBlockToRejectType.
	self initializeAfterMessageTypeCasts.

]
