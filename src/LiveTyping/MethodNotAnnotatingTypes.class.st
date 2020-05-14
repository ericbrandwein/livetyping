Class {
	#name : #MethodNotAnnotatingTypes,
	#superclass : #Error,
	#instVars : [
		'method'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
MethodNotAnnotatingTypes class >> for: aMethod [

	^self new initializeFor: aMethod
]

{ #category : #signaling }
MethodNotAnnotatingTypes class >> signalFor: aMethod [

	^(self for: aMethod) signal
]

{ #category : #initialization }
MethodNotAnnotatingTypes >> initializeFor: aMethod [

	method := aMethod
]

{ #category : #private }
MethodNotAnnotatingTypes >> isResumable [
	
	^ true
]

{ #category : #exceptionDescription }
MethodNotAnnotatingTypes >> messageText [

	messageText ifNil: [ messageText := method classAndSelector, ' is not anottating types' ].
	^messageText
]

{ #category : #method }
MethodNotAnnotatingTypes >> method [
	
	^method
]
