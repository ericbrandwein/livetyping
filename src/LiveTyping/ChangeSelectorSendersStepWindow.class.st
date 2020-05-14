Class {
	#name : #ChangeSelectorSendersStepWindow,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
ChangeSelectorSendersStepWindow class >> openForActualScopeFrom: aChangeSelectorWithActualScopeApplier [

	| window label |
	
	label := 'Senders of #', aChangeSelectorWithActualScopeApplier oldSelector, ' to Refactor'. 
	
	window := self 
		openMessageList: (self methodReferencesOf: aChangeSelectorWithActualScopeApplier senders) 
		label: label 
		types: aChangeSelectorWithActualScopeApplier receiverTypes 
		selector: aChangeSelectorWithActualScopeApplier oldSelector.

	window initializeFrom: aChangeSelectorWithActualScopeApplier.
	
	^window 


]

{ #category : #'as yet unclassified' }
ChangeSelectorSendersStepWindow >> codePane [
	
	^codePane 
]
