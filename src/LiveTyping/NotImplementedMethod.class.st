Class {
	#name : #NotImplementedMethod,
	#superclass : #Object,
	#category : #LiveTyping
}

{ #category : #'string version' }
NotImplementedMethod class >> notImplementedStringVersionHeader [
	
	^'(Not implemented) - '
]

{ #category : #senders }
NotImplementedMethod >> actualSendersOf: aCompiledMethod [ 

	^#()
]

{ #category : #testing }
NotImplementedMethod >> doesOnlySurelySend: aCompiledMethod [ 
	
	^false
]

{ #category : #'auto complete' }
NotImplementedMethod >> dynamicTypingAutoCompleterDocumentation [

	^'' asText
]

{ #category : #'auto complete' }
NotImplementedMethod >> liveTypingAutoCompleterDocumentation [

	^'' asText
]

{ #category : #'compiled method protocol' }
NotImplementedMethod >> returnTypes [
	
	^#()
]

{ #category : #setting }
NotImplementedMethod >> setStandardClass: aClass methodSymbol: aSelector [

	super setStandardClass: aClass methodSymbol: aSelector.
	self prefixStringVersionWith: self class notImplementedStringVersionHeader 
]

{ #category : #'compiled method protocol' }
NotImplementedMethod >> typesOfInstanceVariableNamed: anInstVarName ifAbsent: aBlock [

	^self actualClass typesOfInstanceVariableNamed: anInstVarName ifAbsent: aBlock
]

{ #category : #'compiled method protocol' }
NotImplementedMethod >> typesOfVariableNamed: aVarName ifAbsent: aBlockClosure [ 
	
	"I have not been compiled yet, so there is no info about parameters or temps - Hernan"
	^aBlockClosure value
]
