Class {
	#name : #VariableTypeInfoTest,
	#superclass : #TestCase,
	#instVars : [
		'instVar1',
		'instVar2',
		'instVar3',
		'instVar4'
	],
	#category : #'LiveTyping-Tests'
}

{ #category : #'as yet unclassified' }
VariableTypeInfoTest class >> createInstanceVariableRawTypesFor: anInstVarName [

	anInstVarName = 'instVar3' ifTrue: [ ^ Array new: 1 ].
	anInstVarName = 'instVar4' ifTrue: [ ^ nil ].

	^super createInstanceVariableRawTypesFor: anInstVarName
]

{ #category : #tests }
VariableTypeInfoTest >> test01IsEmptyWhenAllTypesAreNil [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	self assert: 0 equals: variableTypeInfo typesSize.
	self assert: variableTypeInfo isTypesEmpty 
]

{ #category : #tests }
VariableTypeInfoTest >> test02StoresAddedTypes [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	variableTypeInfo addType: self class.

	self assert: 1 equals: variableTypeInfo typesSize.
	self deny: variableTypeInfo isTypesEmpty.
	self assert: (variableTypeInfo typesIncludes: self class).
]

{ #category : #tests }
VariableTypeInfoTest >> test03StoresSameTypeOnce [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	variableTypeInfo addType: self class.
	variableTypeInfo addType: self class.

	self assert: 1 equals: variableTypeInfo typesSize.
	self assert: (variableTypeInfo typesIncludes: self class).
]

{ #category : #tests }
VariableTypeInfoTest >> test04StoresMoreThanOneTypeCorrectly [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	variableTypeInfo addType: self class.
	variableTypeInfo addType: 1 class.

	self assert: 2 equals: variableTypeInfo typesSize.
	self assert: (variableTypeInfo typesIncludes: self class).
	self assert: (variableTypeInfo typesIncludes: 1 class).
]

{ #category : #tests }
VariableTypeInfoTest >> test05DoesNotStoreTypesWhenContainerIsNil [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: nil.

	variableTypeInfo addType: self class ifFull: [].

	self assert: variableTypeInfo isTypesEmpty.
	self assert: 0 equals: variableTypeInfo typesSize.
	self deny: (variableTypeInfo typesIncludes: self class)
]

{ #category : #tests }
VariableTypeInfoTest >> test06CommonSupertypeOfSiblingsClassesReturnsRightSuperclass [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	variableTypeInfo addType: 1 class.
	variableTypeInfo addType: 2.0 class.

	self assert: Number equals: variableTypeInfo commonSupertype.
]

{ #category : #tests }
VariableTypeInfoTest >> test07CommonSupertypeOnSameHierarchyIsMostTopClass [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	variableTypeInfo addType: 'hello' class.
	variableTypeInfo addType: #hello class.

	self assert: String equals: variableTypeInfo commonSupertype.
]

{ #category : #tests }
VariableTypeInfoTest >> test08CommonSupertypeOnSameHierarchyIsNotAffectedByAddingOrder [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	variableTypeInfo addType: #hello class.
	variableTypeInfo addType: 'hello' class.

	self assert: String equals: variableTypeInfo commonSupertype.
]

{ #category : #tests }
VariableTypeInfoTest >> test09ObjectIsCommonSupertypeWhenClassesAreNotSiblings [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	variableTypeInfo addType: 'hello' class.
	variableTypeInfo addType: 1 class.

	self assert: Object equals: variableTypeInfo commonSupertype.
]

{ #category : #tests }
VariableTypeInfoTest >> test10ProtoObjectIsCommonSupertypeWhenThereAreNoTypesStored [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	self assert: ProtoObject equals: variableTypeInfo commonSupertype.
]

{ #category : #tests }
VariableTypeInfoTest >> test11ProtoObjectIsCommonSupertypeWhenCointainerIsNil [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: nil.

	self assert: ProtoObject equals: variableTypeInfo commonSupertype.
]

{ #category : #tests }
VariableTypeInfoTest >> test12CommonSupertypeIfNoTypesReturnsAlternativeClosureValueWhenIsEmpty [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	self assert: Array equals: (variableTypeInfo commonSupertypeIfNoTypes: [ Array ]).
]

{ #category : #tests }
VariableTypeInfoTest >> test13CommonSupertypeIfNoTypesReturnsAlternativeClosureValueWhenContainerIsNil [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: nil.

	self assert: Array equals: (variableTypeInfo commonSupertypeIfNoTypes: [ Array ]).
]

{ #category : #tests }
VariableTypeInfoTest >> test14UndefinedObjectIsNotConsideredWhenLookingForCommonSupertype [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	variableTypeInfo addType: 'hello' class.
	variableTypeInfo addType: nil class.

	self assert: String equals: variableTypeInfo commonSupertype.
	self assert: (variableTypeInfo typesIncludes: nil class)
]

{ #category : #tests }
VariableTypeInfoTest >> test15StoresTypesIsTrueWhenContainerIsNotNil [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 10).

	self assert: variableTypeInfo doesStoreTypes 
]

{ #category : #tests }
VariableTypeInfoTest >> test16StoresTypesIsFalseWhenContainerIsNil [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: nil.

	self deny: variableTypeInfo doesStoreTypes 
]

{ #category : #tests }
VariableTypeInfoTest >> test17IsMegamorphicWhenContainerIsFull [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: 1 class.
	variableTypeInfo addType: 1.0 class.

	self assert: variableTypeInfo isMegamorphic 
]

{ #category : #tests }
VariableTypeInfoTest >> test18IsNotMegamorphicWhenContainerIsNotFull [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	self deny: variableTypeInfo isMegamorphic 
]

{ #category : #tests }
VariableTypeInfoTest >> test19CommonSelectorsPreviousToSameOnlyTypeIsEmpty [

	| variableTypeInfo commonSelectors |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: Magnitude.

	commonSelectors := variableTypeInfo commonSelectorsPreviousTo: Magnitude.

	self assert: commonSelectors isEmpty
]

{ #category : #tests }
VariableTypeInfoTest >> test20CommonSelectorsPreviousToSuperclassOfOnlyAddedTypeAreAddedTypeSelectors [

	| variableTypeInfo commonSelectors expectedSelectors |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: Magnitude.

	commonSelectors := variableTypeInfo commonSelectorsPreviousTo: Magnitude superclass.
	expectedSelectors := Magnitude selectors.

	self assert: expectedSelectors size equals: commonSelectors size.
	self assert: (commonSelectors allSatisfy: [ :aSelector | expectedSelectors includes: aSelector])
]

{ #category : #tests }
VariableTypeInfoTest >> test21CommonSelectorsPreviousToSuperclassSuperclassOfOnlyAddedTypeAreAddedTypeUpToSuperclassSelectors [

	| variableTypeInfo commonSelectors expectedSelectors |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: Magnitude.

	commonSelectors := variableTypeInfo commonSelectorsPreviousTo: Magnitude superclass superclass.
	expectedSelectors := (Magnitude selectors union: Magnitude superclass selectors) asSet.

	self assert: expectedSelectors size equals: commonSelectors size.
	self assert: (commonSelectors allSatisfy: [ :aSelector | expectedSelectors includes: aSelector])
]

{ #category : #tests }
VariableTypeInfoTest >> test22CommonSelectorsPreviousToInvalidSuperclassRaisesError [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: Magnitude.

	self
		should: [ variableTypeInfo commonSelectorsPreviousTo: Collection ]
		raise: Error - MessageNotUnderstood
		withMessageText: (VariableTypeInfo errorDescriptionFor: Collection isNotInSuperclassesOf: Magnitude) 
]

{ #category : #tests }
VariableTypeInfoTest >> test23CommonSelectorsPreviousToSuperclassOfSiblingTypesAreSiblingsCommonSelectors [

	| variableTypeInfo commonSelectors expectedSelectors |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: Magnitude.
	variableTypeInfo addType: Collection.

	commonSelectors := variableTypeInfo commonSelectorsPreviousTo: Object.
	expectedSelectors := Magnitude selectors intersection: Collection selectors.

	self assert: expectedSelectors size equals: commonSelectors size.
	self assert: (commonSelectors allSatisfy: [ :aSelector | expectedSelectors includes: aSelector])
]

{ #category : #tests }
VariableTypeInfoTest >> test24CommonSelectorsPreviousToOnSameHierarchyReturnsCommonSuperclassesSelectors [

	| variableTypeInfo commonSelectors expectedSelectors |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: String.
	variableTypeInfo addType: Symbol.

	commonSelectors := variableTypeInfo commonSelectorsPreviousTo: String superclass.
	expectedSelectors :=  String selectors.

	self assert: expectedSelectors size equals: commonSelectors size.
	self assert: (commonSelectors allSatisfy: [ :aSelector | expectedSelectors includes: aSelector])
]

{ #category : #tests }
VariableTypeInfoTest >> test25CommonSelectorsPreviousToAddedSSupertypeOnSameHierarchyIsEmpty [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: String.
	variableTypeInfo addType: Symbol.

	self assert: (variableTypeInfo commonSelectorsPreviousTo: String) isEmpty
]

{ #category : #tests }
VariableTypeInfoTest >> test26CommonSelectorsPreviousToWhenNotStoringTypesIsEmpty [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: nil.

	self assert: (variableTypeInfo commonSelectorsPreviousTo: String) isEmpty
]

{ #category : #tests }
VariableTypeInfoTest >> test27CommonSelectorsPreviousToIfInvalidSupertypeEvaluatesInvalidBlock [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: Magnitude.

	self assert: Magnitude equals: (variableTypeInfo commonSelectorsPreviousTo: Collection ifInvalidSupertype: [ :aStartingClass | aStartingClass ])
		
]

{ #category : #tests }
VariableTypeInfoTest >> test28CommonSelectorsPreviousToIfInvalidSupertypeWithManyTypesEvaluatesInvalidBlock [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 3).

	variableTypeInfo addType: Array.
	variableTypeInfo addType: Magnitude.
	variableTypeInfo addType: OrderedCollection.

	self assert: Magnitude equals: (variableTypeInfo commonSelectorsPreviousTo: Collection ifInvalidSupertype: [ :aStartingClass | aStartingClass ])
		
]

{ #category : #tests }
VariableTypeInfoTest >> test29CommonSelectosGoesUpToIncludingProtoObject [

	| variableTypeInfo commonSelectors expectedSelectors |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: Magnitude.
	variableTypeInfo addType: Collection.

	commonSelectors := variableTypeInfo commonSelectors.
	expectedSelectors := Magnitude allSelectors intersection: Collection allSelectors.

	self assert: expectedSelectors size equals: commonSelectors size.
	self assert: (commonSelectors allSatisfy: [ :aSelector | expectedSelectors includes: aSelector])
]

{ #category : #tests }
VariableTypeInfoTest >> test30CommonSupertypeIfGenericEvaluatesIfGenericBlockForObject [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: 1 class.
	variableTypeInfo addType: $a class.

	variableTypeInfo commonSupertypeIfGeneric: [ :aGenericSupertype | ^ self assert: aGenericSupertype equals: Object ].
	self fail.
]

{ #category : #tests }
VariableTypeInfoTest >> test31CommonSupertypeIfGenericEvaluatesIfGenericBlockForProtoObject [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: Object.
	variableTypeInfo addType: MessageCatcher .

	variableTypeInfo commonSupertypeIfGeneric: [ :aGenericSupertype | ^ self assert: aGenericSupertype equals: ProtoObject ].
	self fail.
]

{ #category : #tests }
VariableTypeInfoTest >> test32WithCommonSupertypeDoIfGenericEvaluatesDoBlockWhenNoGenericSupertype [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: 1 class.
	variableTypeInfo addType: 1.0 class .

	variableTypeInfo 
		withCommonSupertypeDo: [ :commonSupertype | self assert: commonSupertype equals: Number ]
		ifGeneric: [ :aGenericSupertype | self fail ]
]

{ #category : #tests }
VariableTypeInfoTest >> test33WithCommonSupertypeDoIfGenericEvaluatesGenericBlockWhenGenericSupertype [

	| variableTypeInfo |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).

	variableTypeInfo addType: 1 class.
	variableTypeInfo addType: $a class .

	variableTypeInfo 
		withCommonSupertypeDo: [ :commonSupertype | self fail ]
		ifGeneric: [ :aGenericSupertype | self assert: aGenericSupertype equals: Object ]
]

{ #category : #tests }
VariableTypeInfoTest >> test34AddingATypeWhenNoMoreSpaceEvaluatesIsFullBlock [

	| variableTypeInfo full |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).
	full := false.
	
	variableTypeInfo addType: 1 class ifFull: [ self fail ].
	variableTypeInfo addType: 1.0 class ifFull: [ self fail ].
	variableTypeInfo addType: 'hello' class ifFull: [ full := true ].

	self assert: full
]

{ #category : #tests }
VariableTypeInfoTest >> test35TypeIsNotMoreInTypesWhenRemoved [

	| variableTypeInfo  |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 3).
	
	variableTypeInfo addType: 1 class. 
	variableTypeInfo addType: 1.0 class.
	
	variableTypeInfo removeType: 1 class.
	
	self assert: variableTypeInfo typesSize equals: 1.
	self assert: (variableTypeInfo typesIncludes: 1.0 class).
	self deny: (variableTypeInfo typesIncludes: 1 class).
	
]

{ #category : #tests }
VariableTypeInfoTest >> test36RemovingTypeWhenTypesIsEmptyEvaluatesIfAbsent [

	| variableTypeInfo  |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 3).
	
	variableTypeInfo removeType: 1 class ifAbsent: [ ^self ].
	
	self fail.
]

{ #category : #tests }
VariableTypeInfoTest >> test37RemovingNotIncludedTypeEvaluatesIfAbsent [

	| variableTypeInfo  |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 3).
	
	variableTypeInfo addType: 1.0 class.
	variableTypeInfo removeType: 1 class ifAbsent: [ ^self ].
	
	self fail.
]

{ #category : #tests }
VariableTypeInfoTest >> test38RemovingLastAddedTypeWorksAsExpected [

	| variableTypeInfo  |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).
	
	variableTypeInfo addType: 1 class.
	variableTypeInfo addType: 1.0 class.
	variableTypeInfo removeType: 1.0 class ifAbsent: [ self fail ].
	
	self assert: variableTypeInfo typesSize equals: 1.
	variableTypeInfo addType: 'hello' class.
	self assert: variableTypeInfo typesSize equals: 2.
	self assert: (variableTypeInfo typesIncludes: 1 class).
	self assert: (variableTypeInfo typesIncludes: 'hello' class).
	
	
]

{ #category : #tests }
VariableTypeInfoTest >> test39RemoveTypeSignalExceptionWhenTypeNotFound [

	| variableTypeInfo  |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 2).
	
	variableTypeInfo addType: 1 class.
	
	self 
		should: [ variableTypeInfo removeType: 1.0 class ]
		raise: Error
		withExceptionDo: [:anError |
			self assert: anError messageText equals: VariableTypeInfo typeNotFoundErrorDescription.
			self assert: variableTypeInfo typesSize equals: 1.
			self assert: (variableTypeInfo typesIncludes: 1 class) ]
	
	
]

{ #category : #tests }
VariableTypeInfoTest >> test40TypesDoEvaluatesBlockOnEachType [

	| variableTypeInfo types |

	variableTypeInfo := VariableTypeInfo new initializeRawTypes: (Array new: 3).
	types := OrderedCollection new.
	
	variableTypeInfo addType: 1 class.
	variableTypeInfo addType: 1.0 class.
	
	variableTypeInfo typesDo: [ :aType | types add: aType ].
	
	self assert: types size equals: 2.
	self assert: (types includes: 1 class).
	self assert: (types includes: 1.0 class)
]
