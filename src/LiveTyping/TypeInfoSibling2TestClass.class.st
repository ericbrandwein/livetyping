Class {
	#name : #TypeInfoSibling2TestClass,
	#superclass : #TypeInfoRootTestClass,
	#category : #'LiveTyping-Tests'
}

{ #category : #'raw types size' }
TypeInfoSibling2TestClass class >> instanceVariableRawTypesSizeFor: anInstVarName [

	^ 3
]

{ #category : #'test data' }
TypeInfoSibling2TestClass >> implementedOnAll: p1 [

	^1/2
]

{ #category : #'test data' }
TypeInfoSibling2TestClass >> implementedOnSibling1AndSibling2: p1 [
]
