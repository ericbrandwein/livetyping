Class {
	#name : #BrowseActualLocalImplementors,
	#superclass : #BrowseActualImplementors,
	#category : #LiveTyping
}

{ #category : #'browsing-private' }
BrowseActualLocalImplementors >> browseForAllTypes [

	Smalltalk browseAllActualLocalImplementorsOf: sentSelector forAll: types 

]

{ #category : #'browsing-private' }
BrowseActualLocalImplementors >> browseForCommonSupertype: aCommonSupertype [

	self browseForAllTypes 
]
