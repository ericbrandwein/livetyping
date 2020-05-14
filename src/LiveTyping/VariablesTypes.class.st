Class {
	#name : #VariablesTypes,
	#superclass : #Object,
	#category : #LiveTyping
}

{ #category : #statistics }
VariablesTypes class >> allMegamorphicVariables [

	"
	InstanceVariablesTypes allMegamorphicVariables
	MethodVariablesTypes allMegamorphicVariables
	"
	
	| allMegamorphicVariables |
	
	allMegamorphicVariables := OrderedCollection new.
	ProtoObject withAllSubclassesDo: [ :aClass | self of: aClass do: [ :aVariablesTypes | aVariablesTypes addMegamorphicVariablesTo: allMegamorphicVariables ]].
	
	^allMegamorphicVariables 
]

{ #category : #statistics }
VariablesTypes class >> allWithNoCommonSupertype [

	"
	InstanceVariablesTypes allWithNoCommonSupertype
	MethodVariablesTypes allWithNoCommonSupertype
	"
	
	| allWithNoCommonSupertype |
	
	allWithNoCommonSupertype := OrderedCollection new.
	ProtoObject withAllSubclassesDo: [ :aClass | self of: aClass do: [ :aVariablesTypes | aVariablesTypes addWithNoCommonSupertypeTo: allWithNoCommonSupertype ]].
			
	^allWithNoCommonSupertype 
	

]

{ #category : #statistics }
VariablesTypes class >> numberOfRawTypesForAll [

	self subclassResponsibility 
]

{ #category : #statistics }
VariablesTypes class >> numberOfTypesForAll [

	"
	InstanceVariablesTypes numberOfTypesForAll
	MethodVariablesTypes numberOfTypesForAll
	"
	
	| numberOfTypes |
	
	numberOfTypes := Bag new.
	ProtoObject withAllSubclassesDo: [ :aClass | self of: aClass do: [ :aVariablesTypes |  aVariablesTypes addTypesSizesTo: numberOfTypes ]].
	
	^numberOfTypes contents
]

{ #category : #enumeration }
VariablesTypes class >> of: aClass do: aBlock [

	self subclassResponsibility 
]

{ #category : #statistics }
VariablesTypes class >> percentangeOfUsedRawTypes [

	"
	InstanceVariablesTypes percentangeOfUsedRawTypes.
	MethodVariablesTypes percentangeOfUsedRawTypes.
	ReturnTypeInfo percentangeOfUsedRawTypes
	"

	^self percentangeOfUsedRawTypesOf: self 
]

{ #category : #statistics }
VariablesTypes class >> percentangeOfUsedRawTypesOf: aVariableTypesClass [

	| usedSlots numberOfRawTypesForAll |
	
	usedSlots := 0.
	numberOfRawTypesForAll := aVariableTypesClass numberOfRawTypesForAll.
	numberOfRawTypesForAll keysAndValuesDo: [ :size :time | usedSlots := usedSlots + (size*time) ].
	
	^(usedSlots/(numberOfRawTypesForAll sum * ClassDescription defaultRawTypesSize)) asFloat.
]

{ #category : #printing }
VariablesTypes class >> printTypesInfoHeaderOn: aStream [

	self subclassResponsibility 
]

{ #category : #printing }
VariablesTypes class >> typesInfoHeader [
		
	^String streamContents: [ :stream | self printTypesInfoHeaderOn: stream ]
]

{ #category : #types }
VariablesTypes class >> unload: aClassToUnload from: aRawTypes [ 

	self subclassResponsibility 
]

{ #category : #types }
VariablesTypes class >> unload: aClassToUnload fromAllRawTypesOf: aVariablesRawTypes [

	aVariablesRawTypes ifNotNil: [ 
		aVariablesRawTypes do: [ :aRawTypes | self unload: aClassToUnload from: aRawTypes ]]
	
]

{ #category : #'collect info' }
VariablesTypes >> addMegamorphicVariablesTo: allMegamorphicVariables [
	
	self typesInfoDo: [ :aVarTypeInfo | aVarTypeInfo ifMegamorphicAddTo: allMegamorphicVariables ]
		
]

{ #category : #'collect info' }
VariablesTypes >> addTypesSizesTo: aBagCollector [

	self typesInfoDo: [ :aVarTypeInfo | aBagCollector add: aVarTypeInfo typesSize ]
]

{ #category : #'collect info' }
VariablesTypes >> addWithNoCommonSupertypeTo: allWithNoCommonSupertype [

	self typesInfoDo: [ :aVarTypeInfo | aVarTypeInfo addIfNoCommonSupertypeTo: allWithNoCommonSupertype ]
]

{ #category : #'common selectors' }
VariablesTypes >> commonSelectorsOf: aVarName [

	"
	SimpleMeasure instanceVariablesTypes commonSelectorsOf: 'unit'.
	SimpleMeasure instanceVariablesTypes commonSelectorsOf: 'amount'.
	"
	^ (self typeInfoOf: aVarName) commonSelectors 
]

{ #category : #'common selectors' }
VariablesTypes >> commonSelectorsOf: aVarName previoustTo:  aSuperclass [

	"
	SimpleMeasure instanceVariablesTypes commonSelectorsOf: 'unit' previousTo: Object
	SimpleMeasure instanceVariablesTypes commonSelectorsOf: 'amount' previousTo: Number
	"
	^ (self typeInfoOf: aVarName) commonSelectorsPreviousTo: aSuperclass 
]

{ #category : #'common supertype' }
VariablesTypes >> commonSupertypeOf: aVarName [

	"
	SimpleMeasure instanceVariablesTypes commonSupertypeOf: 'unit'.
	SimpleMeasure instanceVariablesTypes commonSupertypeOf: 'amount'.
	"
	^ (self typeInfoOf: aVarName) commonSupertype 
]

{ #category : #'common supertype' }
VariablesTypes >> commonSupertypeOf: aVarName ifNoTypes: aBlock [

	^ (self typeInfoOf: aVarName) commonSupertypeIfNoTypes: aBlock
]

{ #category : #types }
VariablesTypes >> localTypesInfoDo: aBlock [

	self subclassResponsibility 
]

{ #category : #printing }
VariablesTypes >> printReducedTypesOf: aVarName ifAbsent: anAbsentBlock [

	| typeInfo |
	
	typeInfo := self typeInfoOf: aVarName ifAbsent: [ ^anAbsentBlock value ].
	
	^typeInfo printReducedTypes 
]

{ #category : #printing }
VariablesTypes >> printTypeInfo: typeInfo on: aStream [
	
	aStream 
		print: typeInfo;
		newLine
]

{ #category : #printing }
VariablesTypes >> printTypesInfoFooterOn: aStream [ 

	aStream nextPut: $" 
]

{ #category : #printing }
VariablesTypes >> printTypesInfoHeaderOn: aStream [
	
	self class printTypesInfoHeaderOn: aStream
	
]

{ #category : #printing }
VariablesTypes >> printTypesInfoOn: aStream [
	
	self typesInfoDo: [ :typeInfo | self printTypeInfo: typeInfo on: aStream ].
	
]

{ #category : #printing }
VariablesTypes >> printVariablesTypesOn: aStream [

	self typesInfoNotEmpty ifTrue: [
		self printTypesInfoHeaderOn: aStream.
		self printTypesInfoOn: aStream.
		self printTypesInfoFooterOn: aStream ]
]

{ #category : #types }
VariablesTypes >> typeInfoOf: aVarName [

	^self typeInfoOf: aVarName ifAbsent: [ self error: 'Invalid variable name' ].
	
]

{ #category : #types }
VariablesTypes >> typeInfoOf: aVarName ifAbsent: anAbsentBlock [

	self subclassResponsibility 
]

{ #category : #types }
VariablesTypes >> typesInfoDo: aBlock [
	
	self subclassResponsibility 
]

{ #category : #types }
VariablesTypes >> typesInfoIsEmpty [
	
	^self typesInfoSize = 0
]

{ #category : #types }
VariablesTypes >> typesInfoNotEmpty [
	
	^self typesInfoIsEmpty not
]

{ #category : #types }
VariablesTypes >> typesInfoSize [
	
	self subclassResponsibility 
]

{ #category : #types }
VariablesTypes >> typesOf: aVarName [

	^(self typeInfoOf: aVarName) types
]

{ #category : #types }
VariablesTypes >> typesOf: aVarName ifAbsent: aBlock [

	| varTypeInfo |
	
	varTypeInfo := self typeInfoOf: aVarName ifAbsent: [ ^aBlock value ].
	
	^varTypeInfo types
]

{ #category : #'variable names' }
VariablesTypes >> variablesNames [
	
	self subclassResponsibility.
]
