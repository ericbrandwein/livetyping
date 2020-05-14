Class {
	#name : #ParseNodeTypeInfo,
	#superclass : #Object,
	#instVars : [
		'parseNodeToAnalize',
		'typeInfo',
		'method'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
ParseNodeTypeInfo class >> of: aParseNode in: aCompiledMethod [ 

	^self new initializeOf: aParseNode in: aCompiledMethod 

]

{ #category : #initialization }
ParseNodeTypeInfo >> initializeOf: aParseNode in: aCompiledMethod [ 

	parseNodeToAnalize := aParseNode.
	method := aCompiledMethod 
]

{ #category : #'type info' }
ParseNodeTypeInfo >> resetTypeInfo [

	typeInfo := nil
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitAssignmentNode: anAssignmentNode [
	
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitBlockNode: aBlockNode [
	
		
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitBraceNode: aBraceNode [
	
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitCascadeNode: aCascadeNode [
	
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitInstanceVariableNode: anInstanceVariableNode [

	typeInfo := method methodClass typeInfoOfInstanceVariableNamed: anInstanceVariableNode name ifAbsent: [ self resetTypeInfo ]
	
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitLiteralNode: aLiteralNode [
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitLiteralVariableNode: aLiteralVariableNode [
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitMessageNode: aMessageNode [
	
	| implementors receiverTypes |
	
	receiverTypes := aMessageNode receiverOrCascadeReceiver typesIn: method addingIncompleteTypeInfoTo: Set new.
	implementors := IdentitySet new.
	receiverTypes do: [ :aType | (aType lookupSelector: aMessageNode selectorSymbol) ifNotNil: [ :implementor | implementors add: implementor ]].
	
	implementors size = 1 ifTrue: [ typeInfo := implementors anyOne returnTypeInfo ]
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitMessageNodeInCascade: aMessageNode [
	
	"does it with visitMessageNode - Hernan"
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitMethodNode: aMethodNode [
	
	"Used when cursor is in method selector - Hernan"
	
	typeInfo := method returnTypeInfo 
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitNewArrayNode: aNewArrayNode [
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitRemoteTempVectorNode: aRemoteTempVectorNode [
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitReturnNode: aReturnNode [
	
	typeInfo := method returnTypeInfo 
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitSelectorNode: aSelectorNode [
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitTempVariableNode: aTempVariableNode [

	typeInfo := method typeInfoOfVariableNamed: aTempVariableNode name ifAbsent: [ self resetTypeInfo ]
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitUndeclaredVariableNode: aVariableNode [
]

{ #category : #visiting }
ParseNodeTypeInfo >> visitVariableNode: aVariableNode [


]

{ #category : #'type info' }
ParseNodeTypeInfo >> withTypeInfoDo: aBlock ifNone: aNoneBlock [

	self resetTypeInfo.
	parseNodeToAnalize accept: self.
	
	^typeInfo ifNotNil: aBlock ifNil: aNoneBlock.
	
	
]
