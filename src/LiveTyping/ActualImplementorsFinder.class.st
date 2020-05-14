Class {
	#name : #ActualImplementorsFinder,
	#superclass : #Object,
	#instVars : [
		'selector',
		'types',
		'notImplemented',
		'implementors'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
ActualImplementorsFinder class >> of: aSelector forAll: aTypes [

	^self new initializeOf: aSelector forAll: aTypes
]

{ #category : #printing }
ActualImplementorsFinder >> finderTypeString [
	
	self subclassResponsibility 
]

{ #category : #implementors }
ActualImplementorsFinder >> implementorsIsEmpty [
	
	^implementors isEmpty 
]

{ #category : #implementors }
ActualImplementorsFinder >> implementorsSize [
	
	^implementors size
]

{ #category : #implementors }
ActualImplementorsFinder >> implementorsSorted [
	
	^implementors asArray sort
]

{ #category : #initialization }
ActualImplementorsFinder >> initializeOf: aSelector forAll: aTypes [

	selector := aSelector.
	types := aTypes
]

{ #category : #'not implemented' }
ActualImplementorsFinder >> notImplemented [
	
	^notImplemented
]

{ #category : #'not implemented' }
ActualImplementorsFinder >> notImplementedIsEmpty [
	
	^notImplemented isEmpty 
]

{ #category : #'not implemented' }
ActualImplementorsFinder >> notImplementedSize [
	
	^notImplemented size
]

{ #category : #'not implemented' }
ActualImplementorsFinder >> notImplementedSorted [
	
	^notImplemented sort 
]

{ #category : #selector }
ActualImplementorsFinder >> selector [
	
	^selector 
]

{ #category : #implementors }
ActualImplementorsFinder >> totalSize [
	
	^self implementorsSize + self notImplementedSize
]

{ #category : #types }
ActualImplementorsFinder >> types [
	
	^types
]

{ #category : #evaluating }
ActualImplementorsFinder >> value [

	self subclassResponsibility 
]
