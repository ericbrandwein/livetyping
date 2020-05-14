Extension { #name : #Number }

{ #category : #'*LiveTyping' }
Number class >> createMethodReturnRawTypesOf: aMethod [

	^(aMethod selector = #@ and: [ aMethod methodClass = Number ]) 
		ifTrue: [ nil ]
		ifFalse: [ super createMethodReturnRawTypesOf: aMethod ]
]

{ #category : #'*LiveTyping' }
Number class >> createMethodReturnTypeInfoOf: aMethod [

	^(aMethod selector = #@ and: [ aMethod methodClass = Number ]) 
		ifTrue: [ ReturnTypeInfo of: aMethod are: { Point } ]
		ifFalse: [ super createMethodReturnTypeInfoOf: aMethod ]
]
