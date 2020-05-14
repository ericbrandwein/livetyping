Class {
	#name : #ParseNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
ParseNode >> identifierPrintString [
	
	^String streamContents: [ :stream | self printOn: stream indent: 0 ]
]

{ #category : #'as yet unclassified' }
ParseNode >> isLiteralVariableNode [

	^false
]

{ #category : #'as yet unclassified' }
ParseNode >> isNotNil [
	
	^false
]

{ #category : #'as yet unclassified' }
ParseNode >> isSameAs: aParseNode [

	"I had to create this message because originalReceiver is MessageNode is a copy of the receiver (I don't 
	undertand why it makes a copy but I can not change that, it is too risky) and it cascade messages I have 
	to use the originalReceiver to get the receiver of the message. So this message has to be reimplemented
	in those nodes that are the same no matter if they are a copy. See LeafNode for example - Hernan"
	^self = aParseNode 
]

{ #category : #'as yet unclassified' }
ParseNode >> nodeTypeAndIdentifierPrintString [
	
	^String streamContents: [ :stream | 
		stream
			nextPutAll: self nodeTypePrintString;
			space;
			nextPutAll: self identifierPrintString ]
]

{ #category : #'as yet unclassified' }
ParseNode >> nodeTypePrintString [
	
	^''
]

{ #category : #'as yet unclassified' }
ParseNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [

	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
ParseNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons castingWith: aTypeCastApplier [ 

	^aTypeCastApplier applyTo: self with: (self typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons)
]
