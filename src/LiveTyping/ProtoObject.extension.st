Extension { #name : #ProtoObject }

{ #category : #'*LiveTyping-private' }
ProtoObject class >> createMethodReturnRawTypesOf: aCompiledMethod [ 
	
	^aCompiledMethod selector = #== 
		ifTrue: [ nil ]
		ifFalse: [ super createMethodReturnRawTypesOf: aCompiledMethod ]
]

{ #category : #'*LiveTyping-private' }
ProtoObject class >> createMethodReturnTypeInfoOf: aMethod [ 
	
	^aMethod selector = #== 
		ifTrue: [ ReturnTypeInfo of: aMethod are: {True. False.} ]
		ifFalse: [ super createMethodReturnTypeInfoOf: aMethod ]
]
