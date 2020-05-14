Class {
	#name : #SenderInfo,
	#superclass : #Object,
	#instVars : [
		'sender',
		'sureSenders',
		'possibleSenders',
		'sentImplementors'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
SenderInfo class >> of: aSender for: aSentImplementors [
	
	^self new initializeOf: aSender for: aSentImplementors
]

{ #category : #'possible senders' }
SenderInfo >> addPossibleSender: aPossibleSender of: aSentImplementor [

	possibleSenders add: aPossibleSender 
]

{ #category : #'sure senders' }
SenderInfo >> addSureSenderOf: aSentImplementor [

	sureSenders add: aSentImplementor
]

{ #category : #'sure senders' }
SenderInfo >> hasCompleteSureSenders [
	
	^sureSenders size = sentImplementors size
]

{ #category : #'sure senders' }
SenderInfo >> hasPartialSureSenders [
	
	^sureSenders size between: 1 and: sentImplementors size - 1
	
	
]

{ #category : #'possible senders' }
SenderInfo >> hasPossibleSenders [
	
	^possibleSenders notEmpty 
]

{ #category : #initialization }
SenderInfo >> initializeOf: aSender for: aSentImplementors [
	
	sender := aSender.
	sentImplementors := aSentImplementors.
	sureSenders := Set new.
	possibleSenders := OrderedCollection new.

]

{ #category : #sender }
SenderInfo >> sender [
	
	^sender
]

{ #category : #'sure senders' }
SenderInfo >> sureSenders [
	
	^sureSenders
]

{ #category : #'possible senders' }
SenderInfo >> withPossibleMessageSendsDo: aBlock [
	
	possibleSenders do: [ :aPossibleSender | aPossibleSender withPossibleMessageSendsDo: aBlock ]
]
