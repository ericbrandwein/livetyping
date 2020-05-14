Class {
	#name : #EqualsTypeCastApplierBuilder,
	#superclass : #OneTypeCastApplierBuilder,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'building applier' }
EqualsTypeCastApplierBuilder >> buildCastApplierBefore: aPreviousCastingApplier [ 
	
	 ^EffectiveTypeCastApplier 
		casts: (OrderedCollection with: self buildTypeCast)
		rejections: OrderedCollection new
		previous: aPreviousCastingApplier
]

{ #category : #'building applier' }
EqualsTypeCastApplierBuilder >> buildRejectApplierBefore: aPreviousCastingApplier [
	
	 ^EffectiveTypeCastApplier 
		casts: OrderedCollection new
		rejections: (OrderedCollection with: self buildTypeReject)
		previous: aPreviousCastingApplier
]

{ #category : #'building cast' }
EqualsTypeCastApplierBuilder >> buildTypeCast [
		
	^EqualTypeCast to: castType of: objectToCast
]

{ #category : #'building cast' }
EqualsTypeCastApplierBuilder >> buildTypeReject [
		
	^EqualTypeReject to: castType of: objectToCast
]
