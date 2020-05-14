Class {
	#name : #AllActualImplementors,
	#superclass : #ActualImplementorsFinder,
	#category : #LiveTyping
}

{ #category : #printing }
AllActualImplementors >> finderTypeString [
	
	^'Actual'
]

{ #category : #evaluating }
AllActualImplementors >> value [ 

	| typeImplementors |
	
	notImplemented := OrderedCollection new.
	implementors := Set new.
	types do: [ :aType | 
		typeImplementors := Smalltalk actualImplementorsOf: selector in: aType.
		typeImplementors isEmpty 
			ifTrue: [ notImplemented add: (NotImplementedMethod class: aType selector: selector) ]
			ifFalse: [ implementors addAll: typeImplementors ]].

	^self
]
