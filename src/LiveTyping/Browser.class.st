Class {
	#name : #Browser,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
Browser >> browseActualSendersOf: aCompiledMethod [ 
	
	Smalltalk browseAllActualSendersOn: aCompiledMethod 
]

{ #category : #'as yet unclassified' }
Browser >> computeMessageEntriesIn: anAutocompleter ofBlockArgNamed: aName [

	"This will change when type info for block arguments will be supported - Hernan"

	"| typeInfo |
	
	typeInfo := currentCompiledMethod ifNotNil: [ currentCompiledMethod typeInfoOfVariableNamed: aName ifAbsent: [ nil ]].
		
	anAutocompleter computeMessageEntriesForTypeInfo: typeInfo."
	
	anAutocompleter computeMessageEntriesForTypeInfoOrNil: nil

]

{ #category : #'as yet unclassified' }
Browser >> computeMessageEntriesIn: anAutocompleter ofBlockTempVarNamed: aName [

	"This will change when type info for block arguments will be supported - Hernan"

	"| typeInfo |
	
	typeInfo := currentCompiledMethod ifNotNil: [ currentCompiledMethod typeInfoOfVariableNamed: aName ifAbsent: [ nil ]].
		
	anAutocompleter computeMessageEntriesForTypeInfo: typeInfo."
	
	anAutocompleter computeMessageEntriesForTypeInfoOrNil: nil

]

{ #category : #'as yet unclassified' }
Browser >> computeMessageEntriesIn: anAutocompleter ofInstVarNamed: aName [

	| typeInfo |
	
	typeInfo := self selectedClassOrMetaClass 
		ifNotNil: [ :selected |  selected typeInfoOfInstanceVariableNamed: aName ifAbsent: [ nil ] ].
		
	anAutocompleter computeMessageEntriesForTypeInfoOrNil: typeInfo
]

{ #category : #'as yet unclassified' }
Browser >> computeMessageEntriesIn: anAutocompleter ofTempVarNamed: aName [

	| typeInfo |
	
	typeInfo := currentCompiledMethod ifNotNil: [ currentCompiledMethod typeInfoOfVariableNamed: aName ifAbsent: [ nil ]].
		
	anAutocompleter computeMessageEntriesForTypeInfoOrNil: typeInfo.
	

]

{ #category : #'as yet unclassified' }
Browser >> confirmActualRemovalOf: aCompiledMethod [ 
	
	^ (self hasNoActualSendersOrIsItself: aCompiledMethod)
		ifTrue: [self confirmRemovalWhenNoSenders ]
		ifFalse: [self confirmRemovalWhenHasSenders ].

]

{ #category : #'as yet unclassified' }
Browser >> confirmRemovalWhenHasSenders [

	| menu |
	
	menu := PopUpMenu 
		labels: 'Remove it
Remove, then browse senders
Don''t remove, but show me those senders
Forget it -- do nothing -- sorry I asked'
		icons: #(acceptIcon acceptIcon cancelIcon cancelIcon).
			
	^menu startUpWithCaption: 'This message has real or posible sender(s)' 
]

{ #category : #'as yet unclassified' }
Browser >> confirmRemovalWhenNoSenders [
	
	^ (self confirm: 'This message has no actual senders. Remove it anyway?') ifTrue: [1] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
Browser >> hasNoActualSendersOrIsItself: aCompiledMethod [ 
	
	| realSendersCount allSenders posibleSenders realSenders |

	allSenders := Smalltalk allActualSendersOn: aCompiledMethod.
	realSenders := allSenders first.
	posibleSenders := allSenders second.
	realSendersCount := realSenders size.

	^posibleSenders isEmpty 
		and: [ realSendersCount = 0 
			or: [ realSendersCount = 1 
				and: [(realSenders first actualClass == aCompiledMethod methodClass and: [realSenders first methodSymbol == aCompiledMethod selector])]]]

]

{ #category : #'as yet unclassified' }
Browser >> removeMessageCheckingActualSenders [
	
	| confirmation |

	self currentCompiledMethod ifNotNil: [ :aCompiledMethod |
		confirmation := self confirmActualRemovalOf: aCompiledMethod.

		(confirmation = 1 or: [ confirmation = 2 ]) ifTrue: [self removeMethod: aCompiledMethod ].
		(confirmation = 2 or: [ confirmation = 3 ]) ifTrue: [self browseActualSendersOf: aCompiledMethod ]].

	
]

{ #category : #'as yet unclassified' }
Browser >> removeMethod: aCompiledMethod [ 

	aCompiledMethod methodClass removeSelector: aCompiledMethod selector.
	self
		messageListIndex: 0;
		changed: #messageList;
		setClassOrganizer.
	
]

{ #category : #'as yet unclassified' }
Browser >> resetCategoryTypes [
	
	| initializeWithInstances classes increment progressBar |
	
	selectedSystemCategory ifNotNil: [ 
		initializeWithInstances := self confirm: 'Do you want to initialize instance variables types with current instances?'.
		progressBar := ProgressMorph label: 'Reseting types' subLabel: ''.
		progressBar openInWorld.
		classes := systemOrganizer classesAt: selectedSystemCategory.
		increment := 1/classes size.
		[ classes do: [ :aClass | 
			progressBar subLabel: aClass name.
			initializeWithInstances 
				ifTrue: [ aClass initializeTypeInformationWithAllInstances ]
				ifFalse: [ aClass initializeTypeInformation ].
			progressBar incrDone: increment ].
		progressBar dismissMorph] fork ]
		
]

{ #category : #'as yet unclassified' }
Browser >> resetClassType [
	
	| initializeWithInstances |
	
	self selectedClass ifNotNil: [ :aSelectedClass |
		initializeWithInstances := self confirm: 'Do you want to initialize instance variables types with current instances?'.
		initializeWithInstances 
			ifTrue: [ aSelectedClass initializeTypeInformationWithAllInstances ]
			ifFalse: [ aSelectedClass initializeTypeInformation ] ]
]

{ #category : #'as yet unclassified' }
Browser >> typeCheckCategory [

	| typeChecker |
	
	selectedSystemCategory ifNotNil: [ 
		typeChecker := ManyMethodsTypeChecker forAllClasses: (systemOrganizer classesAt: selectedSystemCategory).
		typeChecker value.
		typeChecker showResultsWith: selectedSystemCategory name ]
	
	
]

{ #category : #'as yet unclassified' }
Browser >> typeCheckClass [
	
	| typeChecker |
	
	typeChecker := self selectedClass ifNotNil: [ :aSelectedClass | 
		typeChecker := aSelectedClass typeCheck.
		typeChecker showResultsWith: aSelectedClass name ]
	
	
]
