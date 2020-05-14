Class {
	#name : #InstanceVariableNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
InstanceVariableNode >> nodeTypePrintString [

	^'inst var'
]

{ #category : #'as yet unclassified' }
InstanceVariableNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^ aCompiledMethod typesOfInstanceVariableNamed: name ifAbsent: [ #() ]
]
