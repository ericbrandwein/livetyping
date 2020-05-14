Class {
	#name : #BrowseActualSelectors,
	#superclass : #Object,
	#instVars : [
		'methodNode',
		'class',
		'cursorPosition',
		'morph',
		'methodToLookUp',
		'incompleteTypeInfoReasons',
		'sentSelector',
		'types'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
BrowseActualSelectors class >> browseOf: aMethodNode definedIn: aClass withCursorAt: aPosition in: aMorph [

	^(self of: aMethodNode definedIn: aClass withCursorAt: aPosition in: aMorph) browse
]

{ #category : #'instance creation' }
BrowseActualSelectors class >> of: aMethodNode definedIn: aClass withCursorAt: aPosition in: aMorph [

	^self new initializeOf: aMethodNode definedIn: aClass withCursorAt: aPosition in: aMorph

]

{ #category : #browsing }
BrowseActualSelectors >> browse [
	
	| methodSelector | 

	methodSelector := methodNode selector.
	methodToLookUp := class 
		compiledMethodAt: methodSelector 
		ifAbsent: [ NotImplementedMethod class: class selector: methodSelector ].
 	cursorPosition < methodNode selectorLastPosition ifTrue: [ ^self browseWhenAtMethodSelector ].
	
	methodNode 
		withParseNodeIncluding: cursorPosition 
		do: [ :aNodeUnderCursor | aNodeUnderCursor isMessageNode 
			ifTrue: [ ^self browseActualMessageNode: aNodeUnderCursor ] ]
		ifAbsent: [].
		
	 morph flash 

]

{ #category : #'browsing-labels-private' }
BrowseActualSelectors >> browseActualLabel [

	self subclassResponsibility 
]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseActualMessageNode: messageNode [ 

	sentSelector := messageNode selector key.
	incompleteTypeInfoReasons := Set new.
	types := messageNode receiverOrCascadeReceiver typesIn: methodToLookUp addingIncompleteTypeInfoTo: incompleteTypeInfoReasons.

	types isEmpty 
		ifTrue: [ self browseActualWithNoTypeInfoSendTo: messageNode receiverOrCascadeReceiver ]
		ifFalse: [ self browseActualWithTypeInfo ].
		
		

]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseActualWithNoTypeInfoSendTo: receiver [

	(self confirm: 'There is no type info for ', receiver nodeTypeAndIdentifierPrintString, '
Do you want to see all ', self browseActualLabel, '?') ifTrue: [ self browseAll ]
		

]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseActualWithTypeInfo [
	
	incompleteTypeInfoReasons isEmpty 
		ifTrue: [ self browseActualWithTypeInfoNoMatterIncompleteTypeInfo ]
		ifFalse: [ self browseActualWithTypeInfoAndIncompleteTypeInfo ]
		

]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseActualWithTypeInfoAndIncompleteTypeInfo [
	
	| menu labels icons selectionIndex |
	
	labels := OrderedCollection with: self showBrowseActualAnywayLabel with: self seeAllLabel.
	icons := OrderedCollection with: Theme current acceptIcon with: Theme current acceptIcon.
	incompleteTypeInfoReasons := incompleteTypeInfoReasons asArray.
	incompleteTypeInfoReasons do: [ :anIncompleteTypeInfo | 
		labels add: anIncompleteTypeInfo reasonDescription.
		icons add: Theme current closeIcon ].
	
	menu := PopUpMenu labelArray: labels lines: #(2) icons: icons.
	selectionIndex := menu startUpWithCaption: self incompleteTypeInfoQuestionTitle.
	selectionIndex = 1 ifTrue: [ ^self browseActualWithTypeInfoNoMatterIncompleteTypeInfo ].
	selectionIndex = 2 ifTrue: [ ^self browseAll ].
	selectionIndex > 2 ifTrue: [ ^(incompleteTypeInfoReasons at: selectionIndex - 2) browse ]

]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseActualWithTypeInfoNoMatterIncompleteTypeInfo [

	| receiverTypeInfo |

	receiverTypeInfo := VariableTypeInfo new initializeRawTypes: types asArray.
	receiverTypeInfo 
		withCommonSupertypeDo: [ :aCommonSupertype | self browseForCommonSupertype: aCommonSupertype ]	
		 ifGeneric: [ :aGenericType | self browseForAllTypes ].
		

]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseAll [
	
	self subclassResponsibility 
]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseForAllTypes [
	
	self subclassResponsibility 
]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseForCommonSupertype: aCommonSupertype [
	
	self subclassResponsibility 
]

{ #category : #'browsing-private' }
BrowseActualSelectors >> browseWhenAtMethodSelector [
	
	self subclassResponsibility 
]

{ #category : #'browsing-labels-private' }
BrowseActualSelectors >> incompleteTypeInfoQuestionTitle [
	
	^'Incomplete type info. What do you want to do?'
]

{ #category : #initialization }
BrowseActualSelectors >> initializeOf: aMethodNode definedIn: aClass withCursorAt: aPosition in: aMorph [

	methodNode := aMethodNode.
	class := aClass.
	cursorPosition := aPosition.
	morph := aMorph 
]

{ #category : #'browsing-labels-private' }
BrowseActualSelectors >> seeAllLabel [
	
	^'See all ', self browseActualLabel
]

{ #category : #'browsing-labels-private' }
BrowseActualSelectors >> showBrowseActualAnywayLabel [
	
	self subclassResponsibility 
]
