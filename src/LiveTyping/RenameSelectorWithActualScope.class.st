Class {
	#name : #RenameSelectorWithActualScope,
	#superclass : #Object,
	#instVars : [
		'shouldChangePossibleMessageSends'
	],
	#category : #'LiveTyping-Refactoring'
}

{ #category : #'instance creation - invalidated' }
RenameSelectorWithActualScope class >> from: anOldSelector to: aNewSelector implementors: aCollectionOfImplementors senders: aCollectionOfSenders [

	self shouldNotImplement 
]

{ #category : #'instance creation' }
RenameSelectorWithActualScope class >> from: anOldSelector to: aNewSelector implementors: aCollectionOfImplementors senders: aCollectionOfSenders withPossibleMessageSends: shouldRenamePossibleMessageSends [

	self assertReceiverTypesOfAll: aCollectionOfSenders areIncludedInAllTypesOf: aCollectionOfImplementors. 
	
	^(super from: anOldSelector to: aNewSelector implementors: aCollectionOfImplementors senders: aCollectionOfSenders)
		initilaizeWithPossibleMessageSends: shouldRenamePossibleMessageSends
]

{ #category : #'instance creation - invalidated' }
RenameSelectorWithActualScope class >> from: anOldSelector to: aNewSelector in: aClassToRefactor [

	self shouldNotImplement 
]

{ #category : #'instance creation - invalidated' }
RenameSelectorWithActualScope class >> from: anOldSelector to: aNewSelector inCategoriesAndHierarchyOf: aClass organizedBy: anOrganization [

	self shouldNotImplement 
]

{ #category : #'instance creation - invalidated' }
RenameSelectorWithActualScope class >> from: anOldSelector to: aNewSelector inCategoryOf: aClass organizedBy: anOrganization [

	self shouldNotImplement 
]

{ #category : #'instance creation - invalidated' }
RenameSelectorWithActualScope class >> from: anOldSelector to: aNewSelector inHierarchyOf: aClass [

	self shouldNotImplement 
]

{ #category : #'instance creation - invalidated' }
RenameSelectorWithActualScope class >> from: anOldSelector to: aNewSelector inSystem: aSystem [

	self shouldNotImplement 
]

{ #category : #initialization }
RenameSelectorWithActualScope >> initilaizeWithPossibleMessageSends: aShouldRenamePossibleMessageSends [

	shouldChangePossibleMessageSends := aShouldRenamePossibleMessageSends 
]

{ #category : #'rename senders - private' }
RenameSelectorWithActualScope >> messageSendSelectorKeywordPositionsIn: aMethodNode [ 
	
	^aMethodNode 
		actualMessageSendsSelectorPositionsOfAll: implementors 
		ifAbsent: [ #() ] 
		withPossibleMessageSends: shouldChangePossibleMessageSends.
	

]
