Class {
	#name : #TypeCheckingIssue,
	#superclass : #TypeCheckingResult,
	#instVars : [
		'method',
		'messageNode',
		'reason',
		'methodNode'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
TypeCheckingIssue class >> canNotDeduceReceiverTypeDueTo: aReason on: aCompiledMethod node: aMessageNode of: aMethodNode [ 
	
	^self on: aCompiledMethod node: aMessageNode of: aMethodNode reason: (self canNotDeduceReceiverTypeDueToDescription: aReason)
]

{ #category : #description }
TypeCheckingIssue class >> canNotDeduceReceiverTypeDueToDescription: aReason [
 
	^'Can not deduce receiver''s type because: ', aReason 
]

{ #category : #'instance creation' }
TypeCheckingIssue class >> forReceiverWithNoTypesOn: aMethod node: aMessageNode of: methodNode [  
	
	^self on: aMethod node: aMessageNode of: methodNode reason: self receiverHasNoTypesDescription
]

{ #category : #'instance creation' }
TypeCheckingIssue class >> on: aMethod node: aMessageNode of: aMethodNode reason: aReason [

	^self new initializeOn: aMethod node: aMessageNode of: aMethodNode reason: aReason


]

{ #category : #description }
TypeCheckingIssue class >> receiverHasNoTypesDescription [
	
	^'Receiver has no types'
]

{ #category : #initialization }
TypeCheckingIssue >> initializeOn: aMethod node: aMessageNode of: aMethodNode reason: aReason [

	method := aMethod.
	messageNode := aMessageNode.
	methodNode := aMethodNode.
	reason := aReason 
]

{ #category : #method }
TypeCheckingIssue >> method [
	
	^method
]

{ #category : #printing }
TypeCheckingIssue >> problemDescription [

	^self reason
]

{ #category : #printing }
TypeCheckingIssue >> reason [
	
	^reason
]

{ #category : #'receiver/selector' }
TypeCheckingIssue >> receiver [
	
	^messageNode receiver 
]

{ #category : #'receiver/selector' }
TypeCheckingIssue >> selector [
	
	^messageNode selector 
]

{ #category : #method }
TypeCheckingIssue >> sourceCodeRange [
	
	^Array with: (methodNode rangeForNode: messageNode ifAbsent: [^#()])
]
