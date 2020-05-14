Class {
	#name : #InstanceType,
	#superclass : #DynamicType,
	#category : #LiveTyping
}

{ #category : #'error description' }
InstanceType class >> onlyBehaviorsCanBeConvertedToInstanceTypeErrorDescription [
	
	^'Only behaviors can be converted by instance type'
]

{ #category : #'type convertion' }
InstanceType >> asTypeFor: aReceiverType [

	^aReceiverType isMeta 
		ifTrue: [ aReceiverType soleInstance ]
		ifFalse: [ 
			(aReceiverType = Behavior or: [ aReceiverType = ClassDescription or: [ aReceiverType = Class or: [ aReceiverType = Metaclass ]]])
				ifTrue: [ aReceiverType ]
				ifFalse: [ self error: self class onlyBehaviorsCanBeConvertedToInstanceTypeErrorDescription ]]
			
			
]

{ #category : #name }
InstanceType >> typeName [

	^'instance'
]
