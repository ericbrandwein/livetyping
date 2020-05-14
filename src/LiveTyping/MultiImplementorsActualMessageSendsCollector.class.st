Class {
	#name : #MultiImplementorsActualMessageSendsCollector,
	#superclass : #Object,
	#instVars : [
		'sentImplementors',
		'sendersInfo',
		'completeSureSenders',
		'partialSureSenders',
		'possibleSenders',
		'messageList',
		'numberOfTitles'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
MultiImplementorsActualMessageSendsCollector class >> for: sentImplementors [ 

	^self new initializeFor: sentImplementors 
]

{ #category : #'instance creation' }
MultiImplementorsActualMessageSendsCollector class >> on: sentSelector forAll: types whenSomeAreNotImplemented: notImplementedBlock whenNoImplementors: noImplementorsBlock [

	| notImplemented sentImplementors |
	
	notImplemented := Set new.
	sentImplementors := types 
		inject: Set new 
		into: [ :sentCompiledMethods :type | 
			(type lookupSelector: sentSelector) 
				ifNil: [ notImplemented add: type name ] 
				ifNotNil: [ :implementor | sentCompiledMethods add: implementor ].
			sentCompiledMethods ].
	
	notImplemented notEmpty ifTrue: [ notImplementedBlock value: notImplemented ].
	sentImplementors ifEmpty: noImplementorsBlock.
	
	^self for: sentImplementors 
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> addCompleteSureSendersToMessageList [

	completeSureSenders notEmpty ifTrue: [
		sentImplementors size > 1 ifTrue: [
			numberOfTitles := 1.
			messageList add: (self methodReferenceForTitle: '-- Senders of all implementors --') ].
		messageList addAll: (completeSureSenders asSortedCollection: [ :left :right | left stringVersion < right stringVersion ]) ].
	
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> addPartialSureSendersToMessageList [

	(partialSureSenders keys asSortedCollection: [ :left :right | left size > right size ]) do: [ :implementors |
		numberOfTitles := numberOfTitles + 1.
		messageList add: (self methodReferenceTitleForImplementors: implementors).
		messageList addAll: ((partialSureSenders at: implementors) asSortedCollection: [ :left :right | left stringVersion < right stringVersion ]) ].

]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> addPossibleSendersToMessageList [

	possibleSenders notEmpty ifTrue: [
		numberOfTitles := numberOfTitles + 1.
		messageList add: (self methodReferenceForTitle: '-- Possible senders --').
		messageList addAll: (possibleSenders values asSortedCollection: [ :left :right | left stringVersion < right stringVersion ]) ].

		

]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> addToCompleteSureSenders: aSenderInfo [

	completeSureSenders add: aSenderInfo sender 
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> addToPartialSureSenders: aSenderInfo [

	| sureSendersOfPartialImplementors | 

	sureSendersOfPartialImplementors := partialSureSenders at: aSenderInfo sureSenders ifAbsentPut: [ Set new ]. 
	sureSendersOfPartialImplementors add: aSenderInfo sender 
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> addToPossibleSenders: aSenderInfo [

	| possibleSender | 
	
	possibleSender := possibleSenders 
		at: aSenderInfo sender 
		ifAbsentPut: [ PossibleSender in: aSenderInfo sender withPossibleMessageSends: #() ].
	
	aSenderInfo withPossibleMessageSendsDo: [:aPossibleMessageSend | possibleSender addPossibleMessageSends: aPossibleMessageSend ]
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> calculatePossibleSendersOf: aSentImplementor from: aPossibleSenders [

	| senderInfo |
	
	aPossibleSenders do: [ :aPossibleSender | 
		senderInfo := sendersInfo at: aPossibleSender ifAbsentPut: [ SenderInfo of: aPossibleSender for: sentImplementors ].
		senderInfo addPossibleSender: aPossibleSender of: aSentImplementor ]
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> calculateSendersInfo [
	
	sendersInfo := Dictionary new.	
	sentImplementors do: [ :aSentImplementor | self calculateSendersInfoOf: aSentImplementor ].
	

]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> calculateSendersInfoOf: aSentImplementor [

	| actualSenders | 
	
	actualSenders := Smalltalk allActualSendersOn: aSentImplementor.
	
	self 
		calculateSureSendersOf: aSentImplementor from: actualSenders first;
		calculatePossibleSendersOf: aSentImplementor from: actualSenders second.
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> calculateSureSendersOf: aSentImplementor from: aSureSenders [

	| senderInfo |
	
	aSureSenders do: [ :aMethodReference | 
		senderInfo := sendersInfo at: aMethodReference ifAbsentPut: [ SenderInfo of: aMethodReference for: sentImplementors ].
		senderInfo addSureSenderOf: aSentImplementor. ].

]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> createMessageList [

	messageList := OrderedCollection new.
	numberOfTitles := 0.
	
	self 
		addCompleteSureSendersToMessageList;
		addPartialSureSendersToMessageList;
		addPossibleSendersToMessageList
		

]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> groupSenderByTypeFor: aSenderInfo [
	
	aSenderInfo hasCompleteSureSenders ifTrue: [ self addToCompleteSureSenders: aSenderInfo ].
	aSenderInfo hasPartialSureSenders ifTrue: [ self addToPartialSureSenders: aSenderInfo ].
	aSenderInfo hasPossibleSenders ifTrue: [ self addToPossibleSenders: aSenderInfo ].



]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> groupSendersByType [

	completeSureSenders := Set new.
	partialSureSenders := Dictionary new. 
	possibleSenders := Dictionary new. 
	
	sendersInfo valuesDo: [ :aSenderInfo | self groupSenderByTypeFor: aSenderInfo ].
	
]

{ #category : #initialization }
MultiImplementorsActualMessageSendsCollector >> initializeFor: aSentImplementors [ 

	sentImplementors := aSentImplementors 
]

{ #category : #'message list' }
MultiImplementorsActualMessageSendsCollector >> messageList [
	
	^messageList
]

{ #category : #'message list' }
MultiImplementorsActualMessageSendsCollector >> messageListSize [
	
	^messageList size - numberOfTitles 
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> methodReferenceForTitle: aTitle [

	^ (MethodReference class: Object selector: ('_', numberOfTitles printString) asSymbol) 
		stringVersion: aTitle;
		yourself
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> methodReferenceTitleForImplementors: implementors [

	^self methodReferenceForTitle: (self titleForImplementors: implementors)
]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> sentImplementorsAsString [
	
	| sentImplementorsClassNames |
	
	sentImplementorsClassNames := sentImplementors collect: [:aSentImplementor | aSentImplementor methodClass name ].
	
	^sentImplementorsClassNames asCommaStringAnd

]

{ #category : #'evaluating - private' }
MultiImplementorsActualMessageSendsCollector >> titleForImplementors: implementors [

	^String streamContents: [ :stream |
		stream 
			nextPutAll: '-- Sender(s) of ';
			nextPutAll: implementors asCommaSeparated: [ :aMethod | aMethod printClassAndSelectorOn: stream ];
			nextPutAll: ' --' ]
]

{ #category : #evaluating }
MultiImplementorsActualMessageSendsCollector >> value [

	self 
		calculateSendersInfo;
		groupSendersByType;
		createMessageList 
]
