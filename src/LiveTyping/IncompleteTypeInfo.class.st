Class {
	#name : #IncompleteTypeInfo,
	#superclass : #Object,
	#instVars : [
		'methodReference',
		'reasonDescription'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
IncompleteTypeInfo class >> of: aMethodReference describedAs: aReasonDescription [
	
	^self new initializeOf: aMethodReference describedAs: aReasonDescription
]

{ #category : #comparing }
IncompleteTypeInfo >> = anObject [

	^ self class = anObject class and: [ reasonDescription = anObject reasonDescription]
]

{ #category : #browsing }
IncompleteTypeInfo >> browse [
	
	BrowserWindow fullOnClass: methodReference actualClass selector: methodReference methodSymbol 
]

{ #category : #comparing }
IncompleteTypeInfo >> hash [

	^reasonDescription hash
]

{ #category : #initialization }
IncompleteTypeInfo >> initializeOf: aMethodReference describedAs: aReasonDescription [
	
	methodReference := aMethodReference.
	reasonDescription := aReasonDescription 
]

{ #category : #accessing }
IncompleteTypeInfo >> methodReference [
	
	^methodReference
]

{ #category : #accessing }
IncompleteTypeInfo >> reasonDescription [
	
	^reasonDescription 
]
