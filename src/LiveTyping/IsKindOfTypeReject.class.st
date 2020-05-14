Class {
	#name : #IsKindOfTypeReject,
	#superclass : #OneTypeCast,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #casting }
IsKindOfTypeReject >> cast: originalTypes [

	^originalTypes reject: [ :aType | aType includesBehavior: typeToCastTo ]
]
