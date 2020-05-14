Class {
	#name : #InstanceVariableTypeInfoTest,
	#superclass : #TestCase,
	#instVars : [
		'iv1'
	],
	#category : #'LiveTyping-Tests'
}

{ #category : #tests }
InstanceVariableTypeInfoTest >> assertTypesAreCollectedCorrectlyFor: anInstVarTypeInfoCreator [

	| root sibling1 sibling2 ivrootTypeInfo |
	
	self initializeHierarchyForTestingInstanceVariablesTypes.
	
	root := TypeInfoRootTestClass new.
	sibling1 := TypeInfoSibling1TestClass new.
	sibling2 := TypeInfoSibling2TestClass new.
	
	root ivroot: 1/2.
	sibling1 ivroot: 1.
	sibling2 ivroot: 1.0.

	ivrootTypeInfo := anInstVarTypeInfoCreator value.
	
	self assert: 3 equals: ivrootTypeInfo typesSize.
	self assert: (ivrootTypeInfo typesIncludes: (1/2) class).
	self assert: (ivrootTypeInfo typesIncludes: 1 class).
	self assert: (ivrootTypeInfo typesIncludes: 1.0 class)
]

{ #category : #'set up' }
InstanceVariableTypeInfoTest >> initializeHierarchyForTestingInstanceVariablesTypes [
	
	TypeInfoRootTestClass withAllSubclassesDo: [ :aClass | aClass initializeInstanceVariablesRawTypes]
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test01TypeCollectionOfInstanceVariableDefinedInLeafClassDoesNotTraverseHierarchy [

	| sibling1 ivsibling1TypeInfo |
	
	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivsibling1TypeInfo := TypeInfoSibling1TestClass instanceVariablesTypes typeInfoOf: 'ivsibling1'.
	
	sibling1 := TypeInfoSibling1TestClass new.
	sibling1 ivsibling1: 1.
	
	self assert: 1 equals: ivsibling1TypeInfo typesSize.
	self assert: (ivsibling1TypeInfo typesIncludes: 1 class)
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test02TypeCollectionIncludesSubclasses [

	| root sibling1 sibling2 ivrootTypeInfo |
	
	self initializeHierarchyForTestingInstanceVariablesTypes.
	
	root := TypeInfoRootTestClass new.
	sibling1 := TypeInfoSibling1TestClass new.
	sibling2 := TypeInfoSibling2TestClass new.
	
	root ivroot: 1/2.
	sibling1 ivroot: 1.
	sibling2 ivroot: 1.0.

	ivrootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes typeInfoOf: 'ivroot'.
	
	self assert: 3 equals: ivrootTypeInfo typesSize.
	self assert: (ivrootTypeInfo typesIncludes: (1/2) class).
	self assert: (ivrootTypeInfo typesIncludes: 1 class).
	self assert: (ivrootTypeInfo typesIncludes: 1.0 class)	
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test03TypeCollectionDoesNotIncludeSuperclassesAndSiblings [

	| root sibling1 sibling2 ivrootTypeInfo |
	
	self initializeHierarchyForTestingInstanceVariablesTypes.
	
	root := TypeInfoRootTestClass new.
	sibling1 := TypeInfoSibling1TestClass new.
	sibling2 := TypeInfoSibling2TestClass new.
	
	root ivroot: 1/2.
	sibling1 ivroot: 1.
	sibling2 ivroot: 1.0.

	ivrootTypeInfo :=  TypeInfoSibling1TestClass instanceVariablesTypes typeInfoOf: 'ivroot'. 
	
	self assert: 1 equals: ivrootTypeInfo typesSize.
	self assert: (ivrootTypeInfo typesIncludes: 1 class).

]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test05TypeCollectionIncludesAllSubclasses [

	| root sibling1 sibling2 ivrootInRootTypeInfo |
	
	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivrootInRootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes typeInfoOf: 'ivroot'.
	
	root := TypeInfoRootTestClass new.
	sibling1 := TypeInfoSibling1TestClass new.
	sibling2 := TypeInfoSibling2TestClass new.
	
	root ivroot: 1/2.
	root ivroot: 1.
	sibling1 ivroot: 1.
	sibling1 ivroot: 1.0.
	sibling2 ivroot: 1.0.	
	sibling2 ivroot: 1/2.
	
	self assert: 3 equals: ivrootInRootTypeInfo typesSize.
	self assert: (ivrootInRootTypeInfo typesIncludes: (1/2) class).
	self assert: (ivrootInRootTypeInfo typesIncludes: 1 class).
	self assert: (ivrootInRootTypeInfo typesIncludes: 1.0 class)
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test06IsNotMegamorphicIfTypesSizeIsLessToTheMaxOfWithAllSubclassesRawTypesSize [

	| root ivrootInRootTypeInfo |
	
	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivrootInRootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes typeInfoOf: 'ivroot'.
	
	root := TypeInfoRootTestClass new.
	
	root ivroot: 1/2.
	root ivroot: 1.
	
	self deny: ivrootInRootTypeInfo isMegamorphic 
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test07IsMegamorphicIfTypesSizeIsEqualToTheMaxOfWithAllSubclassesRawTypesSize [

	| sibling1 ivrootInRootTypeInfo |

	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivrootInRootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes typeInfoOf: 'ivroot'.
	
	sibling1 := TypeInfoSibling1TestClass new.
	
	sibling1 ivroot: 1/2.
	sibling1 ivroot: 1.
	sibling1 ivroot: 1.0.
	
	self assert: ivrootInRootTypeInfo isMegamorphic.
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test08IsNotMegamorphicIfDoesNotFillRawTypesForLocalTypeInfo [

	| root sibling1 ivrootInRootTypeInfo ivrootInSibling1TypeInfo |

	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivrootInRootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes localTypeInfoOf: 'ivroot'.
	ivrootInSibling1TypeInfo := TypeInfoSibling1TestClass instanceVariablesTypes localTypeInfoOf: 'ivroot'.
	
	root := TypeInfoRootTestClass new.
	sibling1 := TypeInfoSibling1TestClass new.

	root ivroot: 1.0.	
	sibling1 ivroot: 1/2.
	sibling1 ivroot: 1.
	
	self deny: ivrootInRootTypeInfo isMegamorphic.
	self deny: ivrootInSibling1TypeInfo isMegamorphic.
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test09IsMegamorphicIfFillsRawTypesOfDefiningClassForLocalTypeInfo [

	| root sibling1 ivrootInRootTypeInfo ivrootInSibling1TypeInfo |

	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivrootInRootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes localTypeInfoOf: 'ivroot'.
	ivrootInSibling1TypeInfo := TypeInfoSibling1TestClass instanceVariablesTypes localTypeInfoOf: 'ivroot'.
	
	root := TypeInfoRootTestClass new.
	sibling1 := TypeInfoSibling1TestClass new.

	root ivroot: 1.0.	
	root ivroot: 1.	
	sibling1 ivroot: 1/2.
	sibling1 ivroot: 1.
	
	self assert: ivrootInRootTypeInfo isMegamorphic.
	self deny: ivrootInSibling1TypeInfo isMegamorphic.
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test10IsMegamorphicIfFillsRawTypesOfNotDefiningClassForLocalTypeInfo [

	| root sibling1 ivrootInRootTypeInfo ivrootInSibling1TypeInfo |

	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivrootInRootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes localTypeInfoOf: 'ivroot'.
	ivrootInSibling1TypeInfo := TypeInfoSibling1TestClass instanceVariablesTypes localTypeInfoOf: 'ivroot'.
	
	root := TypeInfoRootTestClass new.
	sibling1 := TypeInfoSibling1TestClass new.

	root ivroot: 1.0.	
	sibling1 ivroot: 1/2.
	sibling1 ivroot: 1.
	sibling1 ivroot: 1.0.
	
	self deny: ivrootInRootTypeInfo isMegamorphic.
	self assert: ivrootInSibling1TypeInfo isMegamorphic.
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test11IsTypesEmptyOfNonLocalTypeInfoTakesCareOfHierarchy [

	| root ivrootInRootTypeInfo ivrootInSibling1TypeInfo |

	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivrootInRootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes typeInfoOf: 'ivroot'.
	ivrootInSibling1TypeInfo := TypeInfoSibling1TestClass instanceVariablesTypes typeInfoOf: 'ivroot'.
	
	root := TypeInfoRootTestClass new.

	root ivroot: 1.0.	
	
	self deny: ivrootInRootTypeInfo isTypesEmpty.
	self assert: ivrootInSibling1TypeInfo isTypesEmpty.
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test12IsTypesEmptyForLocalTypeInfoOnlyCheckOnLocalRawTypes [

	| root ivrootInRootTypeInfo ivrootInSibling1TypeInfo |

	self initializeHierarchyForTestingInstanceVariablesTypes.
	ivrootInRootTypeInfo := TypeInfoRootTestClass instanceVariablesTypes typeInfoOf: 'ivroot'.
	ivrootInSibling1TypeInfo := TypeInfoSibling1TestClass instanceVariablesTypes localTypeInfoOf: 'ivroot'.
	
	root := TypeInfoRootTestClass new.

	root ivroot: 1.0.	
	
	self deny: ivrootInRootTypeInfo isTypesEmpty.
	self assert: ivrootInSibling1TypeInfo isTypesEmpty.
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test13RemovingAClassRemovesItAndItsClassFromInstanceVariableRawTypes [

	| classToRemove typeInfo |

	LiveTypingTestFactory removeTestDataClassCategoryAfter: [ :testFactory |
		classToRemove := testFactory createClassToBeRemoved.
		self class initializeInstanceVariablesRawTypes.
		iv1 := classToRemove new.
		iv1 := classToRemove.
	
		typeInfo := self class typeInfoOfInstanceVariableNamed: 'iv1'.
		
		self assert: typeInfo typesSize equals: 2.
		self assert: (typeInfo typesIncludes: classToRemove).
		self assert: (typeInfo typesIncludes: classToRemove class).
		
		classToRemove removeFromSystem.
		
		self assert: typeInfo isTypesEmpty ]
]

{ #category : #tests }
InstanceVariableTypeInfoTest >> test14InstVarAtPutKeepTypeInfo [

	| types |
	
	self class initializeInstanceVariablesRawTypes.
	self instVarAt: (self class indexOfInstanceVariable: 'iv1') put: 10.
	
	types := self class typesOfInstanceVariableNamed: 'iv1'.
	
	self assert: 1 equals: types size.
	self assert: (types includes: SmallInteger)
]
