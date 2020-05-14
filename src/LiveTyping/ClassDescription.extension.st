Extension { #name : #ClassDescription }

{ #category : #'*LiveTyping-unload-private' }
ClassDescription >> allRawTypesUnload: aClassToUnload [ 
	
	self
		instanceVariablesRawTypesUnload: aClassToUnload;
		methodsAllRawTypesUnload: aClassToUnload 

]

{ #category : #'*LiveTyping-private' }
ClassDescription >> allSubclassesImplementationsReturnTypesOf: aCompiledMethod [
	
	^(self allSubclasses 
		inject: Set new 
		into: [ :types :subclass | 
			types addAll: (subclass returnTypesAt: aCompiledMethod selector ifAbsent: [ #() ]). 
			types ]) asArray
]

{ #category : #'*LiveTyping' }
ClassDescription >> asTypeFor: aReceiverType [

	^self
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSelectorsOfInstanceVariableNamed: anInstVarName [

	^(self instanceVariablesTypes typeInfoOf: anInstVarName) commonSelectors 	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSelectorsOfInstanceVariableNamed: anInstVarName previousTo: aSuperclassToExclude [

	^(self instanceVariablesTypes typeInfoOf: anInstVarName) commonSelectorsPreviousTo: aSuperclassToExclude	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSelectorsOfInstanceVariableNamedPreviousToObject: anInstVarName [ 

	^(self instanceVariablesTypes typeInfoOf: anInstVarName) commonSelectorsPreviousToObject
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSelectorsOfMethodVariableNamed: aVarName at: aSelector [

	^(self typeInfoOfMethodVariableNamed: aVarName at: aSelector) commonSelectors 	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSelectorsOfMethodVariableNamed: aVarName at: aSelector previousTo: aSuperclassToExclude [

	^(self typeInfoOfMethodVariableNamed: aVarName at: aSelector) commonSelectorsPreviousTo: aSuperclassToExclude	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSelectorsOfMethodVariableNamedPreviousToObject: aVarName at: aSelector [

	^(self typeInfoOfMethodVariableNamed: aVarName at: aSelector) commonSelectorsPreviousToObject
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSupertypeOfInstanceVariableNamed: anInstVarName [

	^(self instanceVariablesTypes typeInfoOf: anInstVarName) commonSupertype 	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSupertypeOfInstanceVariableNamed: anInstVarName ifNoTypes: aBlock [

	^(self instanceVariablesTypes typeInfoOf: anInstVarName) commonSupertypeIfNoTypes: aBlock 	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSupertypeOfMethodVariableNamed: aVarName at: aSelector [

	^(self typeInfoOfMethodVariableNamed: aVarName at: aSelector) commonSupertype 	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> commonSupertypeOfMethodVariableNamed: aVarName at: aSelector ifNoTypes: aBlock [

	^(self typeInfoOfMethodVariableNamed: aVarName at: aSelector) commonSupertypeIfNoTypes: aBlock 	
	
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createHierarchyInstanceVariableTypeInfoOf: anInstVarName with: types [

	^HierarchyInstanceVariableTypeInfo of: anInstVarName in: self are: types
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createInstanceVariableRawTypesFor: anInstVarName [

	^self createRawTypesOfSize: (self instanceVariableRawTypesSizeFor: anInstVarName).
	
	
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createInstanceVariablesRawTypes [

	^ Array new: self instSize.
	
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createLocalInstanceVariableTypeInfoOf: anInstVarName with: types [

	^LocalInstanceVariableTypeInfo of: anInstVarName in: self are: types
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createMethodReturnRawTypesOf: aMethod [
		
	aMethod isQuickReturnSelf ifTrue: [ ^nil ].
	aMethod isReturnSpecial ifTrue: [ ^nil ].
	
	^self createRawTypesOfSize: (self methodReturnRawTypesSizeOf: aMethod) 
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createMethodReturnTypeInfoOf: aCompiledMethod [

	aCompiledMethod isReturnField ifTrue: [ 
		^ReturnTypeInfo of: aCompiledMethod are: (aCompiledMethod methodClass typesOfInstanceVariableAt: aCompiledMethod returnField + 1) asArray ].
	aCompiledMethod isQuickReturnSelf ifTrue: [ 
		^ReturnTypeInfo of: aCompiledMethod are: { SelfType new } ].
	aCompiledMethod isReturnSpecial ifTrue: [ 
		^ReturnTypeInfo 
			of: aCompiledMethod 
			are:  ({{true class}. {false class}. {nil class}. {-1 class}. {0 class}. {1 class}. {2 class}} at: aCompiledMethod primitive - 256) ].
	aCompiledMethod isAbstract ifTrue: [
		^ReturnTypeInfo of: aCompiledMethod are: (self allSubclassesImplementationsReturnTypesOf: aCompiledMethod) ].
		
	^ ReturnTypeInfo of: aCompiledMethod 
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createMethodVariableRawTypesFor: varName in: method [

	^ self createRawTypesOfSize: (self methodVariableRawTypesSizeFor: varName in: method)

]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createMethodVariableTypeInfoOf: aVarName in: method are: types [ 

	^ MethodVariableTypeInfo of: aVarName in: method are: types 
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> createRawTypesOfSize: aSize [
	
	^aSize = 0 ifTrue: [ nil ] ifFalse: [ Array new: aSize ]

]

{ #category : #'*LiveTyping-private' }
ClassDescription >> defaultRawTypesSize [

	^10
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> initializeEachInstanceVariableRawTypes [

	self instanceVariablesTypes initializeEachInstanceVariableRawTypes	
]

{ #category : #'*LiveTyping' }
ClassDescription >> initializeInstanceVariablesRawTypes [

	"
	self initializeInstanceVariablesTypes
	"
	
	instanceVariablesRawTypes := self createInstanceVariablesRawTypes.
	self initializeEachInstanceVariableRawTypes
		
]

{ #category : #'*LiveTyping' }
ClassDescription >> initializeInstanceVariablesRawTypesWithAllInstances [

	"
	self initializeInstanceVariablesTypes
	"
	
	self 
		initializeInstanceVariablesRawTypes;
		storeAllInstancesCurrentTypes
]

{ #category : #'*LiveTyping' }
ClassDescription >> initializeTypeInformation [

	self 
		initializeInstanceVariablesRawTypes;
		initializeMethodsTypeInformation 
]

{ #category : #'*LiveTyping' }
ClassDescription >> initializeTypeInformationWithAllInstances [

	self 
		initializeTypeInformation;
		storeAllInstancesCurrentTypes
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> instanceVariableRawTypesSizeFor: anInstVarName [

	^self defaultRawTypesSize 
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> instanceVariablesRawTypes [
	
	^ instanceVariablesRawTypes 
]

{ #category : #'*LiveTyping-unload-private' }
ClassDescription >> instanceVariablesRawTypesUnload: aClassToUnload [ 
	
	InstanceVariablesTypes unload: aClassToUnload fromAllRawTypesOf: instanceVariablesRawTypes
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> instanceVariablesTypes [

	^InstanceVariablesTypes of: self
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> methodReturnRawTypesSizeOf: aMethod [

	^ aMethod isReturnField 
		ifTrue: [ 0 ]
		ifFalse: [ self defaultRawTypesSize ]
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> methodVariableRawTypesSizeFor: varName in: method [

	^self defaultRawTypesSize 


]

{ #category : #'*LiveTyping' }
ClassDescription >> methodVariablesTypesAt: aSelector [

	^(self compiledMethodAt: aSelector) methodVariablesTypes 
]

{ #category : #'*LiveTyping-unload-private' }
ClassDescription >> methodsAllRawTypesUnload: aClassToUnload [ 
	
	self methodsDo: [ :aCompiledMethod | aCompiledMethod allRawTypesUnload: aClassToUnload ]
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> printInstanceVariablesTypesOn: aStream [

	^ self instanceVariablesTypes printVariablesTypesOn: aStream
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnCommonSelectorsAt: aSelector [

	^(self returnTypeInfoAt: aSelector) commonSelectors 
	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnCommonSelectorsAt: aSelector previousTo: aSuperclassToExclude [

	^(self returnTypeInfoAt: aSelector) commonSelectorsPreviousTo: aSuperclassToExclude
	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnCommonSelectorsPreviousToObjectAt: aSelector [ 

	^(self returnTypeInfoAt: aSelector) commonSelectorsPreviousToObject 
	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnCommonSupertypeAt: aSelector [

	^(self returnTypeInfoAt: aSelector) commonSupertype 
	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnCommonSupertypeAt: aSelector ifNoTypes: aBlock [

	^(self returnTypeInfoAt: aSelector) commonSupertypeIfNoTypes: aBlock 
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnTypeInfoAt: aSelector [

	^(self compiledMethodAt: aSelector) returnTypeInfo 
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnTypeInfoAt: aSelector ifAbsent: anAbsentBlock [
 
	^self 
		compiledMethodAt: aSelector
		ifPresent: [:aCompiledMethod | aCompiledMethod returnTypeInfo ]
		ifAbsent: anAbsentBlock 
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnTypeInfoAt: aSelector ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
 
	^self 
		compiledMethodAt: aSelector
		ifPresent: [:aCompiledMethod | aPresentBlock value: aCompiledMethod returnTypeInfo ]
		ifAbsent: anAbsentBlock 
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnTypesAt: aSelector [

	^(self returnTypeInfoAt: aSelector) types 
	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> returnTypesAt: aSelector ifAbsent: anAbsentBlock [
 
	^self 
		returnTypeInfoAt: aSelector
		ifPresent: [ :aReturnTypeInfo | aReturnTypeInfo types ]
		ifAbsent: anAbsentBlock
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> storeAllInstancesCurrentTypes [

	self instanceVariablesTypes storeAllInstancesCurrentTypes
]

{ #category : #'*LiveTyping' }
ClassDescription >> typeInfoOfInstanceVariableNamed: anInstVarName [

	^self instanceVariablesTypes typeInfoOf: anInstVarName 
]

{ #category : #'*LiveTyping' }
ClassDescription >> typeInfoOfInstanceVariableNamed: anInstVarName ifAbsent: aBlock [

	^self instanceVariablesTypes typeInfoOf: anInstVarName ifAbsent: aBlock
]

{ #category : #'*LiveTyping' }
ClassDescription >> typeInfoOfMethodVariableNamed: aVarName at: aSelector [

	^(self methodVariablesTypesAt: aSelector) typeInfoOf: aVarName
]

{ #category : #'*LiveTyping-private' }
ClassDescription >> typedDefinition [

	^String streamContents: [ :stream |
		stream nextPutAll: self definition.
		self printInstanceVariablesTypesOn: stream]
]

{ #category : #'*LiveTyping' }
ClassDescription >> typesOfInstanceVariableAt: anIndex [

	^self typesOfInstanceVariableNamed: (self allInstVarNames at: anIndex)
]

{ #category : #'*LiveTyping' }
ClassDescription >> typesOfInstanceVariableNamed: anInstVarName [

	^(self instanceVariablesTypes typeInfoOf: anInstVarName) types 	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> typesOfInstanceVariableNamed: anInstVarName ifAbsent: aBlock [

	^(self instanceVariablesTypes typeInfoOf: anInstVarName ifAbsent: [ ^aBlock value ]) types 	
	
]

{ #category : #'*LiveTyping' }
ClassDescription >> typesOfMethodVariableNamed: aVarName at: aSelector [

	^(self typeInfoOfMethodVariableNamed: aVarName at: aSelector) types 	
	
]
