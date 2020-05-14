Extension { #name : #Array }

{ #category : #'*LiveTyping' }
Array >> addType: aType ifFull: aFullBlock [

	self withIndexDo: [ :typeAtIndex :rawTypesIndex |
		typeAtIndex = aType ifTrue: [ ^self ].
		typeAtIndex ifNil: [ ^self at: rawTypesIndex put: aType ]].
	
	^aFullBlock value.
]

{ #category : #'*LiveTyping' }
Array >> annotateTypeOf: aValue at: anIndex [

	| rawTypes |
	
	rawTypes := self at: anIndex ifAbsent: [^self].
	rawTypes addType: aValue class ifFull: []
]

{ #category : #'*LiveTyping' }
Array >> doesStoreTypes [

	^true
]

{ #category : #'*LiveTyping' }
Array >> includesNil [
	
	^ self includes: UndefinedObject 
]

{ #category : #'*LiveTyping' }
Array >> isMegamorphic [
	
	^self last notNil 
		
]

{ #category : #'*LiveTyping' }
Array >> isTypesEmpty [
	
	^self isEmpty or: [self first isNil ]
]

{ #category : #'*LiveTyping' }
Array >> removeAllTypes [
	
	self atAllPut: nil
]

{ #category : #'*LiveTyping' }
Array >> removeType: aType ifAbsent: anAbsentBlock [

	| typeIndex |
	
	typeIndex := self indexOf: aType ifAbsent: [ ^anAbsentBlock value ].
	
	self replaceFrom: typeIndex to: self size - 1 with: self startingAt: typeIndex + 1.
	self at: self size put: nil
]

{ #category : #'*LiveTyping' }
Array >> types [
	
	| firstEmptyIndex |
	
	firstEmptyIndex := self indexOf: nil ifAbsent: [^ self copy ].
	firstEmptyIndex = 1 ifTrue: [ ^#() ].
	
	^self copyFrom: 1 to: firstEmptyIndex-1 	
]

{ #category : #'*LiveTyping' }
Array >> typesSize [
	
	| firstIndexOfNil |
	
	firstIndexOfNil := self indexOf: nil ifAbsent: [ ^self size ].
	
	^firstIndexOfNil - 1
]
