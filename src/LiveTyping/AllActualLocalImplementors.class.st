Class {
	#name : #AllActualLocalImplementors,
	#superclass : #ActualImplementorsFinder,
	#category : #LiveTyping
}

{ #category : #printng }
AllActualLocalImplementors >> finderTypeString [
	
	^'Actual Local'
]

{ #category : #evaluating }
AllActualLocalImplementors >> value [
	
	notImplemented := OrderedCollection new.
	implementors := types 
		inject: IdentitySet new
		into: [ :methods :aClass | 
			(aClass lookupSelector: selector ) 
				ifNil: [ notImplemented add: (NotImplementedMethod class: aClass selector: selector ) ]
				ifNotNil: [ :method | methods add: method ].
			methods ].

	implementors := implementors collect: [ :method | method asMethodReference ].
	
	^self 

]
