Class {
	#name : #LiveTypingSmalltalkCompleter,
	#superclass : #Object,
	#category : #LiveTyping
}

{ #category : #testing }
LiveTypingSmalltalkCompleter class >> isForCurrentTypeSystem [

	^ Smalltalk isLiveTypingInstalled 
]

{ #category : #'return type' }
LiveTypingSmalltalkCompleter >> commonSupertypeOrSelectorsOf: aNodeUnderCursor in: aMethodNode [  
	
	| methodToAnalyze types methodClass |
	
	methodClass := aMethodNode encoder classEncoding.
	methodToAnalyze := methodClass compiledMethodAt: aMethodNode selector ifAbsent: [ NotImplementedMethod class: methodClass selector: aMethodNode selector ].
	
	types := (aNodeUnderCursor typesIn: methodToAnalyze addingIncompleteTypeInfoTo: Set new) asArray.
	
	^ VariableTypeInfo new initializeRawTypes: types.
	

]

{ #category : #'message entries - private' }
LiveTypingSmalltalkCompleter >> computeEntriesOfUnaryMessageReturnNamed: aSelector at: aRange [ 
	
	| typeInfo |
	
	typeInfo := self
		withMethodNodeDo: [ :methodNode | self returnTypeOfNodeUnderCursorIn: methodNode at: aRange end]
		ifError: [ :anError | nil ].
	self computeMessageEntriesForTypeInfoOrNil: typeInfo
]

{ #category : #'message entries - private' }
LiveTypingSmalltalkCompleter >> computeMessageEntriesForCommonSupertype: commonSupertype of: aVariableTypeInfo [
	
	| selectorsCollector |
	
	selectorsClasses := aVariableTypeInfo types.
	selectorsCollector := AutoCompleterSelectorsCollector for: prefix.
	entries := selectorsCollector
		addSelectorsOf: commonSupertype upTo: Object;
		addSelectorsOfAll: selectorsClasses upTo: commonSupertype;
		addSelectorsOf: Object;
		entriesToShow.
		
	possibleInvalidSelectors := selectorsCollector possibleInvalidSelectors.
	
	self ifEmptyEntriesShowAllPrefixedSelectors

]

{ #category : #'message entries - private' }
LiveTypingSmalltalkCompleter >> computeMessageEntriesForGenericSupertypeOf: aVariableTypeInfo [
			
	 | prefixedSelectors selectorsCollector | 

	selectorsClasses := aVariableTypeInfo types.
	selectorsClasses isEmpty ifTrue: [ ^self computeMessageEntriesForUnknowClass ].
	
	prefixedSelectors := aVariableTypeInfo commonSelectorsPreviousToObject select: [ :aSelector | aSelector beginsWith: prefix ].
	
	selectorsCollector := AutoCompleterSelectorsCollector for: prefix.
	
	entries := selectorsCollector 
		addedSelectors: prefixedSelectors;
		addSelectorsOfAll: selectorsClasses upTo: Object;
		addSelectorsOf: Object;		
		entriesToShow.
		
	prefixedSelectors notEmpty ifTrue: [
		entries addAllFirst: prefixedSelectors asSortedCollection.
		entries size > 1 ifTrue: [ entries addFirst: '-- common selectors excluding Object' ].
	 ].
		
	possibleInvalidSelectors := selectorsCollector possibleInvalidSelectors.
	
	self ifEmptyEntriesShowAllPrefixedSelectors
		
	
]

{ #category : #'message entries - private' }
LiveTypingSmalltalkCompleter >> computeMessageEntriesForTypeInfo: aVariableTypeInfo [ 

	aVariableTypeInfo 
		withCommonSupertypeDo: [ :commonSupertype | self computeMessageEntriesForCommonSupertype: commonSupertype of: aVariableTypeInfo ]
		ifGeneric: [ :genericType | self computeMessageEntriesForGenericSupertypeOf: aVariableTypeInfo ]
			
]

{ #category : #'message entries - private' }
LiveTypingSmalltalkCompleter >> computeMessageEntriesForTypeInfoOrNil: aVariableTypeInfoOrNil [

	aVariableTypeInfoOrNil 
		ifNil: [ self computeMessageEntriesForUnknowClass ]
		ifNotNil: [ self computeMessageEntriesForTypeInfo: aVariableTypeInfoOrNil ]
	 
]

{ #category : #'message entries - private' }
LiveTypingSmalltalkCompleter >> computeMessageEntriesOfCascadeReceiverAt: aRange [

	 | positionBeforeSemiColon typeInfo |

	positionBeforeSemiColon := aRange end - 1.

	"I have to parse excluding the last semi-colon because if not a syntax error will be signaled 
	because the cascade message is not finished - Hernan"
	typeInfo := self
		withMethodNodeOf: (parser source first: positionBeforeSemiColon) 
		do: [ :methodNode | self typeOfCascadeReceiverIn: methodNode at: positionBeforeSemiColon ]
		ifError: [ :anError | nil ].

	self computeMessageEntriesForTypeInfoOrNil: typeInfo 
]

{ #category : #'message entries - private' }
LiveTypingSmalltalkCompleter >> computeMessageEntriesOfEnclosedExpressionReturnAt: aRange [ 

	 | typeInfo |

	typeInfo := self 
		withMethodNodeDo: [ :methodNode | self returnTypeOfEnclosedExpresionIn: methodNode at: aRange end - 1 ]
		ifError: [ :anError | nil ].

	self computeMessageEntriesForTypeInfoOrNil: typeInfo
]

{ #category : #'selector documentation' }
LiveTypingSmalltalkCompleter >> documentationOf: aMethod [

	^aMethod liveTypingAutoCompleterDocumentation
]

{ #category : #'return type' }
LiveTypingSmalltalkCompleter >> returnTypeOfEnclosedExpresionIn: methodNode at: aPosition [

	^ methodNode  
		withTopParseNodeIncluding: aPosition
		do: [ :aNodeUnderCursor | | nodeToAnalyze |
			nodeToAnalyze := aNodeUnderCursor isReturn ifTrue: [ aNodeUnderCursor expr ] ifFalse: [ aNodeUnderCursor ].
			self commonSupertypeOrSelectorsOf: nodeToAnalyze in: methodNode ]
		ifAbsent: [ nil ]
]

{ #category : #'return type' }
LiveTypingSmalltalkCompleter >> returnTypeOfNodeUnderCursorIn: methodNode at: aPosition [

	^methodNode
		withParseNodeIncluding: aPosition 
		do: [ :aNodeUnderCursor | self commonSupertypeOrSelectorsOf: aNodeUnderCursor in: methodNode ]
		ifAbsent: [ nil ]
]

{ #category : #'parse node manipulation' }
LiveTypingSmalltalkCompleter >> tryToRecoverFromSyntaxErrorWithMethodNodeDo: doBlock ifError: anErrorBlock [
	
	^ self withMethodNodeOf: parser allSource do: doBlock ifError: anErrorBlock 
	
]

{ #category : #'return type' }
LiveTypingSmalltalkCompleter >> typeOfCascadeReceiverIn: methodNode at: aPosition [ 

	^methodNode 
		withTopParseNodeIncluding: aPosition 
		do: [ :aNodeUnderCursor | self commonSupertypeOrSelectorsOf: aNodeUnderCursor receiverOrCascadeReceiver in: methodNode ]
		ifAbsent: [ nil ].
		
]

{ #category : #'parse node manipulation' }
LiveTypingSmalltalkCompleter >> withMethodNodeDo: doBlock ifError: anErrorBlock [

	^ self 
		withMethodNodeOf: parser source 
		do: doBlock 
		ifError: [ :anError |
			(anError isKindOf: SyntaxErrorNotification) 
				ifTrue: [ self tryToRecoverFromSyntaxErrorWithMethodNodeDo: doBlock ifError: anErrorBlock ]
				ifFalse: [ anErrorBlock value: anError ]]
	
]

{ #category : #'parse node manipulation' }
LiveTypingSmalltalkCompleter >> withMethodNodeOf: aSourceCode do: doBlock ifError: anErrorBlock [

	^ [[ doBlock value: (parser classOrMetaClass methodNodeFor: aSourceCode) ] 
		on: UndeclaredVariableReference 
		do: [  :anUndeclareVariableReference | anUndeclareVariableReference declareTempAndResume ]]
		on: Error
		do: anErrorBlock
		
	
]
