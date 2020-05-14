Extension { #name : #SmalltalkImage }

{ #category : #'*LiveTyping' }
SmalltalkImage >> actualImplementorsOf: aSelector in: aClass [ 
	
	| highestImplementorClass implementors |
	
	implementors := OrderedCollection new.
	highestImplementorClass := aClass 
		highestClassImplementing: aSelector 
		ifNone: [ 
			implementors add: (NotImplementedMethod class: aClass selector: aSelector).
			aClass ].
	
	^ highestImplementorClass withAllSubclassesImplementing: aSelector addTo: implementors.
	
]

{ #category : #'*LiveTyping' }
SmalltalkImage >> allActualImplementorsOf: aSelector forAll: types [

	^(AllActualImplementors of: aSelector forAll: types) value
]

{ #category : #'*LiveTyping' }
SmalltalkImage >> allActualLocalImplementorsOf: sentSelector forAll: types [

	^(AllActualLocalImplementors of: sentSelector forAll: types) value
				
				

]

{ #category : #'*LiveTyping' }
SmalltalkImage >> allActualSendersOn: aSentCompiledMethod [ 
	
	| allSenders sureSenders possibleSenders actualMessageSendersCollector |
	
	allSenders := self allCallsOn: aSentCompiledMethod selector.
	
	sureSenders := OrderedCollection new.
	possibleSenders := OrderedCollection new.
	
	allSenders do: [ :aSender | 
		actualMessageSendersCollector := aSender actualSendersOf: aSentCompiledMethod.
		actualMessageSendersCollector hasSureMessageSends ifTrue: [ sureSenders add: aSender ].
		actualMessageSendersCollector hasPossibleMessageSends ifTrue: [ 
			possibleSenders add: (PossibleSender in: aSender withPossibleMessageSends: actualMessageSendersCollector possibleMessageSends) ]].
		
	^Array with: sureSenders with: possibleSenders 
]

{ #category : #'*LiveTyping' }
SmalltalkImage >> allActualSendersOn: sentSelector forAll: types whenSomeAreNotImplemented: someNotImplementedBlock whenNoImplementors: noImplementorsBlock [
	
	| collector |
	
	collector := MultiImplementorsActualMessageSendsCollector 
		on: sentSelector 
		forAll: types
		whenSomeAreNotImplemented: someNotImplementedBlock 
		whenNoImplementors: noImplementorsBlock.
		
	collector value.
	
	^collector 
	
]

{ #category : #'*LiveTyping' }
SmalltalkImage >> browseActualImplementorsFinder: anActualImplementorsFinder [

	| label |
	
	label := anActualImplementorsFinder finderTypeString, ' Implementors of ' , anActualImplementorsFinder selector, ' in ', anActualImplementorsFinder types asCommaStringAnd.
	
	(anActualImplementorsFinder implementorsIsEmpty or: [ anActualImplementorsFinder notImplementedIsEmpty ]) 
		ifTrue: [ 
			Smalltalk 
				browseMessageList: anActualImplementorsFinder implementorsSorted
				name: label ]
		ifFalse: [
			Smalltalk 
				browseMessageList: anActualImplementorsFinder implementorsSorted, anActualImplementorsFinder notImplementedSorted 
				name: label
				prefixedWith: '[', anActualImplementorsFinder implementorsSize printString, '/', anActualImplementorsFinder totalSize printString, '] '
				autoSelect: nil ]


]

{ #category : #'*LiveTyping' }
SmalltalkImage >> browseAllActualImplementorsOf: aSelector for: aClass [

	self browseAllActualImplementorsOf: aSelector forAll: (Array with: aClass)

]

{ #category : #'*LiveTyping' }
SmalltalkImage >> browseAllActualImplementorsOf: aSelector forAll: types [

	| allActualImplementors |
	
	allActualImplementors := self allActualImplementorsOf: aSelector forAll: types.
	self browseActualImplementorsFinder: allActualImplementors 
]

{ #category : #'*LiveTyping' }
SmalltalkImage >> browseAllActualLocalImplementorsOf: sentSelector forAll: types [

	| allActualLocalImplementors |
	
	allActualLocalImplementors := self allActualLocalImplementorsOf: sentSelector forAll: types.
	self browseActualImplementorsFinder: allActualLocalImplementors 
]

{ #category : #'*LiveTyping' }
SmalltalkImage >> browseAllActualSendersOn: aSentCompiledMethod [ 
	
	self browseAllActualSendersOn: aSentCompiledMethod selector forAll: { aSentCompiledMethod methodClass }.


]

{ #category : #'*LiveTyping' }
SmalltalkImage >> browseAllActualSendersOn: aSentSelector forAll: aReceiverTypes [  
	"
	Smalltalk browseAllActualSendersOn: #digitLength forAll: (Array with: LargePositiveInteger with: SmallInteger)
	"
	
	| collector title |
	
	collector := self 
		allActualSendersOn: aSentSelector 
		forAll: aReceiverTypes
		whenSomeAreNotImplemented: [ :notImplemented | 
			(self confirm: aSentSelector, ' is not implemented in: ', notImplemented asCommaStringAnd, '. Continue?') ifFalse: [ ^self ]] 
		whenNoImplementors: [  ^self inform: 'There are no implementors of ', aSentSelector , ' to look actual senders of' ].
		
	collector messageListSize = 0 ifTrue: [
		^ PopUpMenu inform: ('There are no actual senders of ', aSentSelector, ' implemented at\', aReceiverTypes asCommaStringAnd) withNewLines ].

	title := 'Actual Senders of ' , aSentSelector, ' implemented at ', collector sentImplementorsAsString.
	collector messageListSize > 1 ifTrue: [ title := '[', collector messageListSize printString, '] ', title ].

	MessageSetWindow 
		openMessageList: collector messageList 
		label: title 
		types: aReceiverTypes
		selector: aSentSelector 
]

{ #category : #'*LiveTyping' }
SmalltalkImage >> browseAllActualmplementorsOf: aMethod [

	self browseAllActualImplementorsOf: aMethod selector for: aMethod methodClass

]

{ #category : #'*LiveTyping' }
SmalltalkImage >> browseMessageList: messageList name: label prefixedWith: labelPrefix autoSelect: autoSelectString [

	^MessageSetWindow
		openMessageList: messageList
		label: labelPrefix, label
		autoSelect: autoSelectString


]
