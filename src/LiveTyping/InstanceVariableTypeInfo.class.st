Class {
	#name : #InstanceVariableTypeInfo,
	#superclass : #VariableTypeInfo,
	#instVars : [
		'class',
		'variableName'
	],
	#category : #LiveTyping
}

{ #category : #'as yet unclassified' }
InstanceVariableTypeInfo class >> of: anInstVarName in: aClass are: rawTypes [

	^self new initializeOf: anInstVarName in: aClass are: rawTypes

]

{ #category : #initialization }
InstanceVariableTypeInfo >> addTypeFrom: anInstance [

	| instVarType |
	
	instVarType := (anInstance instVarNamed: variableName) class.
	self addType: instVarType ifFull: []
]

{ #category : #identification }
InstanceVariableTypeInfo >> identifier [

	^class->self variableName 
]

{ #category : #initialization }
InstanceVariableTypeInfo >> initializeOf: anInstVarName in: aClass are: aRawTypes [

	variableName := anInstVarName.
	class := aClass.
	self initializeRawTypes: aRawTypes 
]

{ #category : #identification }
InstanceVariableTypeInfo >> variableName [

	^variableName 
]
