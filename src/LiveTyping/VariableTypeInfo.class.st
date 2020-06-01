Class {
	#name : #VariableTypeInfo,
	#superclass : #Object,
	#instVars : [
		'rawTypes'
	],
	#category : #LiveTyping
}

{ #category : #'error descriptions' }
VariableTypeInfo class >> errorDescriptionFor: aClass isNotInSuperclassesOf: anotherClass [

	^aClass name, ' in not in the superclass chain of ', anotherClass name
]

{ #category : #'error descriptions' }
VariableTypeInfo class >> rawTypesIfFullErrorDescription [

	^'Can not add more types. Types collection is full'
]

{ #category : #'error descriptions' }
VariableTypeInfo class >> typeNotFoundErrorDescription [
	
	^'Type not found'
]

{ #category : #types }
VariableTypeInfo class >> unload: aClassToUnload from: rawTypes [ 

	rawTypes
		removeType: aClassToUnload ifAbsent: [];
		removeType: aClassToUnload class ifAbsent: []
		
]

{ #category : #'common supertype' }
VariableTypeInfo >> addIfNoCommonSupertypeTo: allWithNoCommonSupertype [ 
	
	| commonSupertype |
	
	commonSupertype := self commonSupertypeIfNoTypes: [ ^self ].
	
	(commonSupertype = Object or: [ commonSupertype = ProtoObject ]) ifTrue: [  allWithNoCommonSupertype add: (self identifier->self types)]
]

{ #category : #types }
VariableTypeInfo >> addType: aType [

	^self addType: aType ifFull: [ self signalRawTypesIsFull]
]

{ #category : #types }
VariableTypeInfo >> addType: aType ifFull: aFullBlock [

	"If rawTypes is nil, it is assumed that type can not be added and therefore it is full - Hernan"
	
	^rawTypes addType: aType ifFull: aFullBlock

]

{ #category : #'common supertype' }
VariableTypeInfo >> allSupertypesOf: types [
	
	^ types 
		inject: types anyOne withAllSuperclasses 
		into: [ :temporaryCommonSupertypes :type | temporaryCommonSupertypes intersection: type withAllSuperclasses ].

]

{ #category : #'common supertype - private' }
VariableTypeInfo >> commonLowestTypeIn: commonSupertypes [
	
	| commonSupertype commonSupertypeSuperclassesSize |
	
	commonSupertypeSuperclassesSize := 0.
	
	commonSupertypes do: [ :currentType | | currentTypeSuperclassesSize |
		currentTypeSuperclassesSize := currentType withAllSuperclasses size.
		currentTypeSuperclassesSize > commonSupertypeSuperclassesSize ifTrue: [
			commonSupertypeSuperclassesSize := currentTypeSuperclassesSize.
			commonSupertype := currentType ]].
	
	^ commonSupertype
]

{ #category : #'common selectors' }
VariableTypeInfo >> commonSelectors [

	^self commonSelectorsPreviousTo: nil
]

{ #category : #'common selectors' }
VariableTypeInfo >> commonSelectorsPreviousTo: aSuperclassToExclude [

	^self 
		commonSelectorsPreviousTo: aSuperclassToExclude 
		ifInvalidSupertype: [ :aStartingClass | self signal: aSuperclassToExclude isNotInSuperclassesOf:  aStartingClass ].
]

{ #category : #'common selectors' }
VariableTypeInfo >> commonSelectorsPreviousTo: aSuperclassToExclude ifInvalidSupertype: anInvalidBlock [

	| types initialType commonSelectors invalidSupertypeBlock |
	
	self isTypesEmpty ifTrue: [ ^#() ].
	
	invalidSupertypeBlock :=  [ :aStartingType | ^anInvalidBlock value: aStartingType ].
	types := self types.
	initialType := types anyOne.
	
	commonSelectors := self selectorsOf: initialType previousTo: aSuperclassToExclude ifInvalidSupertype: invalidSupertypeBlock.
	types 
		do: [ :aType | 
			commonSelectors := self 
				intersect: commonSelectors 
				withSelectorsOf: aType 
				previousTo: aSuperclassToExclude 
				ifInvalidSupertype: invalidSupertypeBlock ]
		without: initialType.
	
	^commonSelectors 
]

{ #category : #'common selectors' }
VariableTypeInfo >> commonSelectorsPreviousToObject [

	^ self commonSelectorsPreviousTo: Object 
]

{ #category : #'common supertype' }
VariableTypeInfo >> commonSupertype [
	
	^self commonSupertypeIfNoTypes: [ ProtoObject ]
]

{ #category : #'common supertype' }
VariableTypeInfo >> commonSupertypeIfGeneric: genericBlock [
	
	^self withCommonSupertypeDo: [ :aCommonSupertype | aCommonSupertype ] ifGeneric: genericBlock
]

{ #category : #'common supertype' }
VariableTypeInfo >> commonSupertypeIfNoTypes: aBlock [

	| types commonSupertypes commonSupertype |
	
	types := self types.
	types := types reject: [ :aType | aType = UndefinedObject ].
	types isEmpty ifTrue: [ ^aBlock value ].
	types size = 1 ifTrue: [ ^types anyOne ].
	
	"I have to convert types to Array becuase inst var types can be a Set - Hernan"
	commonSupertypes := self allSupertypesOf: types.
	commonSupertype := self commonLowestTypeIn: commonSupertypes.
	
	^commonSupertype 
]

{ #category : #'common supertype' }
VariableTypeInfo >> commonSupertypeOrCommonSelectorsPreviousToObjectIfGeneric [
	
	^self commonSupertypeIfGeneric: [ :genericSuperclass | self commonSelectorsPreviousToObject ]
]

{ #category : #testing }
VariableTypeInfo >> doesStoreTypes [

	^rawTypes doesStoreTypes 
]

{ #category : #identification }
VariableTypeInfo >> identifier [

	self subclassResponsibility 
]

{ #category : #megamorphic }
VariableTypeInfo >> ifMegamorphicAddTo: allMegamorphicVariables [

	self isMegamorphic ifTrue: [ allMegamorphicVariables add: (self identifier -> self typesSize) ]

]

{ #category : #testing }
VariableTypeInfo >> includesNil [
	
	^ rawTypes includesNil 
]

{ #category : #initialization }
VariableTypeInfo >> initializeRawTypes: aRawTypes [

	rawTypes := aRawTypes 
]

{ #category : #'common selectors - private' }
VariableTypeInfo >> intersect: previousCommonSelectors withSelectorsOf: aStartingType previousTo: aSupertypeToExclude ifInvalidSupertype: anInvalidBlock [

	|  commonSelectors |
	
	commonSelectors := Set new.

	self 
		withSelectorsOf: aStartingType 
		previousTo: aSupertypeToExclude 
		do:  [ :aSelector | (previousCommonSelectors includes: aSelector) ifTrue: [ commonSelectors add: aSelector ]]
		ifInvalidSuperclass: [ :aType | ^anInvalidBlock value: aType ].
			
	^commonSelectors 
]

{ #category : #testing }
VariableTypeInfo >> isMegamorphic [
	
	^rawTypes isMegamorphic 
]

{ #category : #types }
VariableTypeInfo >> isTypesEmpty [
	
	^rawTypes isTypesEmpty
]

{ #category : #printing }
VariableTypeInfo >> print: originalTypes on: aStream upTo: aNumberOfTypes [
	
	| types canBeNil |
	
	types := originalTypes asArray.
	aStream nextPut: $<.

	types isEmpty 
		ifTrue: [ aStream nextPut: $? ]
		ifFalse: [
			types size > 1 ifTrue: [
				self 
					withCommonSupertypeDo: [ :aCommonSupertype | aStream nextPutAll: aCommonSupertype typeName ] 
					ifGeneric: [ :aGenericType | aStream nextPutAll: 'any' ].
				aStream nextPutAll: ' # ' ].
			
			(types includes: UndefinedObject) 
				ifTrue: [
					canBeNil := true.
					types := types reject: [ :aType | aType = UndefinedObject ]]
				ifFalse: [
					canBeNil := false ].
				
			aNumberOfTypes < types size 
				ifTrue: [ 
					self printAll: (types first: aNumberOfTypes) on: aStream.
					canBeNil ifTrue: [ aStream nextPutAll: ' | can be nil !' ].
					aStream nextPutAll: ' | ...' ] 
				ifFalse: [ 
					self printAll: types on: aStream.
					canBeNil ifTrue: [ aStream nextPutAll: ' | can be nil !' ]]].
			
	aStream nextPut: $>.
	
	
]

{ #category : #printing }
VariableTypeInfo >> printAll: types on: aStream [.

	types
		do: [:aType | aStream nextPutAll: aType typeName ]
		separatedBy: [ aStream nextPutAll: ' | ' ].
				

]

{ #category : #printing }
VariableTypeInfo >> printOn: aStream [

	aStream 
		nextPutAll: self variableName;
		nextPutAll: ' : '.
		
	self printTypesOn: aStream
	
]

{ #category : #printing }
VariableTypeInfo >> printReducedTypes [
	
	^String streamContents: [ :stream | self printReducedTypesOn: stream ]
]

{ #category : #printing }
VariableTypeInfo >> printReducedTypesOn: aStream [

	aStream nextPut: $<.
	
	self isTypesEmpty  
		ifTrue: [ aStream nextPut: $? ]
		ifFalse: [
			self 
				withCommonSupertypeDo: [ :aCommonSupertype | 
					aStream nextPutAll: aCommonSupertype typeName.
					self typesSize > 1 ifTrue: [ aStream nextPutAll: ' # ... ' ]]
				ifGeneric: [ :genericType | 
					aStream nextPutAll: 'any # '.
					self 
						typesDo: [:aType | aStream nextPutAll: aType typeName ]
						separatedBy: [ aStream nextPutAll: ' | ' ]]].
			
	aStream nextPut: $>.

]

{ #category : #printing }
VariableTypeInfo >> printTypes [
	
	^String streamContents: [ :stream | self printTypesOn: stream ]
]

{ #category : #printing }
VariableTypeInfo >> printTypesOn: aStream [

	| types |
	
	types := self types.

	self print: types on: aStream upTo: types size.
	
]

{ #category : #printing }
VariableTypeInfo >> printTypesOn: aStream upTo: aNumberOfTypes [

	self print: self types on: aStream upTo: aNumberOfTypes.
	
]

{ #category : #printing }
VariableTypeInfo >> printTypesUpTo: aNumberOfTypes [
	
	^String streamContents: [ :stream | self printTypesOn: stream upTo: aNumberOfTypes]
]

{ #category : #types }
VariableTypeInfo >> removeAllTypes [
	
	rawTypes removeAllTypes 
]

{ #category : #types }
VariableTypeInfo >> removeType: aType [

	^self removeType: aType ifAbsent: [ self signalTypeNotFound]
]

{ #category : #types }
VariableTypeInfo >> removeType: aType ifAbsent: anAbsentBlock [

	^rawTypes removeType: aType ifAbsent: anAbsentBlock

]

{ #category : #'common selectors - private' }
VariableTypeInfo >> selectorsOf: aStartingType previousTo: aSupertypeToExclude ifInvalidSupertype: anInvalidBlock [

	| commonSelectors |
	
	commonSelectors := Set new.
	self 
		withSelectorsOf: aStartingType 
		previousTo: aSupertypeToExclude 
		do: [ :aSelector | commonSelectors add: aSelector ]
		ifInvalidSuperclass: [ :aType | ^anInvalidBlock value: aType ].
	
	^commonSelectors 
	
]

{ #category : #exceptions }
VariableTypeInfo >> signal: aClass isNotInSuperclassesOf: anotherClass [

	self error: (self class errorDescriptionFor: aClass isNotInSuperclassesOf: anotherClass)
]

{ #category : #exceptions }
VariableTypeInfo >> signalRawTypesIsFull [

	self error: self class rawTypesIfFullErrorDescription
]

{ #category : #exceptions }
VariableTypeInfo >> signalTypeNotFound [
	
	self error: self class typeNotFoundErrorDescription
]

{ #category : #types }
VariableTypeInfo >> types [
	
	^rawTypes types
]

{ #category : #types }
VariableTypeInfo >> typesDo: aBlock [
	
	^self types do: aBlock 
]

{ #category : #types }
VariableTypeInfo >> typesDo: aBlock separatedBy: separatorBlock [
	
	^self types do: aBlock separatedBy: separatorBlock
]

{ #category : #types }
VariableTypeInfo >> typesIncludes: aType [

	^self types includes: aType 
]

{ #category : #types }
VariableTypeInfo >> typesIncludesAllOf: aTypesCollection [
	^ self types includesAll: aTypesCollection
]

{ #category : #types }
VariableTypeInfo >> typesNames [
	
	^(self types collect: [ :aType | aType typeName ]) sorted
]

{ #category : #types }
VariableTypeInfo >> typesSize [
	
	^rawTypes typesSize 
]

{ #category : #identification }
VariableTypeInfo >> variableName [

	self subclassResponsibility 
]

{ #category : #'common supertype' }
VariableTypeInfo >> withCommonSupertypeDo: doBlock ifGeneric: ifGenericBlock [
 
	| commonSupertype block  |
	
	commonSupertype := self commonSupertype.
	block := (commonSupertype = Object or: [ commonSupertype = ProtoObject ])
		ifTrue: [ ifGenericBlock ]
		ifFalse: [ doBlock  ].
		
	^block value: commonSupertype 
]

{ #category : #'common selectors - private' }
VariableTypeInfo >> withSelectorsOf: aStartingType previousTo: aSupertypeToExclude do: aBlock ifInvalidSuperclass: anInvalidBlock [

	| currentType |
	
	currentType := aStartingType.
	
	[ currentType = aSupertypeToExclude ] whileFalse: [ 
		currentType ifNil: [ ^anInvalidBlock value: aStartingType ].
		currentType selectorsDo: aBlock.
		currentType := currentType superclass ].
	

]
