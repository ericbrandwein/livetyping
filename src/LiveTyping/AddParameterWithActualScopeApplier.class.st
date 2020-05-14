Class {
	#name : #AddParameterWithActualScopeApplier,
	#superclass : #Object,
	#instVars : [
		'messageNode',
		'selectedSelector'
	],
	#category : #'LiveTyping-Refactoring'
}

{ #category : #'instance creation' }
AddParameterWithActualScopeApplier class >> createAndValueHandlingExceptionsOn: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector [
	
	^self createAndValueHandlingExceptions: [ self on: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector ]
]

{ #category : #'instance creation' }
AddParameterWithActualScopeApplier class >> on: aModel of: aMessageNode in: aSelectedClass at: aSelectedSelector [

	^(self on: aModel for: aMessageNode selector key in: aSelectedClass) initializeOf: aMessageNode at: aSelectedSelector 
]

{ #category : #'refactoring - parameters request' }
AddParameterWithActualScopeApplier >> calculateImplementorsAndSenders [

	self isActualScopeChoice ifTrue: [ ^self actualImplementorsAndSenders ].
	
	^super calculateImplementorsAndSenders 
]

{ #category : #'refactoring - creation' }
AddParameterWithActualScopeApplier >> createRefactoring [

	^ self isActualScopeChoice
		ifTrue: [ self createRefactoringWithActualScope ]
		ifFalse: [ super createRefactoring ]
]

{ #category : #'refactoring - creation' }
AddParameterWithActualScopeApplier >> createRefactoringWithActualScope [
	
	self filterSenders.
	oldSelector isUnary ifTrue: [ ^self createRefactoringWithActualScopeForUnarySelector].
	oldSelector isKeyword ifTrue: [ ^self createRefactoringWithActualScopeForKeywordSelector ].
	
	self error: 'oldSelector should be unary or keyword!'
	
]

{ #category : #'refactoring - creation' }
AddParameterWithActualScopeApplier >> createRefactoringWithActualScopeForKeywordSelector [ 
	
	^self refactoringClass 
		named: newParameter
		at: parameterIndex 
		initializedWith: newParameterValue 
		using: newKeyword 
		toKeywordSelector: oldSelector 
		implementors: implementors 
		senders: senders 
		withPossibleMessageSends: self isWithPossibleMessageSends 
]

{ #category : #'refactoring - creation' }
AddParameterWithActualScopeApplier >> createRefactoringWithActualScopeForUnarySelector [
	
	^self refactoringClass 
		named: newParameter
		initializedWith: newParameterValue 
		toUnarySelector: oldSelector 
		implementors: implementors 
		senders: senders 
		withPossibleMessageSends: self isWithPossibleMessageSends
]

{ #category : #initialization }
AddParameterWithActualScopeApplier >> createSenders [

	^OrderedCollection new.

]

{ #category : #initialization }
AddParameterWithActualScopeApplier >> initializeOf: aMessageNode at: aSelectedSelector [

	messageNode := aMessageNode.
	selectedSelector := aSelectedSelector.

]

{ #category : #'refactoring - parameters request' }
AddParameterWithActualScopeApplier >> messageNode [

	^messageNode 
]

{ #category : #'refactoring - parameters request' }
AddParameterWithActualScopeApplier >> openChangeSelectorSendersStepWindow [
	
	self isActualScopeChoice 
		ifTrue: [ ChangeSelectorSendersStepWindow openForActualScopeFrom: self ]
		ifFalse: [ super openChangeSelectorSendersStepWindow ]
	
	
]

{ #category : #'refactoring - creation' }
AddParameterWithActualScopeApplier >> refactoringClass [
	
	^self isActualScopeChoice 
		ifTrue: [ AddParameterWithActualScope ]
		ifFalse: [ super refactoringClass ]
]

{ #category : #'refactoring - parameters request' }
AddParameterWithActualScopeApplier >> scopeOptionLabels [
	
	^super scopeOptionLabels, self actualScopeOptionLabels
]

{ #category : #'refactoring - parameters request' }
AddParameterWithActualScopeApplier >> selectedSelector [

	^selectedSelector 
]

{ #category : #'refactoring - creation' }
AddParameterWithActualScopeApplier >> valueHandlingRefactoringExceptions: aBlock [

	^super valueHandlingRefactoringExceptions: [ aBlock 
		on: CanNotChangeSelectorWithNotIncludedTypes
		do: [ :anError | self handleCanNotChangeSelectorWithNotIncludedTypes: anError ]]
]
