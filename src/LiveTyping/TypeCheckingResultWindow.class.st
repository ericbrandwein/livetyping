"
Morphic view for MessageSet models. See category 'GUI building'.
"
Class {
	#name : #TypeCheckingResultWindow,
	#superclass : #Object,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
TypeCheckingResultWindow class >> openFor: aTypeChecker labelTrail: aLabelTrail showingProblems: showingProblems [ 

	| window model |
	
	model := TypeCheckingResultSet for: aTypeChecker showingProblems: showingProblems.
	window := super open: model label: 'Type checking result for ', aLabelTrail.
	model messageListIndex: 1.
	
	^window
	
]

{ #category : #'menu building' }
TypeCheckingResultWindow >> messageListMenu [

	| aMenu |
	
	aMenu _ MenuMorph new defaultTarget: self.
	aMenu addTitle: 'Errors & Warnings'.
	aMenu
		addItemsFromDictionaries: {
			{
				#label 			-> 		'remove'.
				#object 			-> 		#model.
				#selector 		-> 		#removeMessageFromBrowserKeepingLabel.
				#icon 			-> 		#listRemoveIcon
			} asDictionary.
		}.
		
	^ aMenu
]
