Extension { #name : #Boolean }

{ #category : #'*LiveTyping' }
Boolean class >> createMethodReturnRawTypesOf: aMethod [

	(#(and: or: not eqv: xor: | &) includes: aMethod selector) ifTrue: [ ^nil ].

	^super createMethodReturnRawTypesOf: aMethod 
]

{ #category : #'*LiveTyping' }
Boolean class >> createMethodReturnTypeInfoOf: aMethod [

	(#(and: or: not eqv: xor: | &) includes: aMethod selector) ifTrue: [ ^ ReturnTypeInfo of: aMethod are: {True. False.} ].

	^super createMethodReturnTypeInfoOf: aMethod 
]
