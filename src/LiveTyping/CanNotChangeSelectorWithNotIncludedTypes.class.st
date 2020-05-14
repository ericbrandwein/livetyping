Class {
	#name : #CanNotChangeSelectorWithNotIncludedTypes,
	#superclass : #Object,
	#instVars : [
		'messageSendsWithInvalidReceiverTypes'
	],
	#category : #'LiveTyping-Refactoring'
}

{ #category : #signaling }
CanNotChangeSelectorWithNotIncludedTypes class >> signalWith: messageSendsWithInvalidReceiverTypes [ 
	
	(self with: messageSendsWithInvalidReceiverTypes) signal
]

{ #category : #'instance creation' }
CanNotChangeSelectorWithNotIncludedTypes class >> with: messageSendsWithInvalidReceiverTypes [
 
	^self new initializeWith: messageSendsWithInvalidReceiverTypes
]

{ #category : #initialization }
CanNotChangeSelectorWithNotIncludedTypes >> initializeWith: aMessageSendsWithInvalidReceiverTypes [ 
	
	messageSendsWithInvalidReceiverTypes := aMessageSendsWithInvalidReceiverTypes 
]

{ #category : #labels }
CanNotChangeSelectorWithNotIncludedTypes >> messageSendWithInvalidReceiverTypesLabelFor: array [

	^String streamContents: [ :stream |
		array first printClassAndSelectorOn: stream.
		stream 
			nextPutAll: ' - Message send: '; 
			print: array second;
			nextPutAll: ' - Missing Types: ';
			nextPutAll: array third asCommaSeparated: [ :type | stream nextPutAll: type name ]]	
]

{ #category : #labels }
CanNotChangeSelectorWithNotIncludedTypes >> messageSendsWithInvalidReceiverTypes [
	
	^messageSendsWithInvalidReceiverTypes
]

{ #category : #labels }
CanNotChangeSelectorWithNotIncludedTypes >> messageSendsWithInvalidReceiverTypesAsLabels [
	
	^messageSendsWithInvalidReceiverTypes collect: [ :array | self messageSendWithInvalidReceiverTypesLabelFor: array ].
		
]

{ #category : #exceptionDescription }
CanNotChangeSelectorWithNotIncludedTypes >> messageText [

	^'There are receiver types of message sends not included in implementor types'
	"^String streamContents: [ :stream |
		stream nextPutAll: 'There are receiver types of message sends not included in implementor types'; newLine.
		messageSendsWithInvalidReceiverTypes 
			do: [ :array |
				array first printClassAndSelectorOn: stream.
				stream 
					nextPutAll: ' - Message send: '; 
					print: array second;
					nextPutAll: ' - Types: ';
					nextPutAll: array third asCommaSeparated: [ :type | stream nextPutAll: type name ];
					newLine]
			separatedBy: [ stream newLine ]] 
		" 
]
