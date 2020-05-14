Class {
	#name : #ReceiverTypesOfMessageSendsConform,
	#superclass : #Object,
	#instVars : [
		'senders',
		'implementors',
		'sentSelector',
		'types',
		'currentSender',
		'notIncludedReceiverTypesInMessageSends',
		'currentSenderMethodClass'
	],
	#category : #'LiveTyping-Refactoring'
}

{ #category : #'instance creation' }
ReceiverTypesOfMessageSendsConform class >> from: aCollectionOfSenders to: aCollectionOfImplementors [

	^self new initializeFrom: aCollectionOfSenders to: aCollectionOfImplementors
]

{ #category : #'conforming definition' }
ReceiverTypesOfMessageSendsConform >> add: aMessageNode toNotIncludedReceiverTypesIfCorrespond: receiverTypes [ 

	| notIncludedTypes |
	
	notIncludedTypes := self receiverTypesThatShouldRenameButAreNotIncludedInImplementorTypes: receiverTypes.
	notIncludedTypes ifNotEmpty: [ notIncludedReceiverTypesInMessageSends add: (Array with: currentSender with: aMessageNode with: notIncludedTypes) ]

]

{ #category : #'conforming definition' }
ReceiverTypesOfMessageSendsConform >> anyImplementorIsTypeOrSuperTypeOf: aReceiverType [ 

	^types anySatisfy: [ :anImplementorType | aReceiverType includesBehavior: anImplementorType ]
]

{ #category : #initialization }
ReceiverTypesOfMessageSendsConform >> initializeFrom: aCollectionOfSenders to: aCollectionOfImplementors [

	senders := aCollectionOfSenders.
	implementors := aCollectionOfImplementors 
]

{ #category : #'conforming definition' }
ReceiverTypesOfMessageSendsConform >> isMessageSendToAnyImplementor: receiverTypes [

	^receiverTypes anySatisfy: [ :aReceiverType | self anyImplementorIsTypeOrSuperTypeOf: aReceiverType ]
]

{ #category : #'conforming definition' }
ReceiverTypesOfMessageSendsConform >> receiverTypesThatShouldRenameButAreNotIncludedInImplementorTypes: receiverTypes [

	^ receiverTypes select: [ :aReceiverType | 
		(types noneSatisfy: [ :anImplementorType | aReceiverType includesBehavior: anImplementorType ]) and: [ aReceiverType canUnderstand: sentSelector] ].

]

{ #category : #evaluation }
ReceiverTypesOfMessageSendsConform >> value [

	sentSelector := implementors anyOne selector.
	types := implementors collect: [ :anImplementor | anImplementor methodClass ].
	notIncludedReceiverTypesInMessageSends := OrderedCollection new.
	
	senders do: [ :aSender | 
		currentSender := aSender.
		currentSenderMethodClass := aSender methodClass.
		currentSender methodNode accept: self ].
	
	^notIncludedReceiverTypesInMessageSends
]

{ #category : #visiting }
ReceiverTypesOfMessageSendsConform >> visitMessageNode: aMessageNode [

	| receiverTypes |
	
	(aMessageNode selector isNamed: sentSelector) ifTrue: [
		"I don't care if receiverTypes is empty or if there are error collecting the types.
		This should change if we want a more restrictive rename - Hernan"
		receiverTypes := aMessageNode receiverOrCascadeReceiver typesIn: currentSender addingIncompleteTypeInfoTo: OrderedCollection new.
		(self isMessageSendToAnyImplementor: receiverTypes) ifTrue: [ self add: aMessageNode toNotIncludedReceiverTypesIfCorrespond: receiverTypes ]].
]

{ #category : #visiting }
ReceiverTypesOfMessageSendsConform >> visitMessageNodeInCascade: aMessageNode [

	self visitMessageNode: aMessageNode 
]
