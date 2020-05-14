Class {
	#name : #RenameSelectorWithActualScopeApplier,
	#superclass : #Object,
	#instVars : [
		'messageNode',
		'selectedSelector'
	],
	#category : #'LiveTyping-Refactoring'
}

{ #category : #'instance creation' }
RenameSelectorWithActualScopeApplier class >> createAndValueHandlingExceptionsOn: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector [
	
	^self createAndValueHandlingExceptions: [ self on: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector ]
]

{ #category : #'instance creation' }
RenameSelectorWithActualScopeApplier class >> on: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector [

	^(self on: aModel for: aMessageNode selector key in: aSelectedClass) initializeOf: aMessageNode at: aSelectedSelector 
]

{ #category : #'refactoring - parameters request' }
RenameSelectorWithActualScopeApplier >> calculateImplementorsAndSenders [

	self isActualScopeChoice ifTrue: [ ^self actualImplementorsAndSenders ].
	
	^super calculateImplementorsAndSenders 
]

{ #category : #'refactoring - creation' }
RenameSelectorWithActualScopeApplier >> createRefactoring [

	^ self isActualScopeChoice
		ifTrue: [ self createRefactoringWithActualScope ]
		ifFalse: [ super createRefactoring ]
]

{ #category : #'refactoring - creation' }
RenameSelectorWithActualScopeApplier >> createRefactoringWithActualScope [
	
	self filterSenders.
	
	^self refactoringClass 
		from: oldSelector 
		to: newSelector 
		implementors: implementors 
		senders: senders 
		withPossibleMessageSends: self isWithPossibleMessageSends 
]

{ #category : #initialization }
RenameSelectorWithActualScopeApplier >> createSenders [

	^OrderedCollection new.

]

{ #category : #initialization }
RenameSelectorWithActualScopeApplier >> initializeOf: aMessageNode at: aSelectedSelector [

	messageNode := aMessageNode.
	selectedSelector := aSelectedSelector.

]

{ #category : #'refactoring - parameters request' }
RenameSelectorWithActualScopeApplier >> messageNode [

	^messageNode 
]

{ #category : #'refactoring - parameters request' }
RenameSelectorWithActualScopeApplier >> openChangeSelectorSendersStepWindow [
	
	self isActualScopeChoice 
		ifTrue: [ ChangeSelectorSendersStepWindow openForActualScopeFrom: self ]
		ifFalse: [ super openChangeSelectorSendersStepWindow ]
	
	
]

{ #category : #'refactoring - creation' }
RenameSelectorWithActualScopeApplier >> refactoringClass [
	
	^self isActualScopeChoice 
		ifTrue: [ RenameSelectorWithActualScope ]
		ifFalse: [ super refactoringClass ]
]

{ #category : #'refactoring - parameters request' }
RenameSelectorWithActualScopeApplier >> scopeOptionLabels [
	
	^super scopeOptionLabels, self actualScopeOptionLabels
]

{ #category : #'refactoring - parameters request' }
RenameSelectorWithActualScopeApplier >> selectedSelector [

	^selectedSelector 
]

{ #category : #'refactoring - creation' }
RenameSelectorWithActualScopeApplier >> valueHandlingRefactoringExceptions: aBlock [

	^super valueHandlingRefactoringExceptions: [ aBlock 
		on: CanNotChangeSelectorWithNotIncludedTypes
		do: [ :anError | self handleCanNotChangeSelectorWithNotIncludedTypes: anError ]]
]
