Class {
	#name : #SmalltalkEditor,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
SmalltalkEditor >> actualImplementorsOfIt [
	self 
		withMethodNodeAndClassDo: [ :methodNode :class | 
			BrowseActualImplementors browseOf: methodNode definedIn: class withCursorAt: self startIndex in: morph ]
		ifErrorsParsing: [ :anError | morph flash ].

		
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> actualImplementorsOfIt: aKeyboardEvent [

	self actualImplementorsOfIt.
	^true
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> actualLocalImplementorsOfIt [

	self 
		withMethodNodeAndClassDo: [ :methodNode :class | 
			BrowseActualLocalImplementors browseOf: methodNode definedIn: class withCursorAt: self startIndex in: morph ]
		ifErrorsParsing: [ :anError | morph flash ].

		
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> actualLocalImplementorsOfIt: aKeyboardEvent [

	self actualLocalImplementorsOfIt.
	^true
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> actualSendersOfIt [
	
	self 
		withMethodNodeAndClassDo: [ :methodNode :class | 
			BrowseActualSenders browseOf: methodNode definedIn: class withCursorAt: self startIndex in: morph ]
		ifErrorsParsing: [ :anError | morph flash ].


	

]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> actualSendersOfIt: aKeyboardEvent [

	self actualSendersOfIt.
	^true
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> balloonTypeInfoAt: mousePositionInText [

	^self isEditingClassDefinition 
		ifTrue: [ self balloonTypeInfoOfInstanceVariableAt: mousePositionInText ]
		ifFalse: [ self balloonTypeInfoInMethodAt: mousePositionInText ]
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> balloonTypeInfoInMethodAt: mousePositionInText [

	^self 
		withMethodNodeAndClassDo: [ :methodNode :class | 
			methodNode 
				withParseNodeIncluding: mousePositionInText 
				do: [ :aNodeUnderCursor | self balloonTypeInfoOf: aNodeUnderCursor in: methodNode definedAt: class ]
				ifAbsent: [ 
					mousePositionInText <= methodNode selectorLastPosition 
						ifTrue: [ self balloonTypeInfoOf: methodNode in: methodNode definedAt: class ]
						ifFalse: [ '' ]]]
		ifErrorsParsing: [ :anError | '' ]



]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> balloonTypeInfoOf: aNodeUnderCursor in: methodNode definedAt: class [

	^[ ((ParseNodeTypesDisplay of: aNodeUnderCursor in: methodNode definedAt: class) 
		calculateTypes; 
		initializeTypeInfo;
		typeInfo) printTypesUpTo: 5 ]
		on: MethodNotAnnotatingTypes 
		do: [ :anError | 'Could not get type because: ', anError messageText ]

]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> balloonTypeInfoOfInstanceVariableAt: mousePositionInText [

	| instVarName typeInfo |
	
	instVarName := (self wordUnder: mousePositionInText) asString.
	typeInfo := self codeProvider selectedClass typeInfoOfInstanceVariableNamed: instVarName ifAbsent: [^''].

	^typeInfo printTypesUpTo: 5
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> showSelectionTypeInfo [

	self isEditingClassDefinition 
		ifTrue: [ self showTypeInfoOfInstanceVariable ]
		ifFalse: [ self showSelectionTypeInfoInMethod ]
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> showSelectionTypeInfo: aKeyboardEvent [

	self showSelectionTypeInfo.
	^true
]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> showSelectionTypeInfoInMethod [
		
	self 
		withMethodNodeAndClassDo: [ :methodNode :class | | cursorPosition |
			cursorPosition := self startIndex.
			methodNode 
				withParseNodeIncluding: cursorPosition 
				do: [ :aNodeUnderCursor | self showTypeInfoOf: aNodeUnderCursor in: methodNode definedAt: class ]
				ifAbsent: [ 
					cursorPosition <= methodNode selectorLastPosition 
						ifTrue: [ self showTypeInfoOf: methodNode in: methodNode definedAt: class ]
						ifFalse: [ morph flash ]]]
		ifErrorsParsing: [ :anError | morph flash ]


]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> showTypeInfoOf: aNodeUnderCursor in: methodNode definedAt: class [ 

	[ (ParseNodeTypesDisplay of: aNodeUnderCursor in: methodNode definedAt: class) show ]
		on: MethodNotAnnotatingTypes 
		do: [ :anError | self inform: anError messageText ]

]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> showTypeInfoOfInstanceVariable [

	| instVarName typeInfo |
	
	instVarName := self wordUnderCursor asString.
	typeInfo := self codeProvider selectedClass typeInfoOfInstanceVariableNamed: instVarName ifAbsent: [^morph flash].

	^(InstanceVariableTypesDisplay typeInfo: typeInfo) showTypes 

]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> typeCheckMethod [
	
	self hasUnacceptedEdits ifTrue: [ ^self inform: 'The method can not be typed check because source code is not saved' ].
	
	self codeProvider typeCheckMethod.

]

{ #category : #'as yet unclassified' }
SmalltalkEditor >> typeCheckMethod: aKeyboardEvent [ 
	
	self typeCheckMethod.
	^true
]
