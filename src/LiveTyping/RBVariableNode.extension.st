Extension { #name : #RBVariableNode }

{ #category : #'*LiveTyping' }
RBVariableNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^aCompiledMethod typesOfVariableNamed: name ifAbsent: [ #() ]
]
