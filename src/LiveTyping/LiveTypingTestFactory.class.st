Class {
	#name : #LiveTypingTestFactory,
	#superclass : #Object,
	#category : #'LiveTyping-Tests'
}

{ #category : #'class category' }
LiveTypingTestFactory class >> removeTestDataClassCategoryAfter: aBlock [
	
	| factory |
	
	factory := self new.
	[ aBlock value: factory ] ensure: [ factory removeTestDataClassCategory ]

	
	
]

{ #category : #classes }
LiveTypingTestFactory >> createClassToBeRemoved [
	
	^ Object 
		subclass: self nameOfClassToBeRemoved
		instanceVariableNames: ''  
		classVariableNames: '' 
		poolDictionaries: '' 
		category: self testDataClassCategoryName
		
]

{ #category : #classes }
LiveTypingTestFactory >> nameOfClassToBeRemoved [
	
	^#LiveTypingClassToBeRemoved
]

{ #category : #'class categories' }
LiveTypingTestFactory >> removeTestDataClassCategory [
	
	SystemOrganization removeSystemCategory: self testDataClassCategoryName.
	Browser allInstancesDo: [:aBrowser | aBrowser changed: #systemCategoryList ]
]

{ #category : #'class categories' }
LiveTypingTestFactory >> testDataClassCategoryName [
	
	^'__LiveTyping-TestData__'.
]
