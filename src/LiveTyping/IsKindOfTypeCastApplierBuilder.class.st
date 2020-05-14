Class {
	#name : #IsKindOfTypeCastApplierBuilder,
	#superclass : #OneTypeCastApplierBuilder,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'building applier' }
IsKindOfTypeCastApplierBuilder >> buildCastApplierBefore: aPreviousCastingApplier [ 

	^EffectiveTypeCastApplier 
		casts: (OrderedCollection with: self buildTypeCast)
		rejections: OrderedCollection new
		previous: aPreviousCastingApplier
	
]

{ #category : #'building applier' }
IsKindOfTypeCastApplierBuilder >> buildRejectApplierBefore: aPreviousCastingApplier [

	^EffectiveTypeCastApplier 
		casts: OrderedCollection new
		rejections: (OrderedCollection with: self buildTypeReject)
		previous: aPreviousCastingApplier
	
]

{ #category : #'building cast' }
IsKindOfTypeCastApplierBuilder >> buildTypeCast [
	
	^IsKindOfTypeCast to: castType of: objectToCast
]

{ #category : #'building cast' }
IsKindOfTypeCastApplierBuilder >> buildTypeReject [
	
	^IsKindOfTypeReject to: castType of: objectToCast
]
