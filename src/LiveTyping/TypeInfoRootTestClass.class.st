Class {
	#name : #TypeInfoRootTestClass,
	#superclass : #Object,
	#instVars : [
		'ivroot'
	],
	#category : #'LiveTyping-Tests'
}

{ #category : #'raw types size' }
TypeInfoRootTestClass class >> instanceVariableRawTypesSizeFor: anInstVarName [

	^ 2
]

{ #category : #'test data' }
TypeInfoRootTestClass >> implementedOnAll: p1 [

	self subclassResponsibility 
]

{ #category : #'test data' }
TypeInfoRootTestClass >> implementedOnRootAndSibling1: p1 [

	^p1
]

{ #category : #'test data' }
TypeInfoRootTestClass >> implementedOnRootOnly: p1 [
]

{ #category : #'test data' }
TypeInfoRootTestClass >> implementedOnSibling1Only [

	self subclassResponsibility 
]

{ #category : #'test data' }
TypeInfoRootTestClass >> ivroot: anObject [

	ivroot := anObject 
]
