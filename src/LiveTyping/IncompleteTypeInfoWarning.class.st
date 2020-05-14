Class {
	#name : #IncompleteTypeInfoWarning,
	#superclass : #IncompleteTypeInfo,
	#category : #LiveTyping
}

{ #category : #'instance creation' }
IncompleteTypeInfoWarning class >> dueToNoReturnTypeOf: aMethodReference [ 
	
	^self of: aMethodReference describedAs: (self noReturnTypesDescriptionOf: aMethodReference)
]

{ #category : #'error descriptions' }
IncompleteTypeInfoWarning class >> noReturnTypesDescriptionOf: aMethodReference [ 
	
	^'There is no return type info for ', aMethodReference classAndSelector
]

{ #category : #'as yet unclassified' }
IncompleteTypeInfoWarning >> addTo: aMethodTypeCheckerVisitor node: aMessageNode [ 
	
	aMethodTypeCheckerVisitor addProblem: self node: aMessageNode 
]
