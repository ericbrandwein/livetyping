Class {
	#name : #ChangeSelector,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
ChangeSelector class >> addActualImplementorsOf: anOldSelector forTypes: receiverTypes to: implementors andActualSendersTo: senders inSystem: aSystem [

	| actualImplementors actualSendersCollector |

	receiverTypes do: [ :aType |
		actualImplementors := (aSystem actualImplementorsOf: anOldSelector in: aType) collect: [ :anImplementor | anImplementor compiledMethod ].
		implementors addAll: actualImplementors ].
	
	actualSendersCollector := MultiImplementorsActualMessageSendsCollector for: implementors.
	actualSendersCollector value.
	
	senders addAll: actualSendersCollector messageList.
	
	
]

{ #category : #'as yet unclassified' }
ChangeSelector class >> addActualImplementorsOf: anOldSelector in: aPotentialClassToRefactor to: implementors andActualSendersTo: senders inSystem: aSystem [ 
	
	self 
		addActualImplementorsOf: anOldSelector 
		forTypes: { aPotentialClassToRefactor }
		to: implementors 
		andActualSendersTo: senders 
		inSystem: aSystem 
]

{ #category : #'as yet unclassified' }
ChangeSelector class >> assertReceiverTypesOfAll: aCollectionOfSenders areIncludedInAllTypesOf: aCollectionOfImplementors [

	| messageSendsWithInvalidReceiverTypes | 
		
	messageSendsWithInvalidReceiverTypes := (ReceiverTypesOfMessageSendsConform from: aCollectionOfSenders to: aCollectionOfImplementors) value.
	messageSendsWithInvalidReceiverTypes notEmpty ifTrue: [ self signalReceiverTypesNotIncludedInImplementorTypes: messageSendsWithInvalidReceiverTypes ].
]

{ #category : #'as yet unclassified' }
ChangeSelector class >> errorDescriptionForReceiverTypesNotIncludedInImplementorTypes: messageSendsWithInvalidReceiverTypes [

	^String streamContents: [ :stream |
		stream nextPutAll: 'There are receiver types of message sends not included in implementor types'; newLine.
		messageSendsWithInvalidReceiverTypes do: [ :array |
			array first printClassAndSelectorOn: stream.
			stream 
				nextPutAll: ' - Message send: '; 
				print: array second;
				nextPutAll: ' - Types: ';
				nextPutAll: array third asCommaSeparated: [ :type | stream nextPutAll: type name ];
				newLine]] 
		 
]

{ #category : #'as yet unclassified' }
ChangeSelector class >> signalReceiverTypesNotIncludedInImplementorTypes: messageSendsWithInvalidReceiverTypes [ 
	
	CanNotChangeSelectorWithNotIncludedTypes signalWith: messageSendsWithInvalidReceiverTypes
		
]
