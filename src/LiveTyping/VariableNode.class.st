Class {
	#name : #VariableNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
VariableNode >> nodeTypePrintString [

	^'pseudo var'
]

{ #category : #'as yet unclassified' }
VariableNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	self isSelfPseudoVariable ifTrue: [ ^aCompiledMethod methodClass withAllSubclasses ].
	self isSuperPseudoVariable ifTrue: [ ^aCompiledMethod methodClass superclass withAllSubclasses ].
	self isTruePseudoVariable ifTrue: [ ^Array with: true class ].
	self isFalsePseudoVariable ifTrue: [ ^Array with: false class ].
	self isThisContextPseudoVariable ifTrue: [ ^Array with: thisContext class ]. 
	self isNilPseudoVariable ifTrue: [ ^Array with: nil class ]. 
	
	self error: 'Unsupported variable node'
]
