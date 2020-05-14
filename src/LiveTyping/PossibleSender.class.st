Class {
	#name : #PossibleSender,
	#superclass : #Object,
	#instVars : [
		'possibleMessageSends'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
PossibleSender class >> in: aSender withPossibleMessageSends: aPossibleMessageSends [

	| newInstance |
	
	newInstance := self method: aSender.
	^newInstance initializeWithPossibleMessageSends: aPossibleMessageSends 
]

{ #category : #'string version' }
PossibleSender class >> possibleSenderStringVersionHeader [
	
	^'(Possible) - '
]

{ #category : #'possible message sends' }
PossibleSender >> addPossibleMessageSends: aPossibleMessageSend [

	possibleMessageSends add: aPossibleMessageSend 
]

{ #category : #initialization }
PossibleSender >> initializeWithPossibleMessageSends: aPossibleMessageSends [ 
	
	possibleMessageSends := Set newFrom: aPossibleMessageSends.
	self prefixStringVersionWith: self class possibleSenderStringVersionHeader 
]

{ #category : #testing }
PossibleSender >> isPossibleSender [

	^true
]

{ #category : #'message sends ranges' }
PossibleSender >> rangesOf: aSentSelector whenSendTo: aReceiverTypes [

	| compiledMethod possibleMessageSendsAsStrings ranges |
	
	ranges := Set new.
	compiledMethod := self compiledMethodIfAbsent: [ ^#() ].
	
	"This is good enoght but not nice... parse node equality is identity and the possible message send nodes where generated
	using other method node that the one we use here, so I look for printString in the sourceRanges, a hack that works but could
	generate invalid ranges if the printString of really different message sends are equal... but is good enought for now.
	I do not use methodNode rawSourceRanges becuase it regenerates de code and it is necessary here... I beleive :-).
	If the compiledMethod would keep the methodNode all this would not be necesary... - Hernan"
	possibleMessageSendsAsStrings := possibleMessageSends collect: [ :possibleMessageSend | possibleMessageSend key printString ].
	compiledMethod methodNode encoder rawSourceRanges keysAndValuesDo: [ :parseNode :range |
		(possibleMessageSendsAsStrings includes: parseNode printString) ifTrue: [ ranges add: range ]].
	
	^ranges
]

{ #category : #'possible message sends' }
PossibleSender >> withPossibleMessageSendsDo: aBlock [
	
	possibleMessageSends do: aBlock
]
