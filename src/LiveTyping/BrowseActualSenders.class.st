Class {
	#name : #BrowseActualSenders,
	#superclass : #BrowseActualSelectors,
	#category : #LiveTyping
}

{ #category : #'browsing-labels-private' }
BrowseActualSenders >> browseActualLabel [

	^'senders'
]

{ #category : #'browsing-private' }
BrowseActualSenders >> browseAll [

	Smalltalk browseAllCallsOn: sentSelector 
]

{ #category : #'browsing-private' }
BrowseActualSenders >> browseForAllTypes [

	 Smalltalk browseAllActualSendersOn: sentSelector forAll: types 
]

{ #category : #'browsing-private' }
BrowseActualSenders >> browseForCommonSupertype: aCommonSupertype [

	| implementor |
	
	implementor := aCommonSupertype lookupSelector: sentSelector .
	implementor isNil
		ifTrue: [ self browseForAllTypes ]
		ifFalse: [ Smalltalk browseAllActualSendersOn: implementor ]

]

{ #category : #'browsing-private' }
BrowseActualSenders >> browseWhenAtMethodSelector [

	Smalltalk browseAllActualSendersOn: methodToLookUp 
]

{ #category : #'browsing-labels-private' }
BrowseActualSenders >> showBrowseActualAnywayLabel [
	
	^'Show actual senders anyway' 
]
