Extension { #name : #UndefinedObject }

{ #category : #'*LiveTyping' }
UndefinedObject >> addType: aType ifFull: aFullBlock [

	^aFullBlock value.
]

{ #category : #'*LiveTyping' }
UndefinedObject >> annotateTypeOf: aValue at: anIndex [ 
]

{ #category : #'*LiveTyping' }
UndefinedObject >> doesStoreTypes [

	^false
]

{ #category : #'*LiveTyping' }
UndefinedObject >> includesNil [
	
	^false
]

{ #category : #'*LiveTyping' }
UndefinedObject >> isMegamorphic [
	
	^false
]

{ #category : #'*LiveTyping' }
UndefinedObject >> isTypesEmpty [
	
	^true
]

{ #category : #'*LiveTyping' }
UndefinedObject >> removeAllTypes [
	
	
]

{ #category : #'*LiveTyping' }
UndefinedObject >> removeType: aType ifAbsent: anAbsentBlock [

	^anAbsentBlock value 
]

{ #category : #'*LiveTyping' }
UndefinedObject >> types [
	
	^#()
]

{ #category : #'*LiveTyping' }
UndefinedObject >> typesSize [
	
	^0 
]
