Class {
	#name : #MethodVariablesTypes,
	#superclass : #VariablesTypes,
	#instVars : [
		'method',
		'methodProperties'
	],
	#category : #LiveTyping
}

{ #category : #initialization }
MethodVariablesTypes class >> initializeForAllClasses [

	"
	self initializeForAllClasses.
	"
	ProtoObject withAllSubclassesDo: [ :aClass | aClass initializeMethodsTypeInformation ]
]

{ #category : #statistics }
MethodVariablesTypes class >> numberOfRawTypesForAll [

	"
	self numberOfRawTypesForAll
	"
	
	| numberOfTypes |
	
	numberOfTypes := Bag new.
	[ ProtoObject withAllSubclassesDo: [ :aClass | 
		self of: aClass do: [ :aVariablesTypesOrNil | aVariablesTypesOrNil ifNotNil: [ aVariablesTypesOrNil addNumberOfRawTypesTo: numberOfTypes ]]]]
		on: MethodNotAnnotatingTypes
		do: [ :anError | anError resume: (AdditionalMethodState forMethod: anError method selector: anError method selector) ].
	
	^numberOfTypes contents
]

{ #category : #'instance creation' }
MethodVariablesTypes class >> of: aCompiledMethod [

	^self new initializeOf: aCompiledMethod with: aCompiledMethod typeAnnotationsHolder
]

{ #category : #enumeration }
MethodVariablesTypes class >> of: aClass do: aBlock [

	aClass methodsDo: [ :aCompiledMethod | 
		[ aBlock value: aCompiledMethod methodVariablesTypes ]
			on: MethodNotAnnotatingTypes 
			do: [ :error | ]]
]

{ #category : #printing }
MethodVariablesTypes class >> printTypesInfoHeaderOn: aStream [

	aStream 
		newLine;
		nextPutAll: '"Type info:';
		newLine.	
		
]

{ #category : #types }
MethodVariablesTypes class >> unload: aClassToUnload from: aRawTypes [ 

	MethodVariableTypeInfo unload: aClassToUnload from: aRawTypes 
]

{ #category : #'collect info' }
MethodVariablesTypes >> addNumberOfRawTypesTo: aBagCollector [

	self typesInfoDo: [ :aTypeInfo |  aBagCollector add: aTypeInfo typesSize ]
	
]

{ #category : #initialization }
MethodVariablesTypes >> initializeOf: aCompiledMethod with: aMethodProperties [

	method := aCompiledMethod.
	methodProperties := aMethodProperties 

]

{ #category : #types }
MethodVariablesTypes >> typeInfoOf: aVarName ifAbsent: anAbsentBlock [

	| rawTypes |
	
	rawTypes := methodProperties rawTypesOf: aVarName ifAbsent: [ ^anAbsentBlock value ].
	
	^method methodClass createMethodVariableTypeInfoOf: aVarName in: method are: rawTypes 
]

{ #category : #types }
MethodVariablesTypes >> typesInfoDo: aBlock [
	
	self variablesNamesDo: [ :aVarName | aBlock value: (self typeInfoOf: aVarName ifAbsent: [ self error: 'should not happen' ])]
]

{ #category : #types }
MethodVariablesTypes >> typesInfoSize [
	
	methodProperties numberOfVariables
]

{ #category : #'variable names' }
MethodVariablesTypes >> variablesNames [

	^methodProperties variablesNames
]

{ #category : #'variable names' }
MethodVariablesTypes >> variablesNamesDo: aBlock [

	^ methodProperties variablesNamesDo: aBlock
]
