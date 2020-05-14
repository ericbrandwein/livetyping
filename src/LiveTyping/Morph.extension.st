Extension { #name : #Morph }

{ #category : #'*LiveTyping' }
Morph >> doNotShowBalloonHelp [

	self setProperty: #showBalloonHelp toValue: false
]

{ #category : #'*LiveTyping' }
Morph >> shouldShowBalloonHelp [

	^self valueOfProperty: #showBalloonHelp ifAbsent: [ true ]
	
]

{ #category : #'*LiveTyping' }
Morph >> showBalloonHelp [

	self setProperty: #showBalloonHelp toValue: true
]
