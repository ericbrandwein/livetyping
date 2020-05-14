Extension { #name : #Encoder }

{ #category : #'*LiveTyping' }
Encoder >> actualMessageSendKeywordAndParameterPositionsOfAll: compiledMethods 
		at: aParameterIndex 
		of: aSelector
		ifAbsent: absentBlock 
		withPossibleMessageSends: shouldAddPossibleMessageSends 
		using: aMethodNode [
		
	^self 
		withActualMessageSendsOfAll: compiledMethods 
		do: [ :aMessageSendNode | aMessageSendNode keywordAndParameterPositionAt: aParameterIndex encodedWith: self ifAbsent: absentBlock ]
		ifAbsent: absentBlock 
		withPossibleMessageSends: shouldAddPossibleMessageSends 
		sortingWith: [ :left :right | left first <= right first ]
		using: aMethodNode 
]

{ #category : #'*LiveTyping' }
Encoder >> actualMessageSendKeywordPositionsOfAll: compiledMethods at: aKeywordIndex ifAbsent: absentBlock withPossibleMessageSends: shouldAddPossibleMessageSends using: aMethodNode [ 

	^self 
		withActualMessageSendsOfAll: compiledMethods 
		do: [ :aMessageSendNode | (aMessageSendNode keywordPositionAt: aKeywordIndex) first ] 
		ifAbsent: absentBlock 
		withPossibleMessageSends: shouldAddPossibleMessageSends 
		sortingWith: [ :left :right | left <= right ] 
		using: aMethodNode 

]

{ #category : #'*LiveTyping' }
Encoder >> actualMessageSendLastPositionsOfAll: compiledMethods ifAbsent: absentBlock withPossibleMessageSends: shouldAddPossibleMessageSends using: aMethodNode [

	^self 
		withActualMessageSendsOfAll: compiledMethods 
		do: [ :aMessageSendNode | (sourceRanges at: aMessageSendNode) last ]
		ifAbsent: absentBlock 
		withPossibleMessageSends: shouldAddPossibleMessageSends 
		sortingWith: [ :left :right | left <= right ] 
		using: aMethodNode 
]

{ #category : #'*LiveTyping' }
Encoder >> actualMessageSendsSelectorPositionsOfAll: compiledMethods ifAbsent: absentBlock withPossibleMessageSends: shouldAddPossibleMessageSends using: aMethodNode [  
	
	^self 
		withActualMessageSendsOfAll: compiledMethods 
		do:  [ :aMessageSendNode | aMessageSendNode keywordRanges ] 
		ifAbsent: absentBlock 
		withPossibleMessageSends: shouldAddPossibleMessageSends 
		sortingWith: [ :left :right | left first first < right first first ] 
		using: aMethodNode.

]

{ #category : #'*LiveTyping' }
Encoder >> topParseNodeIncluding: aPosition ifAbsent: anAbsentBlock [

	| biggestRangeSize nodeWithRangeAtPosition |

	biggestRangeSize := 0.
	nodeWithRangeAtPosition := nil.

	sourceRanges associationsDo: [ :nodeAtRange |
		self withRangesOf: nodeAtRange including: aPosition do: [ :aRange | | currentNodeRangeSize |
				currentNodeRangeSize := aRange size.
				currentNodeRangeSize > biggestRangeSize ifTrue: [
					biggestRangeSize := currentNodeRangeSize.
					nodeWithRangeAtPosition := nodeAtRange key -> aRange ]]].

	^ nodeWithRangeAtPosition ifNil: anAbsentBlock ifNotNil: [ nodeWithRangeAtPosition ]
			
]

{ #category : #'*LiveTyping' }
Encoder >> withActualMessageSendsOfAll: compiledMethods 
	do: aMessageSendNodeBlock 
	ifAbsent: absentBlock 
	withPossibleMessageSends: shouldAddPossibleMessageSends 
	sortingWith: aSortBlock 
	using: aMethodNode [ 
	
	| ranges sortedRanges sendersCollector sender |
	
	sender := class>>selector.
	ranges := Set new.
	compiledMethods do: [ :aCompiledMethod |
		sendersCollector := sender actualSendersOf: aCompiledMethod using: aMethodNode.
		ranges addAll: (sendersCollector sureMessageSends collect: aMessageSendNodeBlock).
		shouldAddPossibleMessageSends ifTrue: [
			ranges addAll: (sendersCollector possibleMessageSends collect: [ :aPossibleMessageSend | aMessageSendNodeBlock value: aPossibleMessageSend key])]].
		
	ranges isEmpty ifTrue: [ ^absentBlock value ].
	sortedRanges := ranges asSortedCollection: aSortBlock.

	^sortedRanges 
]
