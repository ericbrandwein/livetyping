Extension { #name : #RBLiteralValueNode }

{ #category : #'*LiveTyping' }
RBLiteralValueNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  
	
	^Array with: self value class
]
