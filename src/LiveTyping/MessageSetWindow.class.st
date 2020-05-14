Class {
	#name : #MessageSetWindow,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
MessageSetWindow class >> openMessageList: messageList label: labelString types: aReceiverTypes selector: aSentSelector [

	| messageSet |

	messageSet := ActualSendersMessageSet messageList: messageList types: aReceiverTypes.
	messageSet autoSelectString: aSentSelector.

	^self open: messageSet label: labelString 

]
