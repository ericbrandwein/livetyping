Class {
	#name : #IncompleteTypeInfoError,
	#superclass : #IncompleteTypeInfo,
	#category : #LiveTyping
}

{ #category : #'instance creation' }
IncompleteTypeInfoError class >> dueToMissingImplementationOf: aMethodReference [ 
	
	^self of: aMethodReference describedAs: (self missingImplementationDescriptionOf: aMethodReference)
]

{ #category : #'error descriptions' }
IncompleteTypeInfoError class >> missingImplementationDescriptionOf: aMethodReference [ 
	
	^'#', aMethodReference selector, ' not implemented in ', aMethodReference actualClass name
]

{ #category : #'as yet unclassified' }
IncompleteTypeInfoError >> addTo: aMethodTypeCheckerVisitor node: aMessageNode [ 
	
	aMethodTypeCheckerVisitor addWarning: self node: aMessageNode 
]
