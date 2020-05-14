Class {
	#name : #MethodVariableTypeInfo,
	#superclass : #VariableTypeInfo,
	#instVars : [
		'method',
		'variableName'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
MethodVariableTypeInfo class >> of: aVarName in: aCompiledMethod are: rawTypes [

	^self new initializeOf: aVarName in: aCompiledMethod are: rawTypes

]

{ #category : #identification }
MethodVariableTypeInfo >> identifier [

	^method -> self variableName 
]

{ #category : #initialization }
MethodVariableTypeInfo >> initializeOf: aVarName in: aCompiledMethod are: aRawTypes [

	variableName := aVarName.
	method := aCompiledMethod.
	self initializeRawTypes: aRawTypes 
]

{ #category : #identification }
MethodVariableTypeInfo >> variableName [

	^variableName 
]
