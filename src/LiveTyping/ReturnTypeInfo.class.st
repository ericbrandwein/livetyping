Class {
	#name : #ReturnTypeInfo,
	#superclass : #VariableTypeInfo,
	#instVars : [
		'method'
	],
	#category : #LiveTyping
}

{ #category : #statistics }
ReturnTypeInfo class >> numberOfRawTypesForAll [

	"
	self numberOfRawTypesForAll
	"
	
	| numberOfTypes |
	
	numberOfTypes := Bag new.
	[ ProtoObject withAllSubclassesDo: [ :aClass | 
		aClass methodsDo: [ :aMethod | numberOfTypes add: (ReturnTypeInfo of: aMethod) typesSize ]]]
		on: MethodNotAnnotatingTypes
		do: [ :anError | anError resume: (AdditionalMethodState forMethod: anError method selector: anError method selector) ].
	
	^numberOfTypes contents
]

{ #category : #'instance creation' }
ReturnTypeInfo class >> of: aCompiledMethod [ 
	
	^self of: aCompiledMethod are: aCompiledMethod returnRawTypes
]

{ #category : #'instance creation' }
ReturnTypeInfo class >> of: aCompiledMethod are: aRawTypes [
	
	^self new initializeOf: aCompiledMethod are: aRawTypes 
]

{ #category : #statistics }
ReturnTypeInfo class >> percentangeOfUsedRawTypes [

	^VariablesTypes percentangeOfUsedRawTypesOf: self 
]

{ #category : #identification }
ReturnTypeInfo >> identifier [

	^method -> self variableName 
]

{ #category : #initialization }
ReturnTypeInfo >> initializeOf: aCompiledMethod are: aRawTypes [  
	
	method := aCompiledMethod.
	self initializeRawTypes: aRawTypes 
]

{ #category : #identification }
ReturnTypeInfo >> variableName [

	^'^'
]
