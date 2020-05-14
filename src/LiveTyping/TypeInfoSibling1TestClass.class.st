Class {
	#name : #TypeInfoSibling1TestClass,
	#superclass : #TypeInfoRootTestClass,
	#instVars : [
		'ivsibling1'
	],
	#category : #'LiveTyping-Tests'
}

{ #category : #'raw types size' }
TypeInfoSibling1TestClass class >> instanceVariableRawTypesSizeFor: anInstVarName [

	^ 3
]

{ #category : #'test data' }
TypeInfoSibling1TestClass >> implementedOnAll: p1 [

	^1
]

{ #category : #'test data' }
TypeInfoSibling1TestClass >> implementedOnRootAndSibling1: p1 [
]

{ #category : #'test data' }
TypeInfoSibling1TestClass >> implementedOnSibling1AndSibling2: p1 [
]

{ #category : #'test data' }
TypeInfoSibling1TestClass >> implementedOnSibling1Only [

	^1
]

{ #category : #'test data' }
TypeInfoSibling1TestClass >> ivsibling1: anObject [
	"
	IVTISibling1 initializeInstanceVariablesRawTypes.
	self new ivsibling1: 1.0 
	"
	ivsibling1 := anObject 
]
