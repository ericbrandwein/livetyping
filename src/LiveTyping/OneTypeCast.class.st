Class {
	#name : #OneTypeCast,
	#superclass : #TypeCast,
	#instVars : [
		'typeToCastTo'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
OneTypeCast class >> to: aTypeToCastTo of: anObjectToCast [

	^self new initializeTo: aTypeToCastTo of: anObjectToCast
]

{ #category : #initialization }
OneTypeCast >> initializeTo: aTypeToCastTo of: anObjectToCast [

	typeToCastTo := aTypeToCastTo.
	objetToCast := anObjectToCast 
]
