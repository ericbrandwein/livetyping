Class {
	#name : #DynamicTypesTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #'test data' }
DynamicTypesTest >> createNewInstance [
	
	^self class new
]

{ #category : #tests }
DynamicTypesTest >> test01TypeConvertionForAClassReturnsSameClass [

	self assert: (Object asTypeFor: Array) equals: Object
]

{ #category : #tests }
DynamicTypesTest >> test02TypeConvertionForSelfTypeReturnsReceiversType [

	self assert: (SelfType new asTypeFor: Array) equals: Array
]

{ #category : #tests }
DynamicTypesTest >> test03TypeConvertionForClassTypeReturnsReceiversTypeClass [

	self assert: (ClassType new asTypeFor: Array) equals: Array class
]

{ #category : #tests }
DynamicTypesTest >> test04ClassMessageSendChainsClassType [

	|  method types |
	
	"To be sure that collects the return type - Hernan"
	self twoClassMessageSend.
	
	method := self class>>#twoClassMessageSend.
	types := method methodNode block statements first expr typesIn: method addingIncompleteTypeInfoTo: Set new.
	
	self assert: types size equals: 1.
	self assert: types anyOne equals: Metaclass.
	self assert: method returnTypes asSet equals: types
	
]

{ #category : #tests }
DynamicTypesTest >> test05TypeConvertionForInstanceTypeReturnsMetaclassSoleInstance [

	self assert: (InstanceType new asTypeFor: Array class) equals: Array 
]

{ #category : #tests }
DynamicTypesTest >> test06newTypeIsMetaclassSoleInstance [

	| method types |
	
	"To be sure that collects the return type - Hernan"
	self createNewInstance.

	method := self class>>#createNewInstance.
	types := method methodNode block statements first expr typesIn: method addingIncompleteTypeInfoTo: Set new.
	
	self assert: types size equals: 1.
	self assert: types anyOne equals: self class.
	self assert: method returnTypes asSet equals: types

]

{ #category : #tests }
DynamicTypesTest >> test07InstanceTypeReturnsClassWhenIsKindOfOfBehaviorButNotMeta [

	self assert: (InstanceType new asTypeFor: Behavior) equals: Behavior.
	self assert: (InstanceType new asTypeFor: ClassDescription) equals: ClassDescription.
	self assert: (InstanceType new asTypeFor: Class) equals: Class.
	self assert: (InstanceType new asTypeFor: Metaclass) equals: Metaclass.

]

{ #category : #tests }
DynamicTypesTest >> test08InstanceTypeErrorsWhenUsedWithNoBehavior [

	self 
		should: [ InstanceType new asTypeFor: Object ]
		raise: Error - MessageNotUnderstood 
		withMessageText: InstanceType onlyBehaviorsCanBeConvertedToInstanceTypeErrorDescription
]

{ #category : #tests }
DynamicTypesTest >> twoClassMessageSend [

	^self class class
]
