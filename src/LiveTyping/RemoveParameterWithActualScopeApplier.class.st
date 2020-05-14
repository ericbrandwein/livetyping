Class {
	#name : #RemoveParameterWithActualScopeApplier,
	#superclass : #Object,
	#instVars : [
		'messageNode',
		'selectedSelector'
	],
	#category : #'LiveTyping-Refactoring'
}

{ #category : #'instance creation' }
RemoveParameterWithActualScopeApplier class >> createAndValueHandlingExceptionsOn: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector [
	
	^self createAndValueHandlingExceptions: [ self on: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector ]
]

{ #category : #'instance creation' }
RemoveParameterWithActualScopeApplier class >> on: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector [

	^(self on: aModel for: aMessageNode selector key in: aSelectedClass) initializeOf: aMessageNode at: aSelectedSelector 
]

{ #category : #'refactoring - parameters request' }
RemoveParameterWithActualScopeApplier >> calculateImplementorsAndSenders [

	self isActualScopeChoice ifTrue: [ ^self actualImplementorsAndSenders ].
	
	^super calculateImplementorsAndSenders 
]

{ #category : #'refactoring - creation' }
RemoveParameterWithActualScopeApplier >> createRefactoring [

	^ self isActualScopeChoice
		ifTrue: [ self createRefactoringWithActualScope ]
		ifFalse: [ super createRefactoring ]
]

{ #category : #'refactoring - creation' }
RemoveParameterWithActualScopeApplier >> createRefactoringWithActualScope [
	
	self filterSenders.
	
	^self refactoringClass 
		named: parameterToRemove 
		from: originalMethod 
		implementors: implementors 
		senders: senders 
		withPossibleMessageSends: self isWithPossibleMessageSends.
]

{ #category : #initialization }
RemoveParameterWithActualScopeApplier >> createSenders [

	^OrderedCollection new.

]

{ #category : #initialization }
RemoveParameterWithActualScopeApplier >> initializeOf: aMessageNode at: aSelectedSelector [

	messageNode := aMessageNode.
	selectedSelector := aSelectedSelector.

]

{ #category : #'refactoring - parameters request' }
RemoveParameterWithActualScopeApplier >> messageNode [

	^messageNode 
]

{ #category : #'refactoring - parameters request' }
RemoveParameterWithActualScopeApplier >> openChangeSelectorSendersStepWindow [
	
	self isActualScopeChoice 
		ifTrue: [ ChangeSelectorSendersStepWindow openForActualScopeFrom: self ]
		ifFalse: [ super openChangeSelectorSendersStepWindow ]
	
	
]

{ #category : #'refactoring - creation' }
RemoveParameterWithActualScopeApplier >> refactoringClass [
	
	^self isActualScopeChoice 
		ifTrue: [ RemoveParameterWithActualScope ]
		ifFalse: [ super refactoringClass ]
]

{ #category : #'refactoring - parameters request' }
RemoveParameterWithActualScopeApplier >> scopeOptionLabels [
	
	^super scopeOptionLabels, self actualScopeOptionLabels
]

{ #category : #'refactoring - parameters request' }
RemoveParameterWithActualScopeApplier >> selectedSelector [

	^selectedSelector 
]

{ #category : #'refactoring - creation' }
RemoveParameterWithActualScopeApplier >> valueHandlingRefactoringExceptions: aBlock [

	^super valueHandlingRefactoringExceptions: [ aBlock 
		on: CanNotChangeSelectorWithNotIncludedTypes
		do: [ :anError | self handleCanNotChangeSelectorWithNotIncludedTypes: anError ]]
]
