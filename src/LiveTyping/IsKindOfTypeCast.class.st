Class {
	#name : #IsKindOfTypeCast,
	#superclass : #OneTypeCast,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #casting }
IsKindOfTypeCast >> cast: originalTypes [
	
	^originalTypes select: [ :aType | aType includesBehavior: typeToCastTo ].
]
