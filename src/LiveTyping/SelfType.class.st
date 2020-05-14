Class {
	#name : #SelfType,
	#superclass : #DynamicType,
	#category : #LiveTyping
}

{ #category : #'type convertion' }
SelfType >> asTypeFor: aReceiverType [

	^aReceiverType 
]

{ #category : #name }
SelfType >> typeName [

	^'self'
]
