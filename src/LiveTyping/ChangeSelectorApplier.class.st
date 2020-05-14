Class {
	#name : #ChangeSelectorApplier,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> actualImplementorsAndSenders [ 

	self isOnMessageSend 
		ifTrue: [ self actualImplementorsAndSendersWhenOnMessageSend ]
		ifFalse: [ self actualImplementorsAndSendersWhenNotOnMessageSend ]

]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> actualImplementorsAndSendersWhenNotOnMessageSend [ 

	self refactoringClass 
		addActualImplementorsOf: oldSelector 
		in: implementingClass 
		to: implementors 
		andActualSendersTo: senders 
		inSystem: Smalltalk
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> actualImplementorsAndSendersWhenOnMessageSend [

	| incompleteTypeInfo receiverTypes |

	incompleteTypeInfo := Set new.
	receiverTypes := self messageNode receiverOrCascadeReceiver typesIn: implementingClass>>self selectedSelector addingIncompleteTypeInfoTo: incompleteTypeInfo.
	
	receiverTypes isEmpty ifTrue: [ self canNotRefactorWithoutTypeInfo ].
	incompleteTypeInfo notEmpty ifTrue: [ self canNotRefactorWithIncompleteTypeInfo ].
	
	self refactoringClass addActualImplementorsOf: oldSelector forTypes: receiverTypes to: implementors andActualSendersTo: senders inSystem: Smalltalk 
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> actualScopeOptionLabels [

	^{ 'Actual/Possible Scope'. 'Actual Scope' } 
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> canNotRefactorWithIncompleteTypeInfo [
	
	self 
		inform: 'Can not apply the refactoring because there are errors getting receiver types';
		endRequest 
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> canNotRefactorWithoutTypeInfo [
	
	self 
		inform: 'Can not apply the refactoring because there is no receiver type information';
		endRequest 
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> filterSenders [
	
	senders := (senders 
		select: [ :aMethodReference | aMethodReference isValid and: [ aMethodReference isPossibleSender not ]]
		thenCollect: [ :aMethodReference | aMethodReference compiledMethod ]) asIdentitySet 
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> handleCanNotChangeSelectorWithNotIncludedTypes: anError [

	| errorIcon messageSendWithInvalidReceiverType selection selectionMenu |
	
	errorIcon := Theme current closeIcon.
	selectionMenu := PopUpMenu 
		labelArray: anError messageSendsWithInvalidReceiverTypesAsLabels
		lines: #()  
		icons: ((1 to: anError messageSendsWithInvalidReceiverTypes size) collect: [ :aNumber | errorIcon ]).
		
	selection := selectionMenu startUpWithCaption: anError messageText. 
	selection = 0 ifFalse: [ 
		messageSendWithInvalidReceiverType := anError messageSendsWithInvalidReceiverTypes at: selection.
		MessageSetWindow 
			openMessageList: (Array with: (MethodReference method: messageSendWithInvalidReceiverType first)) 
			label: 'Missing implementor types: ', messageSendWithInvalidReceiverType third asCommaStringAnd
			autoSelect: (String streamContents: [ :stream | messageSendWithInvalidReceiverType second printOn: stream indent: 0 ])].
		
	self endRequest 

]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> isActualScopeChoice [
	
	^scopeChoice isNil or: [ scopeChoice >= 6 ]
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> isOnMessageSend [
	
	^self messageNode notNil
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> isWithPossibleMessageSends [

	^scopeChoice = 6
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> messageNode [
	
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> receiverTypes [
	
	^implementors collect: [ :anImplementor | anImplementor methodClass ]
]

{ #category : #'as yet unclassified' }
ChangeSelectorApplier >> selectedSelector [

	self subclassResponsibility 
]
