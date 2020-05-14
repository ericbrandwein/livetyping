Class {
	#name : #BrowseActualImplementors,
	#superclass : #BrowseActualSelectors,
	#category : #LiveTyping
}

{ #category : #'browsing-labels-private' }
BrowseActualImplementors >> browseActualLabel [

	^'implementors'
]

{ #category : #'browsing-private' }
BrowseActualImplementors >> browseAll [

	Smalltalk browseAllImplementorsOf: sentSelector 	
]

{ #category : #'browsing-private' }
BrowseActualImplementors >> browseForAllTypes [

	Smalltalk browseAllActualImplementorsOf: sentSelector forAll: types 
]

{ #category : #'browsing-private' }
BrowseActualImplementors >> browseForCommonSupertype: aCommonSupertype [

	Smalltalk browseAllActualImplementorsOf: sentSelector for: aCommonSupertype 
]

{ #category : #'browsing-private' }
BrowseActualImplementors >> browseWhenAtMethodSelector [

	Smalltalk browseAllActualmplementorsOf: methodToLookUp 
]

{ #category : #'browsing-labels-private' }
BrowseActualImplementors >> showBrowseActualAnywayLabel [
	
	^'Show actual implementors anyway' 
]
