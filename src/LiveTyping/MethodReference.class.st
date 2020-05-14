Class {
	#name : #MethodReference,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
MethodReference >> actualSendersOf: aCompiledMethod [ 
	
	^self compiledMethod actualSendersOf: aCompiledMethod 
]

{ #category : #'as yet unclassified' }
MethodReference >> classAndSelector [

	^String streamContents: [:stream | self printClassAndSelectorOn: stream ]
]

{ #category : #'as yet unclassified' }
MethodReference >> doesOnlySurelySend: aCompiledMethod [ 
	
	^self compiledMethod doesOnlySurelySend: aCompiledMethod 
]

{ #category : #'as yet unclassified' }
MethodReference >> isAnnotatingTypes [
	
	^self compiledMethod isAnnotatingTypes 
]

{ #category : #'as yet unclassified' }
MethodReference >> isPossibleSender [

	^false
]

{ #category : #'as yet unclassified' }
MethodReference >> isPrimitive [
	
	^self compiledMethod isPrimitive 
]

{ #category : #'as yet unclassified' }
MethodReference >> liveTypingAutoCompleterDocumentation [
	
	^self compiledMethod liveTypingAutoCompleterDocumentation
]

{ #category : #'as yet unclassified' }
MethodReference >> methodNode [
	
	^self compiledMethod methodNode
]

{ #category : #'as yet unclassified' }
MethodReference >> methodReference [
	
	^self
]

{ #category : #'as yet unclassified' }
MethodReference >> prefixStringVersionWith: aString [

	stringVersion := aString, stringVersion 
]

{ #category : #'as yet unclassified' }
MethodReference >> primitive [
	
	^self compiledMethod primitive
]

{ #category : #'as yet unclassified' }
MethodReference >> rangesOf: aSentSelector whenSendTo: aReceiverTypes [

	| compiledMethod |
	
	compiledMethod := self compiledMethodIfAbsent: [ ^#() ].
	^compiledMethod sureMessageSendsRangesOf: aSentSelector whenSendTo: aReceiverTypes

]

{ #category : #'as yet unclassified' }
MethodReference >> sourceCodeRange [
	
	^#()
]

{ #category : #'as yet unclassified' }
MethodReference >> stringVersion: aString [

	stringVersion := aString 
]

{ #category : #'as yet unclassified' }
MethodReference >> typeCheck [
	
	^self compiledMethod typeCheck 
]
