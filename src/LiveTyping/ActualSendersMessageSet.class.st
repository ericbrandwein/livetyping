Class {
	#name : #ActualSendersMessageSet,
	#superclass : #Object,
	#instVars : [
		'types'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
ActualSendersMessageSet class >> messageList: messageList types: aReceiverTypes [ 

	| newInstance |
	
	newInstance := self messageList: messageList.
	^newInstance initializeTypes: aReceiverTypes 
]

{ #category : #initialization }
ActualSendersMessageSet >> initializeTypes: aReceiverTypes [ 

	types := aReceiverTypes.

]

{ #category : #'message sends ranges' }
ActualSendersMessageSet >> messageSendsRangesOf: aSelector [
	
	^ selectedMessage 
		ifNil: [ #() ]
		ifNotNil: [selectedMessage rangesOf: aSelector whenSendTo: types ]

]
