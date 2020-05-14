Class {
	#name : #AssignmentNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
AssignmentNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^value typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons 
]

{ #category : #'as yet unclassified' }
AssignmentNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: aTypeCastApplier [ 

	^value typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: aTypeCastApplier 

]
