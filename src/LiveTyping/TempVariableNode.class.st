Class {
	#name : #TempVariableNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
TempVariableNode >> nodeTypePrintString [

	^self isArg
		ifTrue: [ 'parameter' ]
		ifFalse: [ 'temporary' ]
]

{ #category : #'as yet unclassified' }
TempVariableNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^aCompiledMethod typesOfVariableNamed: name ifAbsent: [ #() ]
]
