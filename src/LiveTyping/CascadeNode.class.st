Class {
	#name : #CascadeNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
CascadeNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  

	| lastMessage |
	
	lastMessage := messages last.
	lastMessage receiver: receiver.
	
	^[ lastMessage typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons ]
		ensure: [ lastMessage receiver: nil ]
	
]
