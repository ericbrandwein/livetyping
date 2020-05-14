Class {
	#name : #TextModelMorph,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
TextModelMorph >> doNotShowBalloonHelp [

	super doNotShowBalloonHelp.
	scroller doNotShowBalloonHelp
]
