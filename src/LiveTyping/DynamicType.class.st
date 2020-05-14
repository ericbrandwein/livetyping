Class {
	#name : #DynamicType,
	#superclass : #Object,
	#category : #LiveTyping
}

{ #category : #'to do' }
DynamicType >> TO_DO [

"
should it be used only as message return type? it looks like...
Should I call it MetaReturnType?

"
]

{ #category : #'type convertion' }
DynamicType >> asTypeFor: aReceiverType [

	self subclassResponsibility 
]

{ #category : #printing }
DynamicType >> printOn: aStream [

	aStream nextPutAll: self typeName 
]

{ #category : #name }
DynamicType >> typeName [

	self subclassResponsibility 
]
