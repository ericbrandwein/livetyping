Class {
	#name : #MethodNode,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
MethodNode >> actualMessageSendKeywordAndParameterPositionsOfAll: compiledMethods at: aParameterIndex of: aSelector ifAbsent: absentBlock withPossibleMessageSends: shouldAddPossibleMessageSends [ 
	
	^encoder 
		actualMessageSendKeywordAndParameterPositionsOfAll: compiledMethods 
		at: aParameterIndex 
		of: aSelector
		ifAbsent: absentBlock 
		withPossibleMessageSends: shouldAddPossibleMessageSends 
		using: self
	
	
]

{ #category : #'as yet unclassified' }
MethodNode >> actualMessageSendKeywordPositionsOfAll: compiledMethods at: aKeywordIndex ifAbsent: absentBlock withPossibleMessageSends: shouldAddPossibleMessageSends [

	^encoder actualMessageSendKeywordPositionsOfAll: compiledMethods at: aKeywordIndex ifAbsent: absentBlock withPossibleMessageSends: shouldAddPossibleMessageSends using: self

]

{ #category : #'as yet unclassified' }
MethodNode >> actualMessageSendLastPositionsOfAll: compiledMethods ifAbsent: absentBlock withPossibleMessageSends: shouldAddPossibleMessageSends [  

	^encoder actualMessageSendLastPositionsOfAll: compiledMethods ifAbsent: absentBlock withPossibleMessageSends: shouldAddPossibleMessageSends using: self

]

{ #category : #'as yet unclassified' }
MethodNode >> actualMessageSendsSelectorPositionsOfAll: compiledMethods ifAbsent: aBlock withPossibleMessageSends: shouldAddPossibleMessageSends [ 

	^encoder actualMessageSendsSelectorPositionsOfAll: compiledMethods ifAbsent: aBlock withPossibleMessageSends: shouldAddPossibleMessageSends using: self

]

{ #category : #'as yet unclassified' }
MethodNode >> identifierPrintString [

	^self selectorNode identifierPrintString .
	
]

{ #category : #'as yet unclassified' }
MethodNode >> nodeTypePrintString [
	
	^'method'
]

{ #category : #'as yet unclassified' }
MethodNode >> topBlockTempsMap [
	
	self blockExtentsToTempsMap associationsDo: [ :anAssociation | anAssociation key first = 0 ifTrue: [ ^anAssociation value ]].
	
	self error: 'Should not happen, there is always a topContext'
]

{ #category : #'as yet unclassified' }
MethodNode >> topParseNodeIncluding: aPosition ifAbsent: anAbsentBlock [

	^encoder topParseNodeIncluding: aPosition ifAbsent: anAbsentBlock

]

{ #category : #'as yet unclassified' }
MethodNode >> typesIn: aCompiledMethod addingIncompleteTypeInfoTo: incompleteTypeInfoReasons [
 
	"I assume that if somebody wants the types of a method it is looking for the return types - Hernan"
	^aCompiledMethod returnTypes 
]

{ #category : #'as yet unclassified' }
MethodNode >> withTopParseNodeIncluding: aPosition do: aBlock ifAbsent: anAbsentBlock [

	| nodeAndPosition |
	
	nodeAndPosition :=self topParseNodeIncluding: aPosition ifAbsent: [ ^ anAbsentBlock value ].
	^aBlock value: nodeAndPosition key.
]
