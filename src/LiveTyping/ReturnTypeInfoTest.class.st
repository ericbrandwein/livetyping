Class {
	#name : #ReturnTypeInfoTest,
	#superclass : #TestCase,
	#instVars : [
		'iv1',
		'iv2'
	],
	#category : #'LiveTyping-Tests'
}

{ #category : #assertions }
ReturnTypeInfoTest >> assertReturnTypeOf: aSelector are: types [

	| method methodReturnTypeInfo |
	
	method := self class >> aSelector.
	methodReturnTypeInfo := method returnTypeInfo.
	
	self assert: types size equals: methodReturnTypeInfo typesSize.
	self assert: (methodReturnTypeInfo typesIncludesAllOf: types)
]

{ #category : #assertions }
ReturnTypeInfoTest >> assertReturnTypeOf: aSelector is: aType [

	self assertReturnTypeOf: aSelector are: (Array with: aType)
]

{ #category : #'test data' }
ReturnTypeInfoTest >> methodReturningInstanceOfClassToRemove: aClassToRemoveInstance [

	^aClassToRemoveInstance
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnFalse [

	^false
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnFirstInstanceVariable [

	^iv1
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnMinusOne [

	^-1
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnNil [

	^nil
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnOne [

	^1
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnSecondInstanceVariable [

	^iv2
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnSelf [

	^self
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnTrue [

	^true
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnTwo [

	^2
]

{ #category : #'test data' }
ReturnTypeInfoTest >> quickReturnZero [

	^0
]

{ #category : #tests }
ReturnTypeInfoTest >> test01QuickReturnSelfMethodsReturnSelfTypeAsReturnType [

	| method returnTypes |
	
	method := self class >> #quickReturnSelf.
	returnTypes := method returnTypes.
	
	self assert: returnTypes size equals: 1.
	self assert: returnTypes anyOne class equals: SelfType 

]

{ #category : #tests }
ReturnTypeInfoTest >> test02QuickReturnTrueMethodsReturnTrueReturnType [

	self assertReturnTypeOf: #quickReturnTrue is: true class.
	
]

{ #category : #tests }
ReturnTypeInfoTest >> test03QuickReturnFalseMethodsReturnFalseAsReturnType [

	self assertReturnTypeOf: #quickReturnFalse is: false class.
	
]

{ #category : #tests }
ReturnTypeInfoTest >> test04QuickReturnNilMethodsReturnUndefinedObjectAsReturnType [

	self assertReturnTypeOf: #quickReturnNil is: nil class.
	
]

{ #category : #tests }
ReturnTypeInfoTest >> test05QuickReturnMinusOneMethodsReturnSmallIntegerAsReturnType [

	self assertReturnTypeOf: #quickReturnMinusOne is: -1 class.
	
]

{ #category : #tests }
ReturnTypeInfoTest >> test06QuickReturnZeroMethodsReturnSmallIntegerAsReturnType [

	self assertReturnTypeOf: #quickReturnZero is: 0 class.
	
]

{ #category : #tests }
ReturnTypeInfoTest >> test07QuickReturnOneMethodsReturnSmallIntegerAsReturnType [

	self assertReturnTypeOf: #quickReturnOne is: 1 class.
	
]

{ #category : #tests }
ReturnTypeInfoTest >> test08QuickReturnTwoMethodsReturnSmallIntegerAsReturnType [

	self assertReturnTypeOf: #quickReturnTwo is: 2 class.
	
]

{ #category : #tests }
ReturnTypeInfoTest >> test09QuickReturnOfFirstInstanceVariableMethodsReturnInstanceVariableTypesAsReturnType [

	self class initializeInstanceVariablesRawTypes.
	iv1 := 'hello'.
	iv1 := 1.
	
	self assertReturnTypeOf: #quickReturnFirstInstanceVariable are: (Array with: 'hello' class with: 1 class)
]

{ #category : #tests }
ReturnTypeInfoTest >> test10QuickReturnOfSecondInstanceVariableMethodsReturnInstanceVariableTypesAsReturnType [

	self class initializeInstanceVariablesRawTypes.
	iv2 := 1.0.
	iv2 := 1.
	
	self assertReturnTypeOf: #quickReturnSecondInstanceVariable are: (Array with: 1.0 class with: 1 class)
]

{ #category : #tests }
ReturnTypeInfoTest >> test11classMethodReturnsClassTypeAsReturnType [

	| method returnTypes |
	
	method := Object >> #class.
	returnTypes := method returnTypes.
	
	self assert: returnTypes size equals: 1.
	self assert: returnTypes anyOne class equals: ClassType 

]

{ #category : #tests }
ReturnTypeInfoTest >> test12newMethodReturnsInstanceTypeAsReturnType [

	| method returnTypes |
	
	method := Behavior >> #new.
	returnTypes := method returnTypes.
	
	self assert: returnTypes size equals: 1.
	self assert: returnTypes anyOne class equals: InstanceType 
]

{ #category : #tests }
ReturnTypeInfoTest >> test13yourselfMethodReturnsSelfTypeAsReturnType [

	| method returnTypes |
	
	method := Object >> #yourself.
	returnTypes := method returnTypes.
	
	self assert: returnTypes size equals: 1.
	self assert: returnTypes anyOne class equals: SelfType 
]

{ #category : #tests }
ReturnTypeInfoTest >> test14RemovingAClassRemovesItAndItsClassFromMethodReturnType [

	| classToRemove typeInfo methodUnderTest |

	LiveTypingTestFactory removeTestDataClassCategoryAfter: [ :testFactory |
		classToRemove := testFactory createClassToBeRemoved.
		methodUnderTest := self class compiledMethodAt: #methodReturningInstanceOfClassToRemove:.
		methodUnderTest initializeTypeInformation.
		
		self methodReturningInstanceOfClassToRemove: classToRemove new.
		self methodReturningInstanceOfClassToRemove: classToRemove.
	
		typeInfo := methodUnderTest returnTypeInfo.
		
		self assert: typeInfo typesSize equals: 2.
		self assert: (typeInfo typesIncludes: classToRemove).
		self assert: (typeInfo typesIncludes: classToRemove class).
		
		classToRemove removeFromSystem.
		
		self assert: typeInfo isTypesEmpty ]
]

{ #category : #tests }
ReturnTypeInfoTest >> test15ReturnTypesOfAbstractMethodsIncludesSubclassesImplementationsTypes [

	| returnTypes |
	
	TypeInfoRootTestClass allSubclassesDo: [ :aSubclass | aSubclass new implementedOnAll: 1 ].
	
	returnTypes := TypeInfoRootTestClass returnTypesAt: #implementedOnAll:.
	
	self assert: 2 equals: returnTypes size.
	TypeInfoRootTestClass allSubclassesDo: [ :aSubclass |
		self assert: (returnTypes includesAllOf: (aSubclass returnTypesAt: #implementedOnAll:)) ].
]

{ #category : #tests }
ReturnTypeInfoTest >> test16ReturnTypesOfAbstractMethodWorksWhenNotImplementedInAllSubclasses [

	| returnTypes |
	
	returnTypes := TypeInfoRootTestClass returnTypesAt: #implementedOnSibling1Only.
	
	self assert: 1 equals: returnTypes size.
	self assert: (returnTypes includesAllOf: (TypeInfoSibling1TestClass returnTypesAt: #implementedOnSibling1Only)) 
]
