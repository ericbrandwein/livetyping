Extension { #name : #Object }

{ #category : #'*LiveTyping' }
Object class >> createMethodReturnRawTypesOf: aMethod [

	^ (#(class at: copy shallowCopy) includes: aMethod selector)
		ifTrue: [ nil ]
		ifFalse: [ super createMethodReturnRawTypesOf: aMethod ]

]

{ #category : #'*LiveTyping' }
Object class >> createMethodReturnTypeInfoOf: aMethod [

	aMethod selector = #class ifTrue: [ ^ReturnTypeInfo of: aMethod are: { ClassType new } ].
	aMethod selector = #at: ifTrue: [ ^ReturnTypeInfo of: aMethod are: { Object } ].
	(#(copy shallowCopy) includes: aMethod selector) ifTrue: [ ^ReturnTypeInfo of: aMethod are: { SelfType new} ].
	
	^super createMethodReturnTypeInfoOf: aMethod 

]
