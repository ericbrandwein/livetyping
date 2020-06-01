Extension { #name : #AdditionalMethodState }

{ #category : #'*LiveTyping' }
AdditionalMethodState >> add: variableRawTypes to: anArrayOfRawTypes mapping: variableName to: variableTypeIndex in: variableNameToIndex [
	
	"I abuse of the #at:ifAbsentPut: of OrderedCollection because I know that indexes do not repeat
	and doing so I do not have to calculate the size first - Hernan"
	anArrayOfRawTypes at: variableTypeIndex ifAbsentPut: [ variableRawTypes ].
	
	^variableNameToIndex at: variableName put: variableTypeIndex 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> allRawTypesUnload: aClassToUnload [

	self 
		variablesRawTypesUnload: aClassToUnload;
		returnRawTypesUnload: aClassToUnload 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> annotateRemoteTemporaryTypeOf: aValue at: anIndex [ 

	remoteVectorRawTypes annotateTypeOf: aValue at: anIndex 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> annotateReturnTypeOf: aValue [

	returnRawTypes addType: aValue class ifFull: []
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> annotateTemporaryTypeOf: aValue at: aTemporaryIndex [ 

	variablesRawTypes annotateTypeOf: aValue at: aTemporaryIndex 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> copyTypeInformationFrom: anotherAdditionalMethodState [

	variablesRawTypes := anotherAdditionalMethodState variablesRawTypes. 
	returnRawTypes := anotherAdditionalMethodState returnRawTypes. 
	remoteVectorRawTypes := anotherAdditionalMethodState remoteVectorRawTypes.
	variableNameToTypeIndex := anotherAdditionalMethodState variableNameToTypeIndex.
	variableNameToRemoteVectorTypeIndex := anotherAdditionalMethodState variableNameToRemoteVectorTypeIndex.
	
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> doesPointToLocalSlot: variableIndexOrRemoteVectorInfo [
	
	^variableIndexOrRemoteVectorInfo isInteger 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> doesPointToRemoteVector: variableIndexOrRemoteVectorInfo [
	
	^variableIndexOrRemoteVectorInfo isArray 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> doesTheMethodHasVariables [

	^method notNil and: [ method numTemps > 0 ]
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> initializeRawTypesOfVariableNamed: variableName at: variableIndexOrRemoteVectorInfo into: variablesTypes or: remoteVectorTypes with: argumentNames [

	 | variableRawTypes |

	variableRawTypes := method methodClass createMethodVariableRawTypesFor: variableName in: method.
	(self doesPointToLocalSlot: variableIndexOrRemoteVectorInfo) ifTrue: [ 
		^self initializeWith: variableRawTypes variableNamed: variableName at: variableIndexOrRemoteVectorInfo into: variablesTypes with: argumentNames ].
	(self doesPointToRemoteVector: variableIndexOrRemoteVectorInfo) ifTrue: [ 
		^self initializeWith: variableRawTypes variableNamed: variableName atRemoteVectorIndex: variableIndexOrRemoteVectorInfo into: remoteVectorTypes ].
		
	self error: 'variableIndexOrRemoteVectorInfo type not supported'
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> initializeReturnRawTypes [
	
	returnRawTypes := method 
		ifNil: [ nil ]
		ifNotNil: [ method methodClass createMethodReturnRawTypesOf: method ]
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> initializeTypeInformationUsing: aMethodNode [

	self initializeVariablesRawTypesUsing: aMethodNode.
	self initializeReturnRawTypes

]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> initializeVariablesRawTypesUsing: aMethodNode [

	self doesTheMethodHasVariables
		ifTrue: [ self initializeVariablesRawTypesWhenMethodHasVariablesUsing: aMethodNode ]
		ifFalse: [ self initializeVariablesRawTypesWhenMethodHasNoVariables ]


]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> initializeVariablesRawTypesWhenMethodHasNoVariables [ 

	"I use nil instead of emtpy array/dictionary to save memory space and VM speed. It is a tradeoff
	I do not like but necessary as implementation detail - Hernan"
	
	variablesRawTypes := nil.
	remoteVectorRawTypes := nil.
	variableNameToTypeIndex := nil.
	variableNameToRemoteVectorTypeIndex := nil

]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> initializeVariablesRawTypesWhenMethodHasVariablesUsing: aMethodNode [ 

	| argumentNames remoteVectorTypes variablesTypes |

	argumentNames := aMethodNode argumentNames.
	variablesTypes := OrderedCollection new.
	remoteVectorTypes := OrderedCollection new.
	
	variableNameToTypeIndex := Dictionary new.
	variableNameToRemoteVectorTypeIndex := Dictionary new.
	
	argumentNames, aMethodNode temporaryNames  doWithIndex: [ :aVarName :index |
		self 
			initializeRawTypesOfVariableNamed: aVarName
			at: index
			into: variablesTypes 
			or: remoteVectorTypes 
			with: argumentNames ].
	
	"aMethodNode topBlockTempsMap do: [ :aTempMap |
		self 
			initializeRawTypesOfVariableNamed: aTempMap first 
			at: aTempMap second 
			into: variablesTypes 
			or: remoteVectorTypes 
			with: argumentNames ]."
	
	"There is no need to add a slot for the remote vector because the VM
	takes cares of arrays of types arrays size - Hernan"	
	
	"If there are no variable rawTypes and var name to index are initialized with nil
	to save memory space and speedup the VM - Hernan"
	variablesTypes isEmpty 
		ifTrue: [ variablesRawTypes := variableNameToTypeIndex := nil ] 
		ifFalse: [ variablesRawTypes := variablesTypes asArray ].
		
	remoteVectorTypes isEmpty 
		ifTrue: [ remoteVectorRawTypes := variableNameToRemoteVectorTypeIndex := nil ] 
		ifFalse: [ remoteVectorRawTypes := remoteVectorTypes asArray ]

]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> initializeWith: variableRawTypes variableNamed: variableName at: variableIndex into: variablesTypes with: argumentNames [
	
	| variableTypeIndex |
	
	"Arguments are in reversed order in the stack, to make the VM faster I reverse the position in the types array
	to aligned it with the stack - Hernan"
	variableTypeIndex := (argumentNames includes: variableName)
		ifTrue: [ argumentNames size - variableIndex + 1 ]
		ifFalse: [ variableIndex ].
	
	self add: variableRawTypes to: variablesTypes mapping: variableName to: variableTypeIndex in: variableNameToTypeIndex
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> initializeWith: variableRawTypes variableNamed: variableName atRemoteVectorIndex: removeVectorVariableInfo into: remoteVectorTypes [
	
	| variableTypeIndex |
	
	"The first element of the array is the position of the remove vector in the context, the second
	is the index of the variable in the remove vector - Hernan"
	variableTypeIndex := removeVectorVariableInfo second.

	self add: variableRawTypes to: remoteVectorTypes mapping: variableName to: variableTypeIndex in: variableNameToRemoteVectorTypeIndex
	
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> numberOfVariables [

	^(self sizeOf: variablesRawTypes) + (self sizeOf: remoteVectorRawTypes)
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> rawTypesOf: aVariableName ifAbsent: anAbsentBlock [

	^ self 
		rawTypesOf: aVariableName 
		mappingToIndexWith: variableNameToTypeIndex 
		into: variablesRawTypes 
		ifAbsent: [ 
			self 
				rawTypesOf: aVariableName 
				mappingToIndexWith: variableNameToRemoteVectorTypeIndex 
				into: remoteVectorRawTypes 
				ifAbsent: anAbsentBlock ]

]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> rawTypesOf: aVariableName mappingToIndexWith: variableNameToIndexMapping into: anArrayOfRawTypes ifAbsent: anAbsentBlock [

	| variableIndex |
	
	variableNameToIndexMapping ifNil: [ ^anAbsentBlock value ].
	variableIndex := variableNameToIndexMapping at: aVariableName ifAbsent: [ ^anAbsentBlock value ].
	
	^anArrayOfRawTypes at: variableIndex
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> remoteVectorRawTypes [
	
	^remoteVectorRawTypes 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> returnRawTypes [
	
	^returnRawTypes 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> returnRawTypesUnload: aClassToUnload [

	ReturnTypeInfo unload: aClassToUnload from: returnRawTypes 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> setMethod: aMethod [

	| propertyOrPragma "<Association|Pragma>" |
	
	method := aMethod.
	1 to: self basicSize do:
		[ :i |
		(propertyOrPragma := self basicAt: i) isVariableBinding ifFalse:
			[propertyOrPragma method: aMethod]].
		

]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> sizeOf: anArrayOfRawTypesOrNil [

 	^ anArrayOfRawTypesOrNil ifNil: [ 0 ] ifNotNil: [ anArrayOfRawTypesOrNil size ]

]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> storeOn: aStream [

	"review this!"
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> variableNameToIndex: aVariableNameToTypeIndex do: aBlock [
	
	aVariableNameToTypeIndex ifNotNil: [ aVariableNameToTypeIndex keysDo: aBlock ]
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> variableNameToRemoteVectorTypeIndex [
	
	^variableNameToRemoteVectorTypeIndex
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> variableNameToTypeIndex [

	^variableNameToTypeIndex
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> variablesNames [

	| names |
	
	names := OrderedCollection new.
	self variablesNamesDo: [ :aVarName | names add: aVarName ].
	
	^names
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> variablesNamesDo: aBlock [

	self variableNameToIndex: variableNameToTypeIndex do: aBlock.
	self variableNameToIndex: variableNameToRemoteVectorTypeIndex do: aBlock.
	
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> variablesRawTypes [
	
	^variablesRawTypes 
]

{ #category : #'*LiveTyping' }
AdditionalMethodState >> variablesRawTypesUnload: aClassToUnload [

	MethodVariablesTypes 
		unload: aClassToUnload fromAllRawTypesOf: variablesRawTypes;
		unload: aClassToUnload fromAllRawTypesOf: remoteVectorRawTypes 
		
]
