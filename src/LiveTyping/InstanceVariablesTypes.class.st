Class {
	#name : #InstanceVariablesTypes,
	#superclass : #VariablesTypes,
	#instVars : [
		'class',
		'rawTypes'
	],
	#category : #LiveTyping
}

{ #category : #initialization }
InstanceVariablesTypes class >> initializeForAllClasses [

	"
	self initializeForAllClasses.
	"

	ProtoObject withAllSubclassesDo: [ :aClass | aClass initializeInstanceVariablesRawTypes]
]

{ #category : #initialization }
InstanceVariablesTypes class >> initializeForAllClassesWithAllInstances [

	"
	self initializeForAllClassesWithAllInstances.
	"

	ProtoObject withAllSubclassesDo: [ :aClass | aClass initializeInstanceVariablesRawTypesWithAllInstances]
]

{ #category : #statistics }
InstanceVariablesTypes class >> numberOfRawTypesForAll [

	"
	self numberOfRawTypesForAll
	"
	
	| numberOfTypes |
	
	numberOfTypes := Bag new.
	ProtoObject withAllSubclassesDo: [ :aClass | self of: aClass do: [ :aVariablesTypes | aVariablesTypes addNumberOfRawTypesTo: numberOfTypes ]].
	
	^numberOfTypes contents
]

{ #category : #'instance creation' }
InstanceVariablesTypes class >> of: aClass [

	^self of: aClass rawTypes: aClass instanceVariablesRawTypes
]

{ #category : #enumeration }
InstanceVariablesTypes class >> of: aClass do: aBlock [

	aBlock value: aClass instanceVariablesTypes 
]

{ #category : #'instance creation' }
InstanceVariablesTypes class >> of: aClass rawTypes: rawTypes [

	^self new initializeOf: aClass rawTypes: rawTypes
]

{ #category : #printing }
InstanceVariablesTypes class >> printTypesInfoHeaderOn: aStream [

	aStream 
		newLine;
		nextPut: $";
		newLine.	
		
]

{ #category : #types }
InstanceVariablesTypes class >> unload: aClassToUnload from: aRawTypes [ 

	InstanceVariableTypeInfo unload: aClassToUnload from: aRawTypes 
]

{ #category : #'collect info' }
InstanceVariablesTypes >> addNumberOfRawTypesTo: aBagCollector [

	rawTypes ifNotNil: [ class allInstVarNames do: [ :anInstVarName | aBagCollector add: (self localTypeInfoOf: anInstVarName) typesSize ]]
]

{ #category : #'collect info' }
InstanceVariablesTypes >> addTypeInformationOf: anInstance using: instVarTypes [

	instVarTypes do: [ :anInstVarTypeInfo | anInstVarTypeInfo addTypeFrom: anInstance ]
	
]

{ #category : #testing }
InstanceVariablesTypes >> doesStoreTypes [
	
	^rawTypes notNil 
]

{ #category : #initialization }
InstanceVariablesTypes >> initializeEachInstanceVariableRawTypes [

	rawTypes ifNotNil: [ 
		class allInstVarNames withIndexDo: [ :instVarName :instVarIndex | rawTypes at: instVarIndex put: (class createInstanceVariableRawTypesFor: instVarName) ]]
]

{ #category : #initialization }
InstanceVariablesTypes >> initializeOf: aClass rawTypes: aRawTypes [
	
	class := aClass.
	rawTypes := aRawTypes.
	
]

{ #category : #types }
InstanceVariablesTypes >> localTypeInfoOf: anInstVarName [

	| instVarRawTypes |
	
	instVarRawTypes := self rawTypesOf: anInstVarName.
		
	^ class createLocalInstanceVariableTypeInfoOf: anInstVarName with: instVarRawTypes 
]

{ #category : #types }
InstanceVariablesTypes >> localTypesInfoDo: aBlock [
	
	self variablesNames do: [ :variableName | aBlock value: (self localTypeInfoOf: variableName) ]
]

{ #category : #megamorphic }
InstanceVariablesTypes >> megamorphicInstanceVariables [

	^ class allInstVarNames select: [ :anInstVarName | (self typeInfoOf: anInstVarName) isMegamorphic]
]

{ #category : #types }
InstanceVariablesTypes >> rawTypesOf: anInstVarName [

	| instVarIndex |
	
	instVarIndex := class indexOfInstanceVariable: anInstVarName ifAbsent: [ ^self error: anInstVarName, ' is not defined in ', class name, ' or its hierarchy' ].
	
	^(rawTypes isNil or: [ instVarIndex > rawTypes size ]) 
		ifTrue: [ nil ]
		ifFalse: [ rawTypes at: instVarIndex ].
	
]

{ #category : #initialization }
InstanceVariablesTypes >> storeAllInstancesCurrentTypes [

	| instVarTypes |
	
	rawTypes isNil ifTrue: [ ^self ].
	
	instVarTypes := class allInstVarNames collect: [ :anInstVarName | self localTypeInfoOf: anInstVarName ].
	class allInstancesDo: [ :anInstance | self addTypeInformationOf: anInstance using: instVarTypes ] 
	
]

{ #category : #types }
InstanceVariablesTypes >> typeInfoInHierarchyOf: anInstVarName [

	| instVarRawTypes |
	
	instVarRawTypes := self rawTypesOf: anInstVarName.
		
	^ class createHierarchyInstanceVariableTypeInfoOf: anInstVarName with: instVarRawTypes 
]

{ #category : #types }
InstanceVariablesTypes >> typeInfoOf: anInstVarName ifAbsent: anAbsentBlock [

	(class definesInstanceVariableNamedInHierarchy: anInstVarName) ifFalse:[ ^anAbsentBlock value ].
	
	^ self typeInfoInHierarchyOf: anInstVarName
]

{ #category : #types }
InstanceVariablesTypes >> typesInfoDo: aBlock [
	
	self variablesNames do: [ :variableName | aBlock value: (self typeInfoOf: variableName) ]
]

{ #category : #types }
InstanceVariablesTypes >> typesInfoSize [
	
	^self variablesNames size
]

{ #category : #'variable names' }
InstanceVariablesTypes >> variablesNames [

	^class instVarNames 
]
