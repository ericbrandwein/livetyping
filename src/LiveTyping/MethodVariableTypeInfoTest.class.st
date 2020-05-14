Class {
	#name : #MethodVariableTypeInfoTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #tests }
MethodVariableTypeInfoTest >> assertTypeIsRemovedFor: aVariableName [

	| classToRemove typeInfo methodUnderTest |

	LiveTypingTestFactory removeTestDataClassCategoryAfter: [ :testFactory |
		classToRemove := testFactory createClassToBeRemoved.
		methodUnderTest := self class >> #methodWithParameterOfClassToRemove:.
		methodUnderTest initializeTypeInformation.
		self methodWithParameterOfClassToRemove: classToRemove new.
		self methodWithParameterOfClassToRemove: classToRemove.
	
		typeInfo := methodUnderTest typeInfoOfVariableNamed: aVariableName.
		
		self assert: typeInfo typesSize equals: 2.
		self assert: (typeInfo typesIncludes: classToRemove).
		self assert: (typeInfo typesIncludes: classToRemove class).
		
		classToRemove removeFromSystem.
		
		self assert: typeInfo isTypesEmpty ]
]

{ #category : #'test data' }
MethodVariableTypeInfoTest >> methodWithParameterOfClassToRemove: p1 [

	| tempNotInRemoteVector tempInRemoteVector |
	
	tempNotInRemoteVector := p1.
	[ tempInRemoteVector := p1 ] value.
	
	^10
]

{ #category : #tests }
MethodVariableTypeInfoTest >> test01RemovingAClassRemovesItFromMethodVariableRawTypesForParameter [

	self assertTypeIsRemovedFor: 'p1'
]

{ #category : #tests }
MethodVariableTypeInfoTest >> test02RemovingAClassRemovesItsClassFromMethodVariableRawTypesForParameter [

	| classToRemove typeInfo |

	LiveTypingTestFactory removeTestDataClassCategoryAfter: [ :testFactory |
		classToRemove := testFactory createClassToBeRemoved.
		self methodWithParameterOfClassToRemove: classToRemove.
	
		typeInfo := (self class compiledMethodAt: #methodWithParameterOfClassToRemove:) typeInfoOfVariableNamed: 'p1'.
		
		self assert: typeInfo typesSize equals: 1.
		self assert: (typeInfo typesIncludes: classToRemove class).
		
		classToRemove removeFromSystem.
		
		self assert: typeInfo isTypesEmpty ]
]

{ #category : #tests }
MethodVariableTypeInfoTest >> test03RemovingAClassRemovesItFromMethodVariablesRawTypes [

	self assertTypeIsRemovedFor: 'tempNotInRemoteVector'
]

{ #category : #tests }
MethodVariableTypeInfoTest >> test04RemovingAClassRemovesItFromMethodVariableRemoteVectorRawTypes [

	self assertTypeIsRemovedFor: 'tempInRemoteVector'
]
