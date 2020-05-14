Class {
	#name : #EqualTypeReject,
	#superclass : #OneTypeCast,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #casting }
EqualTypeReject >> cast: originalTypes [

	^ originalTypes reject: [ :aType | aType = typeToCastTo ]
]
