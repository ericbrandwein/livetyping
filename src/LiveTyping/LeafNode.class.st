Class {
	#name : #LeafNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
LeafNode >> isSameAs: aParseNode [

	^(super isSameAs: aParseNode) 
		or: [ (aParseNode isKindOf: self class) and: [ key = aParseNode key ]]
]

{ #category : #'as yet unclassified' }
LeafNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [  

	^#()
]
