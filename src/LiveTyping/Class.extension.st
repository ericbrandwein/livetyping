Extension { #name : #Class }

{ #category : #'*LiveTyping' }
Class >> isSubclassesEmpty [

	^subclasses isNil 
]

{ #category : #'*LiveTyping' }
Class >> unloadFromAllRawTypes [

	ProtoObject withAllSubclassesDo: [ :aClass | self unloadFromAllRawTypesOf: aClass ] 

]

{ #category : #'*LiveTyping' }
Class >> unloadFromAllRawTypesOf: aClass [

	aClass allRawTypesUnload: self
]
