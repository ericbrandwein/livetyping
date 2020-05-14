Class {
	#name : #InnerTextMorph,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
InnerTextMorph >> showBalloon: msgString hand: aHand [

	| localMousePosition mousePositionInText ballonTypeInfo |
	
	localMousePosition := self internalizeFromWorld: aHand location translation.
	mousePositionInText := (textComposition characterBlockAtPoint: localMousePosition) stringIndex.
	ballonTypeInfo := editor balloonTypeInfoAt: mousePositionInText.
	
	^super showBalloon: ballonTypeInfo hand: aHand

]

{ #category : #'as yet unclassified' }
InnerTextMorph >> wantsBalloon [
	
	^self shouldShowBalloonHelp and: [ Preferences balloonHelpEnabled ]
]
