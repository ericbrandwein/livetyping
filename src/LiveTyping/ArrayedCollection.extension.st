Extension { #name : #ArrayedCollection }

{ #category : #'*LiveTyping' }
ArrayedCollection class >> createMethodReturnRawTypesOf: aCompiledMethod [

	aCompiledMethod selector == #size ifTrue: [ ^nil ].
	
	^super createMethodReturnRawTypesOf: aCompiledMethod 
]

{ #category : #'*LiveTyping' }
ArrayedCollection class >> createMethodReturnTypeInfoOf: aCompiledMethod [

	aCompiledMethod selector == #size ifTrue: [ ^ ReturnTypeInfo of: aCompiledMethod are: { Integer }].
	
	^super createMethodReturnTypeInfoOf: aCompiledMethod 
]
