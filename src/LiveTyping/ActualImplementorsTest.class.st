Class {
	#name : #ActualImplementorsTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-Tests'
}

{ #category : #tests }
ActualImplementorsTest >> test01WhenIsImplementedOnlyInRootReturnsThatImplementorOnly [

	| implementors  |
	
	implementors := Smalltalk actualImplementorsOf: #implementedOnRootOnly: in: TypeInfoRootTestClass.
	
	self assert: implementors size equals: 1.
	self assert: (implementors includes: (MethodReference method: TypeInfoRootTestClass >> #implementedOnRootOnly:))
]

{ #category : #tests }
ActualImplementorsTest >> test02ReturnsImplementorsOfSuperclasses [

	| implementors  |
	
	implementors := Smalltalk actualImplementorsOf: #implementedOnRootOnly: in: TypeInfoSibling1TestClass.
	
	self assert: implementors size equals: 1.
	self assert: (implementors includes: (MethodReference method: TypeInfoRootTestClass >> #implementedOnRootOnly:))
]

{ #category : #tests }
ActualImplementorsTest >> test03IfNotImplementedInRootOrSuperclassesDoesNotIncludeSubclassesImplementations [

	| implementors  |
	
	implementors := Smalltalk actualImplementorsOf: #implementedOnRootOnly: in: Object.
	
	self assert: 2 equals: implementors size.
	self assert: (implementors includes: (NotImplementedMethod class: Object selector: #implementedOnRootOnly:)).
	self assert: (implementors includes: (MethodReference class: TypeInfoRootTestClass selector: #implementedOnRootOnly:)).

]

{ #category : #tests }
ActualImplementorsTest >> test04IncludesSubclassesImplementations [

	| implementors  |
	
	implementors := Smalltalk actualImplementorsOf: #implementedOnRootAndSibling1: in: TypeInfoRootTestClass.
	
	self assert: implementors size equals: 2.
	self assert: (implementors includes: (MethodReference class: TypeInfoRootTestClass selector: #implementedOnRootAndSibling1:)).
	self assert: (implementors includes: (MethodReference class: TypeInfoSibling1TestClass selector: #implementedOnRootAndSibling1:)).
]

{ #category : #tests }
ActualImplementorsTest >> test05DoesNotIncludeImplementorsOfSubclassesNotDefinedInSuperclass [

	| implementors  |
	
	implementors := Smalltalk actualImplementorsOf: #implementedOnSibling1AndSibling2: in: TypeInfoRootTestClass.
	
	self assert: implementors size equals: 3.
	self assert: (implementors includes: (NotImplementedMethod class: TypeInfoRootTestClass selector: #implementedOnSibling1AndSibling2:)).
	self assert: (implementors includes: (MethodReference class: TypeInfoSibling1TestClass selector: #implementedOnSibling1AndSibling2:)).
	self assert: (implementors includes: (MethodReference class: TypeInfoSibling2TestClass selector: #implementedOnSibling1AndSibling2:))
]

{ #category : #tests }
ActualImplementorsTest >> test06DoesNotIncludeImplementorsOfSiblingsWhenNotDefinedInSuperclass [

	| implementors  |
	
	implementors := Smalltalk actualImplementorsOf: #implementedOnSibling1AndSibling2: in: TypeInfoSibling1TestClass.
	
	self assert: implementors size equals: 1.
	self assert: (implementors includes: (MethodReference class: TypeInfoSibling1TestClass selector: #implementedOnSibling1AndSibling2:))
]

{ #category : #tests }
ActualImplementorsTest >> test07ReturnsAllSubclassesImplementorsOfTheHighestImplementorClass [

	| implementors  |
	
	implementors := Smalltalk actualImplementorsOf: #implementedOnAll: in: TypeInfoSibling1TestClass.
	
	self assert: implementors size equals: 3.
	self assert: (implementors includes: (MethodReference class: TypeInfoRootTestClass selector: #implementedOnAll:)).
	self assert: (implementors includes: (MethodReference class: TypeInfoSibling1TestClass selector: #implementedOnAll:)).
	self assert: (implementors includes: (MethodReference class: TypeInfoSibling2TestClass selector: #implementedOnAll:))
]

{ #category : #tests }
ActualImplementorsTest >> test08highestClassImplementingSelectorReturnsHighgestClass [

	self assert: (OrderedCollection highestClassImplementing: #at:put: ifNone: [ self fail ]) equals: Object
]

{ #category : #tests }
ActualImplementorsTest >> test09WhenNoHighestClassImplementingSelectorIfNoneBlockIsEvaluated [

	self assert: (OrderedCollection highestClassImplementing: #none ifNone: [ true ])
]
