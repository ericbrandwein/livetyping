Class {
	#name : #TypeCheckingError,
	#superclass : #TypeCheckingResult,
	#instVars : [
		'method',
		'messageNode',
		'notImplemented',
		'methodNode'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
TypeCheckingError class >> on: aCompiledMethod node: aMessageNode of: aMethodNode notImplemented: aNotImplemented [

	^self new initializeOn: aCompiledMethod node: aMessageNode of: aMethodNode notImplemented: aNotImplemented


]

{ #category : #initialization }
TypeCheckingError >> initializeOn: aCompiledMethod node: aMessageNode of: aMethodNode notImplemented: aNotImplemented [

	method := aCompiledMethod.
	messageNode := aMessageNode.
	methodNode := aMethodNode.
	notImplemented := aNotImplemented 
]

{ #category : #method }
TypeCheckingError >> method [
	
	^method
]

{ #category : #'not implemented' }
TypeCheckingError >> notImplemented [
	
	^notImplemented
]

{ #category : #'not implemented' }
TypeCheckingError >> notImplementedIncludesType: aType [

	^notImplemented anySatisfy: [ :aNotImplemented | aNotImplemented actualClass = aType ]
]

{ #category : #'not implemented' }
TypeCheckingError >> notImplementedSize [
	
	^notImplemented size
]

{ #category : #'not implemented' }
TypeCheckingError >> notImplementedTypes [
	
	^notImplemented collect: [:aNotImplemented | aNotImplemented actualClass ]
]

{ #category : #printing }
TypeCheckingError >> problemDescription [

	^ self selector identifierPrintString, ' not implemented in ', self notImplementedTypes asCommaStringAnd 
]

{ #category : #printing }
TypeCheckingError >> problemTypeIdentifierString [

	^ 'Error'
]

{ #category : #'receiver/selector' }
TypeCheckingError >> receiver [
	
	^messageNode receiver 
]

{ #category : #'receiver/selector' }
TypeCheckingError >> selector [
	
	^messageNode selector
]

{ #category : #method }
TypeCheckingError >> sourceCodeRange [
	
	^Array with: (methodNode rangeForNode: messageNode ifAbsent: [^#()])
]
