Class {
	#name : #ClassType,
	#superclass : #DynamicType,
	#category : #LiveTyping
}

{ #category : #'type convertion' }
ClassType >> asTypeFor: aReceiverType [

	^aReceiverType class
	
]

{ #category : #name }
ClassType >> typeName [

	^'class'
]
