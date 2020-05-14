Class {
	#name : #EqualTypeCast,
	#superclass : #OneTypeCast,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #casting }
EqualTypeCast >> cast: originalTypes [
	
	^ { typeToCastTo }
]
